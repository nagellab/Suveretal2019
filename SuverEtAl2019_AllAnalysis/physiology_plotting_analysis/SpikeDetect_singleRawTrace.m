%%
% detect spikes in a single trace
%
% Suver et al. 2019
%%

function spikeTimes = SpikeDetect_singleRawTrace(trace, TEST)

DOUBLE_THRESH = 40; %minimum distance between two spikes (/10000 to get rate) 
THRESH = 0.018;
Fs = 10000; %samples/sec
BANDPASS_LOW = 20; %Hz
Wn = [BANDPASS_LOW];
N = 4;
Fnorm = BANDPASS_LOW/(Fs/2);
paddingAmt = 300; %pad front and end of trace (with real baseline data) for spike rate estimate at ends
%% bandpass filter using butterworth filter (using filtfilt)

%% FIR lowpass filter
df = designfilt('lowpassfir','FilterOrder', 500, 'CutoffFrequency',Fnorm);
vm = trace;

% apply FIR lowpass filter to raw trace to filter out spikes
D = mean(grpdelay(df)); %filter delay in samples
paddedVm = [vm(1:paddingAmt); vm; vm(end-paddingAmt:end)]; %pad ends of trace to avoid tail effect of filter
yy = filter(df,[paddedVm; zeros(D,1)]);
vm_noSpikes = yy(D+1:end);
vm_noSpikes = vm_noSpikes(paddingAmt+2:end-paddingAmt); %crop off padding

meanVm = mean(vm);
vm = vm - meanVm;

if TEST
    figure('Color', 'w','Position',[50,50,1000,900]);
    subplot(2,1,1)
    hold on
    ylabel('membrane potential (mV)')
    plot(vm, 'k')
    plot(vm_noSpikes-meanVm, 'b')
end

diffVm = diff(vm);
if TEST; plot(diffVm, 'y'); end

%smooth difference to avoid double-peaks
smoothVm = smooth(diffVm, 20);
if TEST; plot(smoothVm, 'c'); end

%get difference of Vm - gives window around spike peak
diffVm = smoothVm>THRESH;
if TEST; plot(diffVm, 'b'); end %enlarged

%find rise and fall times of the spike zone
diffChanges = diff(diffVm);
if TEST; plot(diffChanges, 'm'); end

%find rise times of diff signal
[spikeInds spikeVals] = find(diffChanges>0);

%eliminate double-crossings
[doubles ~] = find(diff(spikeInds)<DOUBLE_THRESH);
doubleInds = spikeInds(doubles); %record doubles for the record
spikeInds(doubles) = 0;
spikeInds = spikeInds(spikeInds~=0); %strike doubles from the spike record!

%plot the spikes on top of membrane potential, along with rejected doubles
if TEST
    if ~isempty(spikeInds)
        plot(spikeInds, mean(vm), 'r*') %plot red stars where spikes occur!
        if ~isempty(doubleInds); plot(doubleInds, mean(vm), 'm*'); end %plot doubles of spikes in magenta
        plot(spikeInds, vm(spikeInds), 'g*') %plot spikes locked to the Vm trace
    end
end

%% Estimate instantaneous spike rate using a gaussian?
if TEST
    subplot(2,1,2); hold on
    plot(vm, 'k')
    ylabel('spike rate (Hz)')
    xlabel('samples')
    hold on
end
%% COMPUTE INSTANTANEOUS SPIKE RATE!
EXT_WIN = 30;
SAMPLERATE = 10000; %hard-coded
% Estimate instantaneous spike rate using a Gaussian window with
% standard deviation of 20 ms:
sigmaMS = 20; %in ms
sigma = sigmaMS*(10^-3)*SAMPLERATE; %translate to indices
WIN = SAMPLERATE;
mu = 500;

spikeTimes = spikeInds;