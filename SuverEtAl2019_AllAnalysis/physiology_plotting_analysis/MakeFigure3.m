%%
% Make Figure 2 of Suver et al. 2018
% aPN2 and aPN3 raw, average traces
%
% Suver et al. 2019
%%

function [Fig3BC Fig3D Fig3FG Fig3H Fig3_ipsiContraAPN2 Fig3_ipsiContraAPN3 Fig3k Fig3_suppA Fig3_suppB Fig3_suppCD Fig3_suppEF Fig3_rawZoomaPN2 Fig3_rawZoomaPN3] ...
    = MakeFigure3(ERROR_AVG_VM_TRACES, TRACE_TYPE, TITLES)
load_figure_constants;
ONSET = 0;
TEST = 0;

%load data structures
load(['../SuverEtAl2019_DATA/24C06_free.mat'])
traces_aPN2 = traces;

load(['../SuverEtAl2019_DATA/70G01_free.mat'])
traces_aPN3 = traces;

load(['../SuverEtAl2019_DATA/24C06_ipsi.mat'])
traces_aPN2_ipsi = traces;

load(['../SuverEtAl2019_DATA/70G01_ipsi.mat'])
traces_aPN3_ipsi = traces;

load(['../SuverEtAl2019_DATA/24C06_contra.mat'])
traces_aPN2_contra = traces;

load(['../SuverEtAl2019_DATA/70G01_contra.mat'])
traces_aPN3_contra = traces;

load(['../SuverEtAl2019_DATA/24C06_free_NORM.mat'])
traces_aPN2_norm = traces;

load(['../SuverEtAl2019_DATA/70G01_free_NORM.mat'])
traces_aPN3_norm = traces;


% Raw traces of interest (hard-coded!)
% typical example selected
load([filename_aPN2]); rawTrace_aPN2 = data(trialNum_aPN2).Vm;
dir = data(trialNum_aPN2).valveState/2;
raw_aPN2_dir = directionNames{dir};

load([filename_aPN3]); 
rawTrace_aPN3 = data(trialNum_aPN3).Vm;

%% Plot Vm for most plots (spikerate supplemental for aPN3)
SPIKERATE = 0;

%% Supplemental aPN2 and aPN3 antenna removal
%% Plot pairs of aPN2 traces
trace1.traces = traces_aPN2_ipsi;
trace1.name = ['avg APN2 ipsi remove, N = ' num2str(traces_aPN2_ipsi.numFlies)];
trace2.traces = traces_aPN2_contra;
trace2.name = ['avg APN2 contra remove, N = ' num2str(traces_aPN2_contra.numFlies)];
Fig3_suppCD = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPosition1, SPIKERATE);

%% Plot aPN2 tuning
tt.traces = traces_aPN2;
tt.name = ['APN2 wind tuning'];
Fig3D = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, tuningPosition1, SPIKERATE);

%% Plot pairs of aPN2 traces
trace1.name = ['raw APN2 trace (' raw_aPN2_dir ')'];
trace1.traces = rawTrace_aPN2;
trace2.traces = traces_aPN2;
trace2.name = ['avg APN2 traces, N = ' num2str(traces_aPN2.numFlies)];
Fig3BC = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPosition1, SPIKERATE);

%% Make raw trace
Fig3_rawZoomaPN2 = PlotRawTrace(rawTrace_aPN2,expt_aPN2,color_rawTrace,0,1, rawTraceZoomPosition1) %plot raw trace wtih spike times, during stimulus

%% Make raw trace
Fig3_rawZoomaPN3 = PlotRawTrace(rawTrace_aPN3,expt_aPN3,color_rawTrace,1,1, rawTraceZoomPosition2) %plot raw trace wtih spike times, during stimulus

%% Plot supplemental aPN3 spike rate 
%% Plot aPN3 tuning
tt.traces = traces_aPN3;
tt.name = ['APN3 spike rate tuning'];
Fig3_suppA = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, tuningPosition2, 1);

%% Plot pairs of aPN3 traces
trace1.name = [' '];
trace1.traces = nan(size(rawTrace_aPN3));
trace2.traces = traces_aPN3;
trace2.name = ['avg APN3 spike rate, N = ' num2str(traces_aPN3.numFlies)];
Fig3_suppB = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPosition2, 1);

%% Plot pairs of aPN3 traces
trace1.traces = traces_aPN3_ipsi;
trace1.name = ['avg APN3 ipsi remove, N = ' num2str(traces_aPN3_ipsi.numFlies)];

trace2.traces = traces_aPN3_contra; 
trace2.name = ['avg APN3 contra remove, N = ' num2str(traces_aPN3_contra.numFlies)];% ' num2str(traces_aPN3_contra.numFlies)];
Fig3_suppEF = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPosition2, SPIKERATE);

%% Plot aPN3 tuning
tt.traces = traces_aPN3;
tt.name = ['APN3 wind tuning'];
Fig3H = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, tuningPosition2, SPIKERATE);

%% Plot pairs of aPN3 traces
trace1.name = ['raw APN3 trace (' raw_aPN3_dir ')'];
trace1.traces = rawTrace_aPN3;
trace2.traces = traces_aPN3;
trace2.name = ['avg APN3 traces, N = ' num2str(traces_aPN3.numFlies)];
Fig3FG = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPosition2, SPIKERATE);

%% Plot normalized APN2+APN3 tuning
tt.traces = [];
tt.traces{1} = traces_aPN2_norm;
tt.traces{2} = traces_aPN3_norm;
tt.name = ['APN2,3 normalized wind tuning'];
Fig3k = MakeTuningCurveFigure(tt, 3, TITLES, tuningPosition3, SPIKERATE);


%% Plot scatter plot of each ipsi-contra result for antenna removal, etc.
%load data structures
%load data structures
load(['../SuverEtAl2019_DATA/24C06_free.mat'])
traces_aPN2 = traces;

load(['../SuverEtAl2019_DATA/70G01_free.mat'])
traces_aPN3 = traces;

load(['../SuverEtAl2019_DATA/24C06_ipsi.mat'])
traces_aPN2_ipsi = traces;

load(['../SuverEtAl2019_DATA/70G01_ipsi.mat'])
traces_aPN3_ipsi = traces;

load(['../SuverEtAl2019_DATA/24C06_contra.mat'])
traces_aPN2_contra = traces;

load(['../SuverEtAl2019_DATA/70G01_contra.mat'])
traces_aPN3_contra = traces;

trace1.name = ['intact'];
trace1.traces = traces_aPN2;
trace2.name = ['ipsi'];
trace2.traces = traces_aPN2_ipsi;
trace3.name = ['contra'];
trace3.traces = traces_aPN2_contra;
trace4.name = ['intact'];
trace4.traces = traces_aPN3;
trace5.name = ['ipsi'];
trace5.traces = traces_aPN3_ipsi;
trace6.name = ['contra'];
trace6.traces = traces_aPN3_contra;

%% plot ipsi-contra dot plots for APN2 and APN3 separately!
all_traces = {trace1; trace2; trace3;};
testPairs = ([[1 2];[1 3]]);
starLevels = [1 2]; %match # pairs above; sets y-position of statistical stars!
Fig3_ipsiContraAPN2 = MakeIpsiContraPlot(all_traces, ONSET, TEST, diffFigPosition_narrow, yAxis_ipsiContra_aPN2, testPairs, starLevels)
%APN3
all_traces = {trace4; trace5; trace6};
testPairs = ([[1 2];[1 3]]);
starLevels = [1 2]; %match # pairs above; sets y-position of statistical stars!
Fig3_ipsiContraAPN3 = MakeIpsiContraPlot(all_traces, ONSET, TEST, diffFigPosition_narrow, yAxis_ipsiContra_aPN3, testPairs, starLevels)



