%%
% Make supplemental figures quantifying wind vs. wind+odor responses
% - for 70G01-GAL4 (APN3) and 70B12-GAL4 (WPN)
%
% Suver et al. 2019
%%

function [Fig_supp_APN3_WOTuning Fig_supp_APN3_WOTuning_indv Fig_supp_WPN_WOTuning Fig_supp_WPN_WOTuning_indv ...
    Fig_supp_trace_PID Fig_supp_trace_ANE Fig_supp_trace_APN3_ODOR Fig_supp_trace_WPN_ODOR] ...
    = MakeWindOdorSupplementalFigure(ERROR_AVG_VM_TRACES)
load_figure_constants;
TRACE_TYPE = 4;
SPIKERATE = 0;

%load data structures
load(['../SuverEtAl2019_DATA/PID.mat'])
traces_PID = traces;

load(['../SuverEtAl2019_DATA/2015_08_28_13.mat'])
traces_ANE = traces;

load(['../SuverEtAl2019_DATA/70G01_all.mat'])
traces_APN3 = traces;

load(['../SuverEtAl2019_DATA/70B12.mat'])
traces_WPN = traces;

%% Plot APN3 wind and odor tuning curves
tt.traces = traces_APN3;
tt.name = ['APN3 wind+odor tuning'];
Fig_supp_APN3_WOTuning = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, tuningPosition1, SPIKERATE);

%% Plot wind averages (cross-direction) and odor averages (cross-direction)
Fig_supp_APN3_WOTuning_indv = MakeWindOdorAvgFigure(tt, tuningPosition1, yAxis_quant_WindOdor1);

%% Plot WPN wind and odor tuning
tt.traces = traces_WPN;
tt.name = ['WPN wind+odor tuning'];
Fig_supp_WPN_WOTuning = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, tuningPosition2, SPIKERATE);

%% Plot wind averages (cross-direction) and odor averages (cross-direction)
Fig_supp_WPN_WOTuning_indv = MakeWindOdorAvgFigure(tt, tuningPosition2, yAxis_quant_WindOdor2);

%% Plot PID calibration
trace.traces = traces_PID;
trace.name = ['PID measurement, N = ' num2str(traces_PID.numFlies) ' trials'];
Fig_supp_trace_PID = MakeTracePairFigure_withOdor(trace, ERROR_AVG_VM_TRACES, tracesPosition1, SPIKERATE);

%% Plot anemometer (with odor) calibration
trace.traces = traces_ANE;
trace.name = ['Anemometer with odor, N = 5 trials'];
Fig_supp_trace_ANE = MakeTracePairFigure_withOdor(trace, ERROR_AVG_VM_TRACES, tracesPosition2, SPIKERATE);

%% Plot APN3 with odor traces
trace.traces = traces_APN3;
trace.name = ['APN3 with odor, N = ' num2str(traces_APN3.numFlies)];
Fig_supp_trace_APN3_ODOR = MakeTracePairFigure_withOdor(trace, ERROR_AVG_VM_TRACES, tracesPosition3, SPIKERATE);

%% Plot wPN with odor traces
trace.traces = traces_WPN;
trace.name = ['WPN with odor, N = ' num2str(traces_WPN.numFlies)];
Fig_supp_trace_WPN_ODOR = MakeTracePairFigure_withOdor(trace, ERROR_AVG_VM_TRACES, tracesPosition4, SPIKERATE);

