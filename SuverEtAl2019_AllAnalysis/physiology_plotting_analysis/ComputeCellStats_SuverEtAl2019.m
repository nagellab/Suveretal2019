%%
% ComputeCellStats_SuverEtAl2019
%
% Compute cell stats for Suver et al 2019
% (e.g. resting membrane potential, spike rates, etc.)
%

%%

function [] = ComputeCellStats_SuverEtAl2019()

%load_notes;

%% load cell types that appear in the paper:
APN2_expts = {'24C06_free'; '24C06_ipsi'; '24C06_contra';'24C06_Chrim'};
APN3_expts = {'70G01_all'; '70G01_free'; '70G01_ipsi'; '70G01_contra'; '70G01_ant'};
WPN_expts = {'70B12'; '70B12_free'; '70B12_ipsi'; '70B12_contra'; '70B12_ipsiRemove'; '70B12_contraRemove';'70B12_bilatRemove';...
    'wPN_redLtCtrl_6'; 'wPN_CS_control'; '70B12_ablate'; '70B12_ablate_ctrl'};
dir = '../SuverEtAl2019_DATA/';

indv_avgVm_APN2 = [];
numTrials = [];
for ii = 1:length(APN2_expts)
    expt = APN2_expts{ii};
    load([dir expt]);
    indv_avgVm_APN2 = [indv_avgVm_APN2; traces.avgVm];
    if ~strcmp('24C06_Chrim', expt)
        for jj = 1:length(traces.indvTonicWindAvg)
            numTrials = [numTrials size(traces.indvTonicWindAvg{jj}, 2)];
        end
    end
end
APN2_expts
vmAvg_APN2 = mean(indv_avgVm_APN2)
numTrials_mean1 = mean(numTrials)
numTrials_max1 = max(numTrials);
numTrials_min1 = min(numTrials)

indv_avgSR_APN3 = [];
indv_avgVm_APN3 = [];
numTrials = [];
for ii = 1:length(APN3_expts)
    expt = APN3_expts{ii};
    load([dir expt]);
    indv_avgVm_APN3 = [indv_avgVm_APN3; traces.avgVm];
    indv_avgSR_APN3 = [indv_avgSR_APN3; traces.avgSR];
    if ~strcmp('70G01_ant', expt)
        for jj = 1:length(traces.indvTonicWindAvg)
            numTrials = [numTrials size(traces.indvTonicWindAvg{jj}, 2)];
        end
    end
end
display('APN3 averages:')
vmAvg_APN3 = mean(indv_avgVm_APN3)
srAvg_APN3 = mean(indv_avgSR_APN3)
numTrials_mean2 = mean(numTrials)
numTrials_max2 = max(numTrials);
numTrials_min2 = min(numTrials)

indv_avgSR_WPN = [];
indv_avgVm_WPN = [];
numTrials = [];
for ii = 1:length(WPN_expts)
    expt = WPN_expts{ii}
    load([dir expt]);
    indv_avgVm_WPN = [indv_avgVm_WPN; traces.avgVm];
    indv_avgSR_WPN = [indv_avgSR_WPN; traces.avgSR]
    
    if ~strcmp('wPN_redLtCtrl_6', expt)
        for jj = 1:length(traces.indvTonicWindAvg)
            numTrials = [numTrials size(traces.indvTonicWindAvg{jj}, 2)];
        end
    end
    
end
WPN_expts
vmAvg_WPN = mean(indv_avgVm_WPN)
srAvg_WPN = mean(indv_avgSR_WPN)
numTrials_mean3 = mean(numTrials)
numTrials_max3 = max(numTrials);
numTrials_min3 = min(numTrials)

numAllTrials_MIN = min([numTrials_min1 numTrials_min2 numTrials_min3])
numAllTrials_MAX = max([numTrials_max1 numTrials_max2 numTrials_max3])
numAllTrials_MEAN = mean([numTrials_mean1 numTrials_mean2 numTrials_mean3])



