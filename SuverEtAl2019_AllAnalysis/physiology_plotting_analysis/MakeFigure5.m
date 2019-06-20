%%
% Make Figure 5 subfigures
% photoablation and dual recording
%
% Suver et al. 2019
%%

function [Fig5_supp1 Fig5_supp2 Fig5_supp3 Fig5_supp4 Fig5_supp5 Fig5_supp6 Fig5_traces Fig5_quant fig_dualTraces fig_dualQuant] = MakeFigure5(ERROR_AVG_VM_TRACES, TRACE_TYPE, TITLES)

load_figure_constants;
ONSET = 0;
TEST = 0;
SPIKERATE = 0; %all plots in Vm except supplemental Fig. 1

%load data structures
load(['../SuverEtAl2019_DATA/70B12_ablate.mat'])
traces_wPN_ablate = traces;

load(['../SuverEtAl2019_DATA/70B12_ablate_ctrl.mat'])
traces_wPN_ablate_ctrl = traces;

%% Plot Spike Rate supplemental plots
%Time traces
SPIKERATE = 1;
trace1.traces = nan(10000,1);
trace1.name = [' '];
trace2.traces = traces_wPN_ablate;
trace2.name = ['WPN ablate spike rate'];
Fig5_supp1 = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPosition4, SPIKERATE);

trace1.traces = nan(10000,1);
trace1.name = [' '];
trace2.traces = traces_wPN_ablate_ctrl;
trace2.name = ['WPN ctrl ablate spike rate'];
Fig5_supp2 = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPosition4, SPIKERATE);


%% Plot spike rate tuning 
tt.traces = traces_wPN_ablate;
tt.name = ['WPN ablate SR tuning'];
Fig5_supp4 = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, tuningPosition3, SPIKERATE);

%% Plot spike rate tuning 
tt.traces = traces_wPN_ablate_ctrl;
tt.name = ['WPN ablate ctrl SR tuning'];
Fig5_supp6 = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, tuningPosition3, SPIKERATE);

%% All rest of plots will be Vm
SPIKERATE = 0;

%% Plot wPN ablate tuning
tt.traces = traces_wPN_ablate;
tt.name = ['wPN ablate tuning'];
Fig5_supp3 = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, tuningPosition3, SPIKERATE);

%% Plot wPN ablate control tuning
tt.traces = traces_wPN_ablate_ctrl;
tt.name = ['WPN ablate ctrl tuning'];
Fig5_supp5 = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, tuningPosition3, SPIKERATE);

%% Plot ablate+ctrl traces
trace1.traces = traces_wPN_ablate;
trace1.name = ['WPN ablate'];
trace2.traces = traces_wPN_ablate_ctrl;
trace2.name = ['WPN ctrl ablate'];
Fig5_traces = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPosition1, SPIKERATE);

%% Plot quantification
% Plot ipsi and contra glue vs. remove
all_traces = {trace1; trace2;};  
testPairs = ([[1 2]]); %t-test comparison between glue and removal sets
starLevels = [1]; %match # pairs above; sets y-position of statistical stars!
Fig5_quant = MakeIpsiContraPlot(all_traces, ONSET, TEST, diffFigPosition1, yAxis_ipsiContra_wPN, testPairs, starLevels);

%% Plot dual current injection plot
cell.date = '2018_02_28'; cell.expt = 8; %
fig_dualTraces = PlotAverageCurrentInjExpt_dualElec_singleCell(cell.date, cell.expt, 0, 0);
%
dualCellData = CombineDualExperiments();
fig_dualQuant = PlotDualCurrInj_crossCell(dualCellData);


