%%
% MakeFigurePlots()
%  Runs analysis and plotting functions for Suver et al. 2019
%
% Note: Some subplot names may not be accurate, as some shifting occured when
% putting the full figures together, but all subfigures are generated here 
% and the main figure labels are accurate. Final font sizes, alignment, etc.
% were done in Adobe Illustrator.
%
%%

function [] = MakeFigurePlots(saveFigPlots)
load_figure_constants;
if nargin == 0
   display('Please indicate if you wish to save all subfigures.') 
   display('0 - plot only (do not save figures)') 
   display('1 - plot and save pngs') 
   display('2 - plot and save pngs + pdf') 
   return
end

FigureSaveLocation = '../SuverEtAl2019_PLOTS/';
allFigs = []; %set of figure handles for all paper figures

%% %%%%%%%%%%%%%% FIGURE 1: Behavior %%%%%%%%%%%%%%%%%%%%%%%%
[fig1_upv fig1_upvBsub fig1_angv fig1_angvBsub] = MakeFigure1()
allFigs = [fig1_upv fig1_upvBsub fig1_angv fig1_angvBsub];
allFigNames = {'fig1_upv'; 'fig1_upvBsub'; 'fig1_angv'; 'fig1_angvBsub'};

%% %%%%%%%%%%%%%% FIGURE 2: Antenna tuning curves %%%%%%%%%%%%%%%%%%%
%0: steady state tuning, 1: stead+onset tuning, 2: antenna tuning
ERROR_AVG_VM_TRACES = 1;
[Fig2_anterior Fig2_antTraces Fig2_antTraces_hand Fig2_ane] = MakeFigure2(ERROR_AVG_VM_TRACES, TITLES);
allFigs = [allFigs Fig2_anterior Fig2_antTraces Fig2_antTraces_hand Fig2_ane];
allFigNames = [allFigNames; 'Fig2_anterior'; 'Fig2_antTraces'; 'Fig2_antTraces_hand'; 'Fig2_ane'];

%% %%%%%%%%%%%%% FIGURE 3: aPN2+aPN3 anatomy+responses %%%%%%%%%%%%%%%%%%%
TRACE_TYPE = 0; %0: steady state tuning, 1: steady+onset tuning, 2: antenna tuning
ERROR_AVG_VM_TRACES = 0; TITLES = 0;
[Fig3BC Fig3D Fig3FG Fig3H Fig3_ipsiContraAPN2 Fig3_ipsiContraAPN3 Fig3k Fig3_suppA Fig3_suppB Fig3_suppCD Fig3_suppEF Fig3_rawZoomaPN2 Fig3_rawZoomaPN3] = MakeFigure3(ERROR_AVG_VM_TRACES, TRACE_TYPE, TITLES);
allFigs = [allFigs Fig3BC Fig3D Fig3FG Fig3H Fig3_ipsiContraAPN2 Fig3_ipsiContraAPN3 Fig3k Fig3_suppA Fig3_suppB Fig3_suppCD Fig3_suppEF Fig3_rawZoomaPN2 Fig3_rawZoomaPN3];
allFigNames = [allFigNames; 'Fig3BC'; 'Fig3D'; 'Fig3FG'; 'Fig3H'; 'Fig3_ipsiContraAPN2'; 'Fig3_ipsiContraAPN3';'Fig3k'; 'Fig3_suppA'; 'Fig3_suppB'; 'Fig3_suppCD'; 'Fig3_suppEF'; 'Fig3_rawZoomaPN2'; 'Fig3_rawZoomaPN3'];

%% %%%%%%%%%%%%% FIGURE 4: wPN anatomy+responses %%%%%%%%%%%%%%%%%%%
TRACE_TYPE = 0; %0: steady state tuning, 1: stead+onset tuning, 2: antenna tuning
ERROR_AVG_VM_TRACES = 0;
[Fig4CD Fig4E Fig4GI Fig4H Fig4L Fig4M Fig4J Fig4K Fig4_supp1A Fig4_supp1B Fig4_supp2  Fig4_supp3 Fig4_supp4 Fig4_rawZoom_wPNIpsi Fig4_rawZoom_wPNIContra] ...
    = MakeFigure4(ERROR_AVG_VM_TRACES, TRACE_TYPE);
allFigs = [allFigs Fig4CD Fig4E Fig4GI Fig4H Fig4L Fig4M Fig4J Fig4K Fig4_supp1A Fig4_supp1B Fig4_supp2 Fig4_supp3 Fig4_supp4 Fig4_rawZoom_wPNIpsi Fig4_rawZoom_wPNIContra];
allFigNames = [allFigNames; 'Fig4CD'; 'Fig4E'; 'Fig4GI'; 'Fig4H'; 'Fig4L'; 'Fig4M'; 'Fig4J'; 'Fig4K'; 'Fig4_supp1A'; 'Fig4_supp1B'; 'Fig4_supp2'; 'Fig4_supp3'; 'Fig4_supp4'; 'Fig4_rawZoom_wPNIpsi'; 'Fig4_rawZoom_wPNIContra'];

%% Supplemental figure 2
%% Wind neuron screen driver metrics (steady state, onset, d' measures of activity.)
FIG_TYPE = 1; %plot bar-chart version of the metrics (not text)
[suppFig2_maxOnset suppFig2_maxSteady suppFig2_dynRange suppFig2_dPrime] = PlotDriverMetrics(FIG_TYPE);
allFigs = [allFigs suppFig2_maxOnset suppFig2_maxSteady suppFig2_dynRange suppFig2_dPrime];
allFigNames = [allFigNames; 'suppFig2_maxOnset'; 'suppFig2_maxSteady'; 'suppFig2_dynRange'; 'suppFig2_dPrime'];

[FigSupp_trace_29C10 FigSupp_tuning_29C10 FigSupp_trace_38H10 FigSupp_tuning_38H10 FigSupp_trace_54H01 FigSupp_tuning_54H01] ...
    = MakeSupplementalWindScreenFigures();
allFigs = [allFigs FigSupp_trace_29C10 FigSupp_tuning_29C10 FigSupp_trace_38H10 FigSupp_tuning_38H10 FigSupp_trace_54H01 FigSupp_tuning_54H01];
allFigNames = [allFigNames; 'FigSupp_trace_29C10'; 'FigSupp_tuning_29C10'; 'FigSupp_trace_38H10'; 'FigSupp_tuning_38H10'; 'FigSupp_trace_54H01'; 'FigSupp_tuning_54H01'];

%% Figure 4F and K
% D' bar plot
PLOT_TYPE = 0;
FRONTAL_ONLY = 1; %display frontal directions
fig = PlotDPrime_crossDirectionOnePlot('free', FRONTAL_ONLY, PLOT_TYPE); %compare wpn vs. APN2 and APN3
allFigs = [allFigs fig];
allFigNames = [allFigNames; 'Fig4_dPrime_free'];
fig = PlotDPrime_crossDirectionOnePlot('70B12', FRONTAL_ONLY, PLOT_TYPE); %compare wpn antenna fre vs. antenna stabilization
allFigs = [allFigs fig];
allFigNames = [allFigNames; 'Fig4_dPrime_70B12'];

%% %%%%%%%%%%%%% FIGURE 5: 2P lesion+dual patch %%%%%%%%%%%%%%%%%%%%%%%%
TRACE_TYPE = 1; %0: steady state tuning, 1: stead+onset tuning, 2: antenna tuning
[Fig5_supp1 Fig5_supp2 Fig5_supp3 Fig5_supp4 Fig5_supp5 Fig5_supp6 Fig5_traces Fig5_quant fig_dualTraces fig_dualQuant] = MakeFigure5(ERROR_AVG_VM_TRACES, TRACE_TYPE);
allFigs = [allFigs Fig5_supp1 Fig5_supp2 Fig5_supp3 Fig5_supp4 Fig5_supp5 Fig5_supp6 Fig5_traces Fig5_quant fig_dualTraces fig_dualQuant];
allFigNames = [allFigNames; 'Fig5_supp1'; 'Fig5_supp2'; 'Fig5_supp3'; 'Fig5_supp4'; 'Fig5_supp5'; 'Fig5_supp6'; 'Fig5_traces'; 'Fig5_quant'; 'Fig5_dualTraces'; 'Fig5_dualQuant'];

%% %%%%%%%%%%%%% FIGURE 6: TNT traces %%%%%%%%%%%%%%%%%%%%%%%%
TRACE_TYPE = 0; %0: steady state tuning, 1: stead+onset tuning, 2: antenna tuning
[Fig6_ctrl_MLA Fig6_aPN2_aPN3 Fig6_aPN2aPN3_B1 Fig6_tnt_ss Fig6_tnt_onset Fig6_chrimson_APN2 Fig6_chrimson_APN3 Fig6_chrimson_sub2 Fig6_chrimson_sub3 Fig6_chrimsonQuant ... 
    Fig6_APN2APN3_ipsiContra Fig6_B1_ipsiContra Fig6_APN2_B1_TNT Fig6_chrimson_B1 Fig6_chrimson_sub4 Fig6_chrimson_addTraces Fig6_tnt_ipsiContraRem_ss Fig6_tnt_ipsiContraRem_mag]...
    = MakeFigure6(ERROR_AVG_VM_TRACES, TRACE_TYPE);
allFigs = [allFigs Fig6_ctrl_MLA Fig6_aPN2_aPN3 Fig6_aPN2aPN3_B1 Fig6_tnt_ss Fig6_tnt_onset Fig6_chrimson_APN2 Fig6_chrimson_APN3 Fig6_chrimson_sub2 Fig6_chrimson_sub3 ... 
    Fig6_chrimsonQuant Fig6_APN2APN3_ipsiContra Fig6_B1_ipsiContra Fig6_APN2_B1_TNT Fig6_chrimson_B1 Fig6_chrimson_sub4 Fig6_chrimson_addTraces Fig6_tnt_ipsiContraRem_ss Fig6_tnt_ipsiContraRem_mag ];
allFigNames = [allFigNames; 'Fig6_ctrl_MLA'; 'Fig6_aPN2_aPN3'; 'Fig6_aPN2aPN3_B1'; 'Fig6_tnt_ss'; 'Fig6_tnt_onset'; 'Fig6_chrimson_APN2'; 'Fig6_chrimson_APN3'; 'Fig6_chrimson_sub2'; ... 
    'Fig6_chrimson_sub3'; 'Fig6_chrimsonQuant'; 'Fig6_APN2APN3_ipsiContra'; 'Fig6_B1_ipsiContra'; 'Fig6_APN2_B1_TNT'; 'Fig6_chrimson_B1'; 'Fig6_chrimson_sub4'; 'Fig6_chrimson_addTraces'; ... 
    'Fig6_tnt_ipsiContraRem_ss'; 'Fig6_tnt_ipsiContraRem_mag'];
 
%% Display statistics about cell stats (baseline Vm, spike rate, etc.)
ComputeCellStats_SuverEtAl2019()

%% Save figure plots
if saveFigPlots > 0 %save figure images
    if saveFigPlots == 2 %save vector graphics (pdf)
        display('Please be patient - saving vector graphics figures takes a while.')
    else
        display('Please wait a moment while we save the figures!')
    end
    display(['Saving figures in: ' FigureSaveLocation])
    for ii = 1:length(allFigs)
        fig = figure(allFigs(ii));
        figName = allFigNames{ii};
        filename = [FigureSaveLocation figName];
        set(gcf,'Units','inches');
            screenposition = get(gcf,'Position');
            set(gcf,...
                'PaperPosition',[0 0 screenposition(3:4)],...
                'PaperSize',[screenposition(3:4)]);
        print(fig, [filename], '-dpng', '-r300') %high-quality png (nice for talks)
        if saveFigPlots == 2 %save vector graphics (pdf)
            set(gcf,'Units','inches');
            screenposition = get(gcf,'Position');
            set(gcf,...
                'PaperPosition',[0 0 screenposition(3:4)],...
                'PaperSize',[screenposition(3:4)]);
            print(fig, [filename], '-dpdf', '-r300') %ready for final figure-making! 
        end
    end
end



