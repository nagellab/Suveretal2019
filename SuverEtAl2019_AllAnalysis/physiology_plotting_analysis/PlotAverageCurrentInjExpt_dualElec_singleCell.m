%%
% Plot dual-cell current injection experiments
%
% Suver et al. 2019
%%

function fig = PlotAverageCurrentInjExpt_dualElec_singleCell(date, expt, INDV_TRACES, PLOT_TITLE)

if nargin < 2
   display('Please input: ')
   display('(1) date (string), e.g ''2018_02_21''')
   display('(2) expt (int), e.g. 1')
   display('(3) 0 for avg only or 1 to plot individual trial traces')
   return
end
INDV_ALL = 0;
load_figure_constants;
multCurr = 3.9; %scaling factor for plotting
[injI1 injVm1 respVm2 injI2 injVm2 respVm1 ...
    meanI1_inj meanVm1_inj meanVm2_resp meanI2_inj meanVm2_inj meanVm1_resp] ...
    = GetTraces_singleExpt_dualElec(date, expt);

%plot the averages!
indvWidth = 0.5; avgWidth = 2;
fig = figure('Color', 'w', 'Position', positionDualCurrInj); hold on;
samplerate = 10000;
xx_N = 5*samplerate+500; % will plot text to right of current injection step
xx_sec = 3*samplerate+500; % will plot text to right of current injection step
yy_sec = -48;% HARD-CODED
yy_scaleBar = 20; %HARD-CODED
scaleSize = 20;
scaleSize_pA = 5;
stimInds = 2*samplerate:4*samplerate;
baseInds = 1:(2*samplerate-1);
spacing = samplerate/2;
startTraces = 1;
if INDV_ALL
    numIndvTraces = size(meanI1_inj,1);
else
    numIndvTraces = 1;
end

for ii = startTraces:(size(meanI1_inj,1))
    color = colors_currInj(ii,:);
    %% Injected current elec 1
    subplot(2,1,1); hold on; 
    i1 = injI1{ii}.*multCurr;
    numTrials(ii) = size(i1,1);
    if INDV_TRACES
        for jj = 1:numIndvTraces%size(i1,1)
            plot(i1(jj,:)-mean(i1(jj,baseInds)), 'Linewidth', width_rawTrace, 'Color', color)%color_dualCell1)
        end
    end
    plot(meanI1_inj(ii,:).*multCurr-mean(meanI1_inj(ii,baseInds).*multCurr), 'Linewidth', width_avgTrace, 'Color', color)%color_dualCell1) %inj curr 1
    if ii == size(meanI1_inj,1)
        yy = -mean(meanI1_inj(ii,stimInds));
        text(xx_N, yy, ['n >= ' num2str(numTrials(ii)) ' trials'], 'Fontsize', fontSize_axis, 'Fontname', figureFont); %plot number of trials for each current level
        text(xx_sec, yy_sec, ['2 s'], 'HorizontalAlignment', 'center', 'Fontname', figureFont, 'Fontsize', fontSize_axis); %indicate length of current pulse
    end
    % SCALE BAR pA
    if ii == size(meanI1_inj,1)
        xx = size(meanI1_inj,2)-2*samplerate; %2 s before end of cell 1 trace
        line([xx xx],[yy_scaleBar yy_scaleBar+scaleSize_pA*multCurr], 'Linewidth', width_scale, 'Color', 'k')
        text(xx+samplerate*0.2, yy_scaleBar+scaleSize_pA*multCurr/2, [num2str(scaleSize_pA) ' pA'], 'HorizontalAlignment', 'left', 'Fontname', figureFont, 'Fontsize', fontSize_axis);
    end
    nans = nan(1,length(i1)+spacing);
    %% Injected voltage elec 1
    subplot(2,1,1); hold on; 
    if INDV_TRACES
        vm1 = injVm1{ii};
        for jj = 1:numIndvTraces%size(vm1,1)
            plot([nans vm1(jj,:)-mean(vm1(jj,baseInds))], 'Linewidth', width_rawTrace, 'Color', color)%color_dualCell1)
        end
    end
    plot([nans meanVm1_inj(ii,:)-mean(meanVm1_inj(ii,baseInds))], 'Linewidth', width_avgTrace, 'Color', color)%color_dualCell1) %Vm 1
    nans = nan(1,length(nans)*2);
    % SCALE BAR
    if ii == size(meanI1_inj,1)
        xx = length(nans)-2*samplerate; %2 s before end of cell 1 trace
        line([xx xx],[yy_scaleBar yy_scaleBar+scaleSize], 'Linewidth', width_scale, 'Color', 'k')
        text(xx+samplerate*0.2, yy_scaleBar+scaleSize/2, [num2str(scaleSize) ' mV'], 'HorizontalAlignment', 'left', 'Fontname', figureFont, 'Fontsize', fontSize_axis);
    end
    %% Response voltage elec 2
    subplot(2,1,1); hold on;
    if INDV_TRACES
        vm2 = respVm2{ii};
        for jj = 1:numIndvTraces%size(vm2,1)
            plot([nans vm2(jj,:)-mean(vm2(jj,baseInds))], 'Linewidth', width_rawTrace, 'Color', color)%color_dualCell2)
        end
    end
    plot([nans meanVm2_resp(ii,:)-mean(meanVm2_resp(ii,baseInds))], 'Linewidth', width_avgTrace, 'Color', color)%color_dualCell2) %resulting Vm 2
   
    %% Injected current elec 2
    subplot(2,1,2); hold on;
    if INDV_TRACES
        i2 = injI2{ii}.*multCurr;
        for jj = 1:numIndvTraces%size(i2,1)
            plot(i2(jj,:)-mean(i2(jj,baseInds)), 'Linewidth', width_rawTrace, 'Color', color)%color_dualCell2)
        end
    end
    plot(meanI2_inj(ii,:).*multCurr-mean(meanI2_inj(ii,baseInds)).*multCurr, 'Linewidth', width_avgTrace, 'Color', color)%color_dualCell2) %inj curr 2
    if ii == size(meanI1_inj,1)
        text(xx_sec, yy_sec, ['2 s'], 'HorizontalAlignment', 'center', 'Fontname', figureFont, 'Fontsize', fontSize_axis); %indicate length of current pulse
    end
    % SCALE BAR pA  
    if ii == size(meanI1_inj,1)
        xx = size(meanI1_inj,2)-2*samplerate; %2 s before end of cell 1 trace
        line([xx xx],[yy_scaleBar yy_scaleBar+scaleSize_pA*multCurr], 'Linewidth', width_scale, 'Color', 'k')
        text(xx+samplerate*0.2, yy_scaleBar+scaleSize_pA*multCurr/2, [num2str(scaleSize_pA) ' pA'], 'HorizontalAlignment', 'left', 'Fontname', figureFont, 'Fontsize', fontSize_axis);
    end
    nans = nan(1,length(i1)+spacing);
    
    %% Injected voltage elec 2
    subplot(2,1,2); hold on;
    if INDV_TRACES
        vm1 = respVm1{ii};
        for jj = 1:numIndvTraces%size(vm1,1)
            plot([nans vm1(jj,:)-mean(vm1(jj,baseInds))], 'Linewidth', width_rawTrace, 'Color', color)%color_dualCell2)
        end
    end
    plot([nans meanVm1_resp(ii,:)-mean(meanVm1_resp(ii,baseInds))], 'Linewidth', width_avgTrace, 'Color', color)%color_dualCell2) %resulting Vm 1
    nans = nan(1,length(nans)*2);
    
    %% Response voltage elec 1
    subplot(2,1,2); hold on;
    if INDV_TRACES
        vm2 = injVm2{ii};
        for jj = 1:numIndvTraces%size(vm2,1)
            plot([nans vm2(jj,:)-mean(vm2(jj,baseInds))], 'Linewidth', width_rawTrace, 'Color', color)%color_dualCell1)
        end
    end
    plot([nans meanVm2_inj(ii,:)-mean(meanVm2_inj(ii,baseInds))], 'Linewidth', width_avgTrace, 'Color', color)%color_dualCell1) %Vm 2
    
    % SCALE BAR mV
    if ii == size(meanI1_inj,1)
        xx = length(nans)+size(meanVm2_inj,2)-2*samplerate; %2 s before end of cell 1 trace
        line([xx xx],[yy_scaleBar yy_scaleBar+scaleSize], 'Linewidth', width_scale, 'Color', 'k')
        text(xx+samplerate*0.2, yy_scaleBar+scaleSize/2, [num2str(scaleSize) ' mV'], 'HorizontalAlignment', 'left', 'Fontname', figureFont, 'Fontsize', fontSize_axis);
    end
end

%define axis range
ymax_Vm = 100; ymin_Vm = -60;

subplot(2,1,1); hold on; axis off
ylim([ymin_Vm ymax_Vm ]);
xlim([-samplerate*2 +1.5*length(nans)])
text(-samplerate*2, 0, '0 pA', 'HorizontalAlignment', 'left', 'Fontname', figureFont, 'Fontsize', fontSize_axis);
ylabel('mV');
if PLOT_TITLE == 1
    title('Inj curr cell 1 (-10 to +25 in 5pA steps)'); 
end

subplot(2,1,2); hold on; axis off
ylim([ymin_Vm ymax_Vm ]);
xlim([-samplerate*2 +1.5*length(nans)])
text(-samplerate*2, 0, '0 pA', 'HorizontalAlignment', 'left', 'Fontname', figureFont, 'Fontsize', fontSize_axis);
ylabel('mV');
if PLOT_TITLE == 1
    title('Inj curr cell 2 (-10 to +25 in 5pA steps)'); 
end

