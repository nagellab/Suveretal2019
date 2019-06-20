%%
% Does not plot odor characteristics. Does not include imaging data.
% FIG_TYPE == 1 gives bar chart version of the plot, 2 gives text version
%
%%

function [fig_maxOnset fig_maxSteady fig_dynRange fig_dPrime] = PlotDriverMetrics(FIG_TYPE)
PLOT_NUM_CELLS = 1;

load_figure_constants;
dir = '../SuverEtAl2019_DATA/';
load([dir 'listDrivers']); %load the list of all driver lines!

%% compute relevant measures
all_maxOnset = []; all_maxSteady = []; all_dynRange = []; all_dPrime = [];
for ii = 1:length(listDrivers) %[2 3 7 11 22 34]
    driverName = listDrivers{ii};
    load([dir '/windNeuronScreen/' driverName '.mat']);
    
    mm = max(abs(driver.windOnMax));
    all_maxOnset = [all_maxOnset mm];
    
    ss = max(abs(driver.windTonic));
    all_maxSteady = [all_maxSteady ss];
    
    dr = max(abs(driver.windTonicRange));
    all_dynRange = [all_dynRange dr];

    dp = max(abs(mean(driver.dPrime_crossFlyAvg)));
    all_dPrime = [all_dPrime dp];    
    
    numFlies(ii) = driver.numFlies;
end

if FIG_TYPE == 1 %plot bar-chart version of the metrics
    fig_dynRange = figure('Color', 'w', 'Position', position_screen1);
    fig_maxOnset = figure('Color', 'w', 'Position', position_screen2);
    fig_maxSteady = figure('Color', 'w', 'Position', position_screen3);
    
    fig_dPrime = figure('Color', 'w', 'Position', position_screen4);
    
    
    %% plot dynamic range
    figure(fig_dynRange); hold on;title('Dynamic range', 'Fontsize', fontSize_axis)
    ylim([-2 10]); ylabel('response (mV)', 'Fontsize', fontSize_axis)
    ax1 = gca;
    ax1.XAxis.Visible = 'off';   % remove x-axis
    ax1.FontSize = fontSize_axis;
    [sortedVals, sortedInds] = sort(all_dynRange, 'descend');
    bb = bar(sortedVals, 'k');
    for ii = 1:length(listDrivers) %plot names of associated drivers! :D
        text(ii, -0.5, listDrivers{sortedInds(ii)}, 'Rotation', 45, 'HorizontalAlignment', 'right', ...
            'Color', 'k', 'Fontname', figureFont, 'Fontsize', fontSize_axis)
        if PLOT_NUM_CELLS
            text(ii, sortedVals(ii)+0.5, num2str(numFlies(sortedInds(ii))), 'Rotation', 0, 'HorizontalAlignment', 'center', ...
            'Color', 'k', 'Fontname', figureFont, 'Fontsize', fontSize_axis)
        end
        
    end
    bb(1).BaseLine.LineWidth = 1; %format the damn hard-coded line with bar plots...
    bb(1).BaseLine.LineStyle = 'none';
    
    %% plot max onset
    figure(fig_maxOnset); hold on; title('Maximum onset response', 'Fontsize', fontSize_axis)
    ylim([-5 25]); ylabel('response (mV)', 'Fontsize', fontSize_axis)
    ax1 = gca;
    ax1.XAxis.Visible = 'off';   % remove x-axis
    ax1.FontSize = fontSize_axis;
    %[sortedVals, sortedInds] = sort(all_maxOnset, 'descend');
    sortedVals = all_maxOnset(sortedInds);
    bb = bar(sortedVals, 'k');
    for ii = 1:length(listDrivers) %plot names of associated drivers! :D
        text(ii, -1, listDrivers{sortedInds(ii)}, 'Rotation', 45, 'HorizontalAlignment', 'right', ...
            'Color', 'k', 'Fontname', figureFont, 'Fontsize', fontSize_axis)
    end
    bb(1).BaseLine.LineWidth = 1; %format the damn hard-coded line with bar plots...
    bb(1).BaseLine.LineStyle = 'none';
    
    %% plot max tonic
    figure(fig_maxSteady); hold on; title('Maximum steady state response', 'Fontsize', fontSize_axis)
    ylim([-2 10]); ylabel('response (mV)', 'Fontsize', fontSize_axis)
    ax1 = gca;
    ax1.XAxis.Visible = 'off';   % remove x-axis
    ax1.FontSize = fontSize_axis; %set fontsize
    %[sortedVals, sortedInds] = sort(all_maxSteady, 'descend');
    sortedVals = all_maxSteady(sortedInds);
    bb = bar(sortedVals, 'k');
    for ii = 1:length(listDrivers) %plot names of associated drivers! :D
        text(ii, -0.5, listDrivers{sortedInds(ii)}, 'Rotation', 45, 'HorizontalAlignment', 'right', ...
            'Color', 'k', 'Fontname', figureFont, 'Fontsize', fontSize_axis)
    end
    bb(1).BaseLine.LineWidth = 1; %format the damn hard-coded line with bar plots...
    bb(1).BaseLine.LineStyle = 'none';

    
    %% plot D'
    figure(fig_dPrime); hold on;title('D''', 'Fontsize', fontSize_axis)
    ylim([-0.5 2]); ylabel('D''', 'Fontsize', fontSize_axis)
    ax1 = gca;
    ax1.XAxis.Visible = 'off';   % remove x-axis
    ax1.FontSize = fontSize_axis;
    %[sortedVals, sortedInds] = sort(all_dPrime, 'descend');
    sortedVals = all_dPrime(sortedInds);
    bb = bar(sortedVals, 'k');
    for ii = 1:length(listDrivers) %plot names of associated drivers! :D
        text(ii, -0.1, listDrivers{sortedInds(ii)}, 'Rotation', 45, 'HorizontalAlignment', 'right', ...
            'Color', 'k', 'Fontname', figureFont, 'Fontsize', fontSize_axis)
    end
    bb(1).BaseLine.LineWidth = 1; %format the damn hard-coded line with bar plots...
    bb(1).BaseLine.LineStyle = 'none';   
    
elseif FIG_TYPE == 2 %plot text version of the metrics
    fig_maxOnset = figure('Color', 'w', 'Position', position_windNeuronScreen1);
    fig_maxSteady = figure('Color', 'w', 'Position', position_windNeuronScreen2);
    fig_dynRange = figure('Color', 'w', 'Position', position_windNeuronScreen3);
    fig_dPrime = figure('Color', 'w', 'Position', position_windNeuronScreen4);
   
    for ii = 1:length(listDrivers) %[2 3 7 11 22 34]
        driverName = listDrivers{ii};
        load([dir '/windNeuronScreen/' driverName '.mat']);
        
        figure(fig_maxOnset); hold on;
        mm = all_maxOnset(ii);
        text(rand*2, mm, driverName, 'Fontname', figureFont, 'Fontsize', fontSize_axis);
        
        ss = all_maxSteady(ii);
        figure(fig_maxSteady); hold on;
        text(rand*2, ss, driverName, 'Fontname', figureFont, 'Fontsize', fontSize_axis);

        dr = all_dynRange(ii);
        figure(fig_dynRange); hold on;
        text(rand*2, dr, driverName, 'Fontname', figureFont, 'Fontsize', fontSize_axis);

        dp = all_dPrime(ii);
        figure(fig_dPrime); hold on;
        text(rand*2, dp, driverName, 'Fontname', figureFont, 'Fontsize', fontSize_axis);  
    end
    figure(fig_maxOnset); hold on; title('Max onset', 'Fontname', figureFont, 'Fontsize', fontSize_axis)
    xlim([-0.5 4])
    ylim([-0.5 22])%max(all_maxOnset)+1])
    
    figure(fig_maxSteady); hold on; title('Max steady', 'Fontname', figureFont, 'Fontsize', fontSize_axis)
    xlim([-0.5 4])
    ylim([-0.5 10])%max(all_maxSteady)+1])
    
    figure(fig_dynRange); hold on; title('Dynamic range', 'Fontname', figureFont, 'Fontsize', fontSize_axis)
    xlim([-0.5 4])
    ylim([-0.5 10])%max(all_dynRange)+1])
    
    figure(fig_dPrime); hold on; title('D'' (mean frontal -45/0, 0/45)', 'Fontname', figureFont, 'Fontsize', fontSize_axis)
    xlim([-0.5 4])
    ylim([-0.1 1.5])%max(all_dPrime)+1])
end



