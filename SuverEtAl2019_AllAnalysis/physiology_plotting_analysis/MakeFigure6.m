
%%
% Make Figure 6 subfigures
% MLA, TNT and Chrimson
%
% Suver et al. 2019
%%

function [Fig6_ctrl_MLA Fig6_aPN2_aPN3 Fig6_aPN2aPN3_B1 Fig6_tnt_ss Fig6_tnt_onset Fig6_chrimson_APN2 Fig6_chrimson_APN3 ...
    Fig6_chrimson_sub2 Fig6_chrimson_sub3 Fig6_chrimsonQuant Fig6_APN2APN3_ipsiContra Fig6_B1_ipsiContra Fig6_APN2_B1_TNT ...
    Fig6_chrimson_B1 Fig6_chrimson_sub4 Fig6_chrimson_addTraces Fig6_tnt_ipsiContraRem_ss Fig6_tnt_ipsiContraRem_mag] ...
    = MakeFigure6(ERROR_AVG_VM_TRACES, TRACE_TYPE, TITLES)
load_figure_constants;
ONSET = 0;
SPIKERATE = 0;

%original WPN ipsi/contra manipulations for comparison
load(['../SuverEtAl2019_DATA/70B12_ipsi.mat'])
traces_wPN_ipsi = traces;
load(['../SuverEtAl2019_DATA/70B12_contra.mat'])
traces_wPN_contra = traces;
load(['../SuverEtAl2019_DATA/70B12_ipsiRemove.mat'])
traces_wPN_ipsiRemove = traces;
load(['../SuverEtAl2019_DATA/70B12_contraRemove.mat'])
traces_wPN_contraRemove = traces;
%% combined ipsi and contra glue/remove traces :) --> weighted sums of averages and errors
[traces_wPN_ipsiX traces_wPN_contraX] = CombineGlueRemoveTraces(traces_wPN_ipsi, traces_wPN_ipsiRemove, traces_wPN_contra, traces_wPN_contraRemove);

load(['../SuverEtAl2019_DATA/wPN_Chrim_MLA_WIND.mat'])
traces_wPN_MLA_WIND = traces;

%load data structures
load(['../SuverEtAl2019_DATA/wPN_CS_control.mat'])
traces_wPN_CS_control = traces;

load(['../SuverEtAl2019_DATA/wPN_TNT_aPN2.mat'])
traces_wPN_TNT_aPN2 = traces;

load(['../SuverEtAl2019_DATA/wPN_TNT_aPN3.mat'])
traces_wPN_TNT_aPN3 = traces;

load(['../SuverEtAl2019_DATA/wPN_TNT_aPN2_aPN3.mat'])
traces_wPN_TNT_aPN2_aPN3 = traces;

load(['../SuverEtAl2019_DATA/wPN_TNT_APN2_APN3_ipsiRem.mat'])
traces_wPN_TNT_APN2_APN3_ipsiRem = traces;

load(['../SuverEtAl2019_DATA/wPN_TNT_APN2_APN3_contraRem.mat'])
traces_wPN_TNT_APN2_APN3_contraRem = traces;

load(['../SuverEtAl2019_DATA/wPN_TNT_B1.mat'])
traces_wPN_TNT_B1 = traces;

load(['../SuverEtAl2019_DATA/wPN_TNT_B1_ipsiRem.mat'])
traces_wPN_TNT_B1_ipsiRem = traces;

load(['../SuverEtAl2019_DATA/wPN_TNT_B1_contraRem.mat'])
traces_wPN_TNT_B1_contraRem = traces;

load(['../SuverEtAl2019_DATA/wPN_TNT_B1_APN2.mat'])
traces_wPN_TNT_B1_APN2 = traces;


%Chrimson activation experiments: supplemental
load(['../SuverEtAl2019_DATA/wPN_redLtCtrl_6.mat'])
traces_LT_CTRL_Chrimson = traces;

load(['../SuverEtAl2019_DATA/wPN_24C06_Chrim.mat'])
traces_APN2_Chrim = traces;

load(['../SuverEtAl2019_DATA/wPN_24C06_Chrim_MLA.mat'])
traces_APN2_Chrim_MLA = traces;

load(['../SuverEtAl2019_DATA/wPN_70G01_Chrim.mat'])
traces_APN3_Chrim = traces;

load(['../SuverEtAl2019_DATA/wPN_70G01_Chrim_MLA.mat'])
traces_APN3_Chrim_MLA = traces;

load(['../SuverEtAl2019_DATA/wPN_B1_Chrim.mat'])
traces_B1_Chrim = traces;


%% Plot wPN control and MLA
trace1.traces = traces_wPN_CS_control;
trace1.name = ['control'];
trace2.traces = traces_wPN_MLA_WIND;
trace2.name = ['+MLA'];
Fig6_ctrl_MLA = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPos_TNT1, SPIKERATE);

%% aPN2>TNT, aPN3>TNT
trace1.traces = traces_wPN_TNT_aPN2;
trace1.name = ['APN2>TNT'];
trace2.traces = traces_wPN_TNT_aPN3;
trace2.name = ['APN3>TNT'];
Fig6_aPN2_aPN3 = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPos_TNT2, SPIKERATE);

%% Plot aPN2,aPN3>TNT, B1>TNT
trace1.traces = traces_wPN_TNT_aPN2_aPN3;
trace1.name = ['APN2,APN3>TNT'];
trace2.traces = traces_wPN_TNT_B1;
trace2.name = ['B1>TNT'];
Fig6_aPN2aPN3_B1 = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPos_TNT3, SPIKERATE);

%% Plot APN2,APN3>TNT ipsi contra rem
trace1.traces = traces_wPN_TNT_APN2_APN3_ipsiRem;
trace1.name = ['APN2,APN3>TNT ipsiRem'];
trace2.traces = traces_wPN_TNT_APN2_APN3_contraRem;
trace2.name = ['APN2,APN3>TNT contraRem'];
Fig6_APN2APN3_ipsiContra = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPos_TNT4, SPIKERATE);

%% Plot B1>TNT ipsi contra rem
trace1.traces = traces_wPN_TNT_B1_ipsiRem;
trace1.name = ['B1>TNT, ipsiRem'];
trace2.traces = traces_wPN_TNT_B1_contraRem;
trace2.name = ['B1>TNT, contraRem'];
Fig6_B1_ipsiContra = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPos_TNT1, SPIKERATE);

%% Plot B1,APN2>TNT
trace1.traces = nan(100000,1);
trace1.name = [' '];
trace2.traces = traces_wPN_TNT_B1_APN2;
trace2.name = ['APN2,B1>TNT'];
Fig6_APN2_B1_TNT = MakeTracePairFigure(trace1, trace2, ERROR_AVG_VM_TRACES, tracesPos_TNT2, SPIKERATE);

% Plot control, MLA, aPN2, aPN3, aPN2+aPN3, B1 TNT quantification
% based on above statistical comparison, can combine antenna glue and removal data!
trace1.name = ['control'];
trace1.traces = traces_wPN_CS_control;
trace2.name = ['+MLA'];
trace2.traces = traces_wPN_MLA_WIND;
trace3.name = ['APN2>TNT'];
trace3.traces = traces_wPN_TNT_aPN2;
trace4.name = ['APN3>TNT'];
trace4.traces = traces_wPN_TNT_aPN3;
trace5.name = ['APN2,APN3>TNT'];
trace5.traces = traces_wPN_TNT_aPN2_aPN3;
trace6.name = ['B1>TNT'];
trace6.traces = traces_wPN_TNT_B1;

trace7.name = ['APN2,B1>TNT'];
trace7.traces = traces_wPN_TNT_B1_APN2;

trace8.name = ['APN2,APN3>TNT,ipsiRem'];
trace8.traces = traces_wPN_TNT_APN2_APN3_ipsiRem;
trace9.name = ['APN2,APN3>TNT,contraRem'];
trace9.traces = traces_wPN_TNT_APN2_APN3_contraRem;
trace10.name = ['B1>TNT,ipsiRem'];
trace10.traces = traces_wPN_TNT_B1_ipsiRem;
trace11.name = ['B1>TNT,contraRem'];
trace11.traces = traces_wPN_TNT_B1_contraRem;

trace12.name = ['wpn ipsiX'];
trace12.traces = traces_wPN_ipsiX;
trace13.name = ['wpn contraX'];
trace13.traces = traces_wPN_contraX;


all_traces = {trace1; trace2; trace3; trace4; trace5; trace6;trace7;}; 
testPairs = ([[1 2];[1 3];[1 4];[1 5];[1 6]; [6 7];]);
starLevels = [1 2 3 4 5 1]; %match # pairs above; sets y-position of statistical stars!
%steady state comparison
TEST = 0;
Fig6_tnt_ss = MakeIpsiContraPlot(all_traces, ONSET, TEST, diffFigPosition2, yAxis_ipsiContra_TNT, testPairs, starLevels);
%onset comparison
Fig6_tnt_onset = MakeIpsiContraPlot(all_traces, 1, TEST, diffFigPosition2, yAxis_ipsiContra_TNT, testPairs, starLevels);

%% compare double, B1 silencing to original WPN manips
all_traces = {trace12; trace13; trace8; trace9; trace10; trace11;}; 
testPairs = ([[1 3];[2 4];[1 5];[2 6];]);
starLevels = [1 2 3 4]; %match # pairs above; sets y-position of statistical stars!
%steady state comparison
Fig6_tnt_ipsiContraRem_ss = MakeIpsiContraPlot(all_traces, 0, TEST, diffFigPosition2, yAxis_ipsiContra_TNT, testPairs, starLevels); %steady state

Fig6_tnt_ipsiContraRem_mag = MakeIpsiContraPlot(all_traces, 2, TEST, diffFigPosition2, yAxis_ipsiContra_TNT, testPairs, starLevels); %steady state


%% %% %% %% Plot Chrimson activation results     %% %% %% %% %% %% %% %% %%
traces1 = {};
traces1{1} = traces_LT_CTRL_Chrimson;
traces1{2} = traces_APN2_Chrim;
traces1{3} = traces_APN2_Chrim_MLA;
names1 = {['CONTROL (N=' num2str(traces1{1}.numFlies) ')']; ['APN2 (N=' num2str(traces1{2}.numFlies) ')']; ['APN2+MLA (N=' num2str(traces1{3}.numFlies) ')']};
traces2 = {}; names2 = '';
Fig6_chrimson_APN2 = MakeChrimsonPlots(traces1,names1, traces2, names2, ERROR_AVG_VM_TRACES, tracesPositionActivation, SPIKERATE);

traces1 = {};
traces1{1} = traces_LT_CTRL_Chrimson;
traces1{2} = traces_APN3_Chrim;
traces1{3} = traces_APN3_Chrim_MLA;
names1 = {['CONTROL (N=' num2str(traces1{1}.numFlies) ')']; ['APN3 (N=' num2str(traces1{2}.numFlies) ')']; ['APN3+MLA (N=' num2str(traces1{3}.numFlies) ')']};
Fig6_chrimson_APN3 = MakeChrimsonPlots(traces1,names1, traces2, names2, ERROR_AVG_VM_TRACES, tracesPositionActivation, SPIKERATE);

traces1 = {};
traces1{1} = traces_LT_CTRL_Chrimson;
traces1{2} = traces_B1_Chrim;
%traces1{3} = traces_B1_Chrim_MLA;
names1 = {['CONTROL (N=' num2str(traces1{1}.numFlies) ')']; ['B1 (N=' num2str(traces1{2}.numFlies) ')'];};% ['APN3+MLA (N=' num2str(traces1{3}.numFlies) ')']};
Fig6_chrimson_B1 = MakeChrimsonPlots(traces1,names1, traces2, names2, ERROR_AVG_VM_TRACES, tracesPositionActivation, SPIKERATE);

traces1 = {};
tracesAPN2minCTRL = traces_APN2_Chrim; 
tracesAPN2minCTRL.avgVmTrace = tracesAPN2minCTRL.avgVmTrace-traces_LT_CTRL_Chrimson.avgVmTrace;
for ii = 1:length(tracesAPN2minCTRL.indvVmTrace)
    tracesAPN2minCTRL.indvVmTrace{ii} = nan(size(tracesAPN2minCTRL.indvVmTrace{ii}));
end

traces1{1} = tracesAPN2minCTRL;
names1 = {['APN2-CTRL']};
tracesAPN2minMLA = traces_APN2_Chrim; tracesAPN2minMLA.avgVmTrace = tracesAPN2minMLA.avgVmTrace-traces_APN2_Chrim_MLA.avgVmTrace;
for ii = 1:length(tracesAPN2minMLA.indvVmTrace)
    tracesAPN2minMLA.indvVmTrace{ii} = nan(size(tracesAPN2minMLA.indvVmTrace{ii}));
end
traces2{1} = tracesAPN2minMLA;
names2 = {['APN2-MLA']};
Fig6_chrimson_sub2 = MakeChrimsonPlots(traces1, names1, traces2, names2, ERROR_AVG_VM_TRACES, tracesPositionActivation, SPIKERATE);


traces1 = {};
tracesAPN3minCTRL = traces_APN3_Chrim; tracesAPN3minCTRL.avgVmTrace = tracesAPN3minCTRL.avgVmTrace-traces_LT_CTRL_Chrimson.avgVmTrace;
for ii = 1:length(tracesAPN3minCTRL.indvVmTrace)
    tracesAPN3minCTRL.indvVmTrace{ii} = nan(size(tracesAPN3minCTRL.indvVmTrace{ii}));
end
traces1{1} = tracesAPN3minCTRL;
names1 = {['APN3-CTRL']};
tracesAPN3minMLA = traces_APN3_Chrim; tracesAPN3minMLA.avgVmTrace = tracesAPN3minMLA.avgVmTrace-traces_APN3_Chrim_MLA.avgVmTrace;
for ii = 1:length(tracesAPN3minMLA.indvVmTrace)
    tracesAPN3minMLA.indvVmTrace{ii} = nan(size(tracesAPN3minMLA.indvVmTrace{ii}));
end
traces2{1} = tracesAPN3minMLA;
names2 = {['APN3-MLA']};
Fig6_chrimson_sub3 = MakeChrimsonPlots(traces1, names1, traces2, names2, ERROR_AVG_VM_TRACES, tracesPositionActivation, SPIKERATE);

%% B1 chrimson comparisons
traces1 = {};
tracesB1minCTRL = traces_B1_Chrim; tracesB1minCTRL.avgVmTrace = tracesB1minCTRL.avgVmTrace-traces_LT_CTRL_Chrimson.avgVmTrace;
for ii = 1:length(tracesB1minCTRL.indvVmTrace)
    tracesB1minCTRL.indvVmTrace{ii} = nan(size(tracesB1minCTRL.indvVmTrace{ii}));
end
traces1{1} = tracesB1minCTRL;
names1 = {['B1-CTRL']};

tracesB1minMLA = traces_B1_Chrim; tracesB1minMLA.avgVmTrace = tracesB1minMLA.avgVmTrace-traces_APN3_Chrim_MLA.avgVmTrace;
for ii = 1:length(tracesB1minMLA.indvVmTrace)
    tracesB1minMLA.indvVmTrace{ii} = nan(size(tracesB1minMLA.indvVmTrace{ii}));
end
temp = tracesAPN3minMLA; 
temp.avgVmTrace= nan(size(temp.avgVmTrace));
traces2{1} = temp;
names2 = {[' ']};
Fig6_chrimson_sub4 = MakeChrimsonPlots(traces1, names1, traces2, names2, ERROR_AVG_VM_TRACES, tracesPositionActivation, SPIKERATE);

% for fun, plot addition of activation traces
traces = {};
tt = traces_B1_Chrim;
tt.avgVmTrace = tracesB1minCTRL.avgVmTrace+tracesAPN2minCTRL.avgVmTrace;
traces{1} = tt;

traces2 = traces;
tt.avgVmTrace = tracesB1minCTRL.avgVmTrace-tracesAPN2minCTRL.avgVmTrace;%+tracesAPN3minCTRL.avgVmTrace;
traces2{1} = tt;
Fig6_chrimson_addTraces = MakeChrimsonPlots(traces, {'APN2+B1'}, traces2, {'B1-APN2'}, ERROR_AVG_VM_TRACES, tracesPositionActivation, SPIKERATE);

%% make chrimson quantification plot
traces = {};
traces{1} = traces_LT_CTRL_Chrimson;
traces{2} = traces_APN2_Chrim;
traces{3} = tracesAPN2minCTRL;
traces{4} = traces_APN2_Chrim_MLA;
traces{5} = tracesAPN2minMLA;
traces{6} = traces_APN3_Chrim;
traces{7} = tracesAPN3minCTRL;
traces{8} = traces_APN3_Chrim_MLA;
traces{9} = tracesAPN3minMLA;

traceNames = {'control'; 'APN2'; 'APN2-control'; 'APN2/MLA'; 'APN2-MLA'; 'APN3'; 'APN3-control'; 'APN3/MLA'; 'APN3-MLA';};
xLocs = [1 3 4 5 6 8 9 10 11];
testPairs = [1 2; 1 6; ]; %compare control to APN2 and APN3 activation
starLevels = [1 2]; %y-locations for statistical comparisons (for plotting the connecting line)
Fig6_chrimsonQuant = MakeChrimsonQuantificationPlot(traces, traceNames, xLocs, positionChrimsonQuant, testPairs, starLevels);

