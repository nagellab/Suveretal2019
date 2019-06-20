%%
% Plot antenna average tuning plots
% Suver et al. 2019
%%

function [Fig2_anterior Fig2_antTraces Fig2_antTraces_hand Fig2_ane] = MakeFigure2(ERROR, TITLES)

if nargin ~= 2
    display('Please input (1) 0 or 1 (error range over traces) and (2) 0 or 1 (titles or no)')
    display('typical use: MakeFigure2(0,0)')
   return 
end

load_figure_constants;
SPIKERATE = 0;
TRACE_TYPE = 2; %indicated antenna averages (different colors, two averages plotted)

load(['../SuverEtAl2019_DATA/all_anterior.mat'])
traces_all_anterior = traces;

load('../SuverEtAl2019_DATA/Anemometer_2018_03_23.mat')
traces_anemometer = traces;

tt.traces = traces_all_anterior;
numFlies = length(traces_all_anterior.rightDeflect_indv);
tt.name = ['anterior-mount antenna avg, N=' num2str(numFlies)];
Fig2_anterior = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, tuningPosition_antTuning, SPIKERATE);

%%hand-tracked raw trace
load(['../SuverEtAl2019_DATA/2017_01_05_E1_Video_43_trackData'])
track = -trackData.rightAngles;
preWindInds = 1:59;
baseline = mean(track(preWindInds)); track = track-baseline;
rawTrace_hand.trace = track;
rawTrace_hand.name = 'Single hand-tracked trace; -45deg';


%tracking data - time traces
load(['../SuverEtAl2019_DATA/antTracking_2017_01_05_E1'])
RIGHT = 0; %plot right antenna averages

%% raw tracking selection
dir = 2; %-45;
trial = 9;
raw = antTraces.rightTraces_all(dir,:,trial);
rawTrace.trace = raw;
rawTrace.name = 'Single antenna tracking; -45 deg';
avgtraces.antTraces = antTraces;
avgtraces.name = 'Avg left antenna tracking';
Fig2_antTraces = MakeAntennaTraceFigure(rawTrace, avgtraces, ERROR, TITLES, RIGHT, tracesPositionAnt)
Fig2_antTraces_hand = MakeAntennaTraceFigure(rawTrace_hand, avgtraces, ERROR, TITLES, RIGHT, tracesPositionAnt)


%% anemometer calibration
SPIKERATE = 0;
trace1.traces = nan(10000,1);
trace1.name = [' '];
trace2.traces = traces_anemometer;
trace2.name = ['wind velocity'];
Fig2_ane = MakeTracePairFigure(trace1, trace2, ERROR, tracesPosition_ane, SPIKERATE);


%% Calculate inter-antenna angle
[interAntennal_mean, interAntennal_std,interAntennal_indv] = CalculateInterAntennalAngle();
interAntennal_mean
interAntennal_std