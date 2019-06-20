%%
% PlotDPrime_tuning between angles of wind with all other
%  (-90 vs. -45, 0, +45, +90,
%  (-45 vs. -90, 0, +45, +90, ...
%  and show the average
%
% (Warning: quite a bit of hard-coding in the plotting.)
%
% Run also for antenna d', PlotAntDisplacement_crossFly('all_anterior', 2)
%
% Suver et al. 2019
%%

function [Fig] = PlotDPrime_crossDirectionOnePlot(driver, FRONTAL_ONLY, plotType)
load_figure_constants;
TEST = 0;
if nargin < 3
   display('Please enter (1) the driver, e.g. ''70B12'' or ''antenna''') 
   display('Please enter (2) 1 for frontal dirs only (2 d'' values) 2 (all four comparisons) or 0 (for all possible combinations)') 
   display('Please enter (3) 0 for dot plot, 1 for bar plot') 
end

if strcmp(driver, 'free')
    exptNames = {'70B12_free';'24C06_free'; '70G01_free';};
    cellTypes = {'WPN';'APN2'; 'APN3';};
    cellTypeColors = [WPN_color; APN2_color; APN3_color];
elseif strcmp(driver, '70B12')
    exptNames = {'70B12_free';'70B12_ipsiX';'70B12_contraX';};
    cellTypes = {'free';'ipsiX';'contraX';};
    cellTypeColors = [WPN_color; WPN_color; WPN_color];
elseif strcmp(driver, 'all')
    exptNames = {'70B12_free';'70B12_ipsiX';'70B12_contraX';'24C06_free'; '70G01_free'};
    cellTypes = {'WPN';'ipsiX';'contraX';'APN2'; 'APN3';};
    cellTypeColors = [WPN_color; WPN_color; WPN_color; APN2_color; APN3_color];
elseif strcmp(driver, 'antenna')
    exptNames = {'right'; 'left'; 'rminl'};
    cellTypes = {'right'; 'left'; 'rminl'};
    cellTypeColors = [color_rightAntenna; color_leftAntenna; color_RMINL];
end

if FRONTAL_ONLY == 1
    pairs = [2 3; 3 4;];
    pairLabels = {'-45°,0°'; ' 0°,+45°';};
    xticks = [1 2; 4 5; 7 8; 10 11; 13 14;];
elseif FRONTAL_ONLY == 2
    pairs = [1 2; 2 3; 3 4; 4 5];
    pairLabels = {'-90,-45'; '-45, 0'; ' 0,+45'; ' 0,+90'; };
    xticks = [1:4; 6:9; 11:14; 16:19; 21:24];
else
    pairs = [1 2; 1 3; 1 4; 1 5; 2 3; 2 4; 2 5; 3 4; 3 5; 4 5];
    pairLabels = {'-90,-45'; '-90, 0'; '-90,+45'; '-90,+90'; '-45, 0'; '-45,+45'; '-45,+90'; ' 0,+45'; ' 0,+90'; '+45,+90'};
    xticks = [1:10; 12:21; 23:32; 34:43; 45:54];
end

%%
scrsz = get(0,'ScreenSize'); %[left,bottom,width,height]
ll = scrsz(4)*0.01; bb = scrsz(4)*0.05; ww = scrsz(3)*0.5; hh = scrsz(4)*0.5;

if strcmp(driver,'antenna')
    [dP_avgR, dP_stdR, dP_avgL, dP_stdL, dP_avgRMinL, dP_stdRMinL, numFlies, dPrimeR_allFlies, dPrimeL_allFlies]= ComputeDPrime_AntennaTracking(exptNames, pairs);   
    dP_avgall{1} = dP_avgR;
    dP_stdall{1} = dP_stdR;   
    dP_avgall{2} = dP_avgL;
    dP_stdall{2} = dP_stdL; 
    dP_avgall{3} = dP_avgRMinL;
    dP_stdall{3} = dP_stdRMinL;
    numFliesAll = numFlies;
else
    for ii = 1:length(exptNames)
        [dP_avg, dP_std, numFlies, dPrime_allFlies] = ComputeDPrime_WindNeurons(exptNames{ii}, pairs);
        numFliesAll(ii) = numFlies;
        dP_avgall{ii} = dP_avg;
        dP_stdall{ii} = dP_std;
        dPrime_allFliesallConds{ii} = dPrime_allFlies;
    end
end

%% PLOT D PRIME BY CELL TYPE
if plotType == 0 %dot plot!
    testPairs = ([[1 3];[2 4];[1 5]; [2 6];]);
    starLevels = [1 3 2 4]; %match # pairs above; sets y-position of statistical stars!
    Fig = MakeDotPlotDPrime(dPrime_allFliesallConds, dP_stdall, TEST, diffFigPosition2, yAxis_ipsiContra_wPN, testPairs, starLevels, pairLabels, cellTypes, cellTypeColors);
else %bar plot!
    Fig = figure('Color', 'w', 'Position', dPrimePositions(3,:));
    title({'d'''}); hold on
    numConds = size(exptNames,1);
    for ii = 1:numConds
        dP_avg = dP_avgall{ii};
        dP_std = dP_stdall{ii};
        if strcmp(driver,'antenna') && FRONTAL_ONLY == 2
            ymax = 6; ymin = 0;
            ylim([ymin-0.5 ymax+0.5])
        elseif strcmp(driver,'antenna') && FRONTAL_ONLY == 1
            ymax = 4; ymin = 0;
            ylim([ymin-0.5 ymax+0.5])
        elseif FRONTAL_ONLY == 1
            ymax = 2; ymin = 0;
            ylim([ymin-0.5 ymax+0.5])
        else
            ymax = 10; ymin = 0;
            ylim([ymin-2 ymax+3])
        end
        xx = xticks(ii,:);
        
        b = bar(xx,dP_avg, 'FaceColor', cellTypeColors(ii,:));
        errorbar(xx, dP_avg, dP_std, '.', 'Color', 'black');
        b(1).BaseLine.LineWidth = 1; %format the damn hard-coded line with bar plots...
        b(1).BaseLine.LineStyle = 'none';
        
        %%plot & format y axis
        xx = 0;
        ylabel('d''')
        line([xx xx], [ymax ymin], 'Linewidth', 1, 'Color', 'k')
        text(xx-1, ymin, num2str(ymin), 'Fontsize', fontSize_axis, 'Fontname', figureFont)
        text(xx-1, ymax, num2str(ymax), 'Fontsize', fontSize_axis, 'Fontname', figureFont)
        text(xx-1.5, (ymax-ymin)/2, 'd''', 'HorizontalAlignment', 'center', 'Rotation', 90, 'Fontsize', fontSize_axis, 'Fontname', figureFont)
        
        %% plot & format x axis
        line([xticks(1)-1 xticks(end)+1],[ymin ymin],'Linestyle',':', 'Linewidth', 1, 'Color', 'k')
        xlim([-1 max(max(xticks))+2]);
        xx = xticks(ii,:);
        yy = -0.25*ones(1,length(xx)); %HARD-CODED
        xLabels = pairLabels;
        t = text(xx,yy,[xLabels]);
        set(t,'HorizontalAlignment','right','VerticalAlignment','top', ...
            'Rotation',45, 'Fontsize', fontSize_axis, 'Fontname', figureFont)
        set(gca,'XTickLabel','')
        axis off
        
        %% draw legend of cell type with color
        xx = xticks(ii,1);
        yy = ymax;
        name = [cellTypes{ii}];
        text(xx, yy, name, 'Color', cellTypeColors(ii,:), 'Fontsize', fontSize_axis, ...
            'Fontname', figureFont, 'HorizontalAlignment', 'left', 'Rotation', 0)
    end  
end