%%
% Plot zoomed-in piece of raw data
% Suver et al. 2019
%%

function fig = PlotRawTrace(rawTrace,expt,cc,SPIKING,STIM, position)
TEST = 0;
load_figure_constants
space = 0.25; %shift spike dot by this many mV
fig = figure('color', 'w', 'Position', position); hold on
trace = rawTrace(raw_start_stim:(raw_start_stim+raw_len_stim));

if SPIKING
    spikeTimes = SpikeDetect_singleRawTrace(trace, TEST);
end

figure(fig)
bottomRect = mean(trace)-ht_stim/2;
rectangle('Position', [0 bottomRect raw_len_stim ht_stim], 'Edgecolor', color_zoom)
plot(trace, 'Color', cc) %% plot raw data
% plot dots over spikes
if SPIKING
   for sp = 1:length(spikeTimes)
      spTime = spikeTimes(sp); %actual spike detection occurs on the rising edge
      minEndInd = min([(spTime+100) length(trace)]);
      [peakSpVal peakSpTime] = max(trace(spTime:minEndInd)); %plot spike time right above peak of spike!
      plot(spTime+peakSpTime, peakSpVal+space, 'Marker', '.', 'Markersize', markerSize_spikes, 'Color', 'k') 
   end
end

axis off