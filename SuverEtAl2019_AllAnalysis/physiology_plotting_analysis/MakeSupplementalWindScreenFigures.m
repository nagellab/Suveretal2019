%%
% Make supplemental figure quantifying the wind neuron screen
%
% Suver et al. 2019
%%

function [FigSupp_trace_29C10 FigSupp_tuning_29C10 FigSupp_trace_38H10 FigSupp_tuning_38H10 FigSupp_trace_54H01 FigSupp_tuning_54H01] ...
    = MakeSupplementalWindScreenFigures()
load_figure_constants;
ERROR_AVG_VM_TRACES = 0;
SPIKERATE = 0;
TRACE_TYPE = 4;

load(['../SuverEtAl2019_DATA/29C10.mat'])
traces_29C10 = traces;

load(['../SuverEtAl2019_DATA/38H10.mat'])
traces_38H10 = traces;

load(['../SuverEtAl2019_DATA/54H01.mat'])
traces_54H01 = traces;

%% Plot 29C10 wind and odor tuning curves
trace.traces = traces_29C10;
trace.name = ['29C10 with odor, N = ' num2str(traces_29C10.numFlies)];
FigSupp_trace_29C10 = MakeTracePairFigure_withOdor(trace, ERROR_AVG_VM_TRACES, tracesPosition1, SPIKERATE);
tt.traces = traces_29C10;
tt.name = ['29C10 wind+odor tuning'];
FigSupp_tuning_29C10 = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, tuningPosition1, SPIKERATE);

%% Plot 38H10 wind and odor tuning curves
trace.traces = traces_38H10;
trace.name = ['38H10 with odor, N = ' num2str(traces_38H10.numFlies)];
FigSupp_trace_38H10 = MakeTracePairFigure_withOdor(trace, ERROR_AVG_VM_TRACES, tracesPosition1, SPIKERATE);
tt.traces = traces_38H10;
tt.name = ['38H10 wind+odor tuning'];
FigSupp_tuning_38H10 = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, tuningPosition1, SPIKERATE);

%% Plot 54H01 wind and odor tuning curves
trace.traces = traces_54H01;
trace.name = ['54H01 with odor, N = ' num2str(traces_54H01.numFlies)];
FigSupp_trace_54H01 = MakeTracePairFigure_withOdor(trace, ERROR_AVG_VM_TRACES, tracesPosition1, SPIKERATE);
tt.traces = traces_54H01;
tt.name = ['54H01 wind+odor tuning'];
FigSupp_tuning_54H01 = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, tuningPosition1, SPIKERATE);

