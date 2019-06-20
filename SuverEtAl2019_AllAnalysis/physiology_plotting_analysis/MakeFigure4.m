%%
% Plot WPN raw, averate, and steady state responses
%
% Suver et al. 2019
%%

function [Fig4CD Fig4E Fig4GI Fig4H Fig4L Fig4M Fig4J Fig4K Fig4_supp1A Fig4_supp1B Fig4_supp2 Fig4_supp3 Fig4_supp4 Fig4_rawZoom_wPNIpsi Fig4_rawZoom_wPNContra] = ...
    MakeFigure4(ERROR_AVG_VM_TRACES, TRACE_TYPE)

load_figure_constants;
ONSET = 0;
TEST = 0;
SPIKERATE = 0; %all plots in Vm except supplemental Fig. 1

%load data structures
load(['../SuverEtAl2019_DATA/70B12_free.mat'])
traces_wPN = traces;

load(['../SuverEtAl2019_DATA/70B12_ipsi.mat'])
traces_wPN_ipsi = traces;

load(['../SuverEtAl2019_DATA/70B12_contra.mat'])
traces_wPN_contra = traces;

load(['../SuverEtAl2019_DATA/70B12_ipsiRemove.mat'])
traces_wPN_ipsiRemove = traces;

load(['../SuverEtAl2019_DATA/70B12_contraRemove.mat'])
traces_wPN_contraRemove = traces;

load(['../SuverEtAl2019_DATA/70B12_bilatRemove.mat'])
traces_wPN_bilatRemove = traces;

%% combined ipsi and contra glue/remove traces --> weighted sums of averages and errors
[traces_wPN_ipsiX traces_wPN_contraX] = CombineGlueRemoveTraces(traces_wPN_ipsi, traces_wPN_ipsiRemove, traces_wPN_contra, traces_wPN_contraRemove);

% Raw traces of interest (hard-coded in load_figure_constants!)
% typical example selected
load([filename_wPNRawExample]); 
rawTrace_wPN_ipsi = data(trialNum_wPN_ipsi).Vm;
rawTrace_wPN_contra = data(trialNum_wPN_contra).Vm;

%% Plot Spike Rate supplemental plots
%Time traces
SPIKERATE = 1;
trace1.traces = nan(size(rawTrace_wPN_ipsi));
trace1.name = [' '];
trace2.traces = traces_wPN;
traces_wPN
trace2.name = ['WPN spike rate, N = ' num2str(traces_wPN.numFlies)];
Fig4_supp1A = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPosition4, SPIKERATE);

%% Plot spike rate tuning 
tt.traces = traces_wPN;
tt.name = ['WPN spike rate tuning'];
Fig4_supp1B = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, tuningPosition3, SPIKERATE);

%% All rest of plots will be Vm
SPIKERATE = 0;

%% Plot wPN raw and avg traces
trace1.traces = [rawTrace_wPN_ipsi rawTrace_wPN_contra];
trace1.name = ['raw WPN traces (ipsi and contra)'];
trace2.traces = traces_wPN;
trace2.name = ['avg WPN traces, N = ' num2str(traces_wPN.numFlies)];
Fig4CD = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPosition3, SPIKERATE);

%%
%% Make raw trace
Fig4_rawZoom_wPNIpsi = PlotRawTrace(rawTrace_wPN_ipsi,expt_wPN,color_rawTrace,1,1, rawTraceZoomPosition3) %plot raw trace wtih spike times, during stimulus
Fig4_rawZoom_wPNContra = PlotRawTrace(rawTrace_wPN_contra,expt_wPN,color_rawTrace,1,1, rawTraceZoomPosition4) %plot raw trace wtih spike times, during stimulus

%% Plot wPN tuning
tt.traces = traces_wPN;
tt.name = ['WPN wind tuning'];
Fig4E = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, tuningPosition3, SPIKERATE);

%% Plot wPN ipsi and contra GLUE traces
trace1.traces = traces_wPN_ipsi;
trace1.name = ['WPN ipsi glue, N = ' num2str(traces_wPN_ipsi.numFlies)];
trace2.traces = traces_wPN_contra;
trace2.name = ['WPN contra glue, N = ' num2str(traces_wPN_contra.numFlies)];
Fig4_supp2 = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPosition1, SPIKERATE);

%% Plot wPN DUAL REMOVE traces
size(rawTrace_wPN_ipsi)
trace1.traces = nan(size(rawTrace_wPN_ipsi));
trace1.name = [' '];
trace2.traces = traces_wPN_bilatRemove;
trace2.name = ['WPN bilat remove, N = ' num2str(traces_wPN_bilatRemove.numFlies)];
Fig4K = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPosition1, SPIKERATE);

%% Plot wPN ipsi and contra REMOVE traces
trace1.traces = traces_wPN_ipsiRemove;
trace1.name = ['WPN ipsi remove, N = ' num2str(traces_wPN_ipsiRemove.numFlies)];
trace2.traces = traces_wPN_contraRemove;
trace2.name = ['WPN contra remove, N = ' num2str(traces_wPN_contraRemove.numFlies)];
Fig4_supp3 = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPosition2, SPIKERATE);

%% Plot wPN ipsi and contra *combined glue+removal* traces!
trace1.traces = traces_wPN_ipsiX;
trace1.name = ['WPN ipsi X, N = ' num2str(traces_wPN_ipsiX.numFlies)];
trace2.traces = traces_wPN_contraX;
trace2.name = ['WPN contra X, N = ' num2str(traces_wPN_contraX.numFlies)];
Fig4GI = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPosition2, SPIKERATE);


%% Plot ipsi-contra antenna manipulation scatter plots

% Plot ipsi and contra glue vs. remove
trace1.name = ['WPN ipsi glue'];
trace1.traces = traces_wPN_ipsi;
trace2.name = ['WPN ipsi rem'];
trace2.traces = traces_wPN_ipsiRemove;
trace3.name = ['WPN contra glue'];
trace3.traces = traces_wPN_contra;
trace4.name = ['WPN contra rem'];
trace4.traces = traces_wPN_contraRemove;

all_traces = {trace1; trace2; trace3; trace4;};  
testPairs = ([[1 2];[3 4]]); %t-test comparison between glue and removal sets
starLevels = [1 1]; %match # pairs above; sets y-position of statistical stars!
Fig4_supp4 = MakeIpsiContraPlot(all_traces, ONSET, TEST, diffFigPosition1, yAxis_ipsiContra_wPN, testPairs, starLevels);

% Plot intact, ipsi, contra, and bilateral removal
% based on above statistical comparison, can combine antenna glue and removal data!
trace1.name = ['WPN intact'];
trace1.traces = traces_wPN;
trace2.name = ['WPN ipsi X'];
trace2.traces = traces_wPN_ipsiX;
trace3.name = ['WPN contra X'];
trace3.traces = traces_wPN_contraX;
trace4.name = ['WPN bilat remove'];
trace4.traces = traces_wPN_bilatRemove;

all_traces = {trace1; trace2; trace3; trace4;}; 
testPairs = ([[1 2];[1 3];[1 4];]);
starLevels = [1 2 3]; %match # pairs above; sets y-position of statistical stars!
Fig4M = MakeIpsiContraPlot(all_traces, ONSET, TEST, diffFigPosition2, yAxis_ipsiContra_wPN, testPairs, starLevels);

%% Plot ipsiX tuning
tt.traces = traces_wPN_ipsiX;
tt.name = ['WPN ipsiX wind tuning'];
Fig4H = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, tuningPosition1, SPIKERATE);

%% Plot contraX tuning
tt.traces = traces_wPN_contraX;
tt.name = ['WPN contraX wind tuning'];
Fig4J = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, tuningPosition1, SPIKERATE);

%% Plot bilateral removal tuning
tt.traces = traces_wPN_bilatRemove;
tt.name = ['WPN bilateral remove wind tuning'];
Fig4L = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, tuningPosition1, SPIKERATE);

