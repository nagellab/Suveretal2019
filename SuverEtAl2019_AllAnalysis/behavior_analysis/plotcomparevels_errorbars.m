
function plotcomparevels_errorbars (lin,varargin)

% plotcomparevels (alignment, varargin)
%
%   alignment -> Either 'onset' or 'offset' (string), will determine the
%                point of alignment for the different traces. If you want
%                to plot data without stimulus, you can give it any value
%                (it will be ignored but has to be specified).
%
%   varargin -> (any number of) Structure arrays containing data to compare.
%
% This function produces a plot comparing the different velocities of the
% groups specified. It aligns the traces either to stimulus onset, offset,
% or to nothing if there is no stimulus (still the variable 'alignment' has
% to be entered, with whatever value).

% Set 'errors' to 0 for not plotting error lines, 1 for plotting them
errors = 0; 


% Sets better color codes
if length(varargin)<8
    colorines = [
        %0.65    0.1   0.05;
         %0.1 0 0.65;
         101/255 101/255 101/255;
        255/255 128/255 110/255; %peach and blue
        
        85/255 151/255 255/255;
        146/255 178/255 50/255;
        %0/255 127/255 180/255; blue and red for hot cold
        %166/255 26/255 16/255;
        0    0.4470    0.7410;...
        0.8500    0.3250    0.0980;...
        0.9290    0.6940    0.1250;...
        0.4940    0.1840    0.5560;...
        0.4660    0.6740    0.1880;...
        0.3010    0.7450    0.9330;...
        0.6350    0.0780    0.1840];
else
    % colorines = {'k','b','m',[1 .5 0], 'r', 'm'};
    colorines=jet(length(varargin));
end

figure('color','white', 'position',[0 0 350 800]);
set(0,'DefaultAxesTickDir', 'out')
labels = [];
% % Checks if there are mixed blank and stimuli trials
% for i = 1:length(varargin)
%     if ~isempty(find(varargin{i}(1).stimulus(:,1) == 1));
%         mix(i) = 1;
%     else isempty(find(varargin{i}(1).stimulus(:,1) == 1));
%         mix(i) = 0;
%     end
% end
% if ~isempty(find(mix==0)) && ~isempty(find(mix==1)), mix = 1; else, mix = 0; end


% Draws unimportant dots so that the legend is easy to set
for i = 1:length(varargin)
    subplot(4,1,1); plot(-200,0,'color',colorines(i,:),'linewidth',3); hold on
    subplot(4,1,2); plot(-200,2,'color',colorines(i,:),'linewidth',3); hold on
    subplot(4,1,3); plot(-200,0.6,'color',colorines(i,:),'linewidth',3); hold on
    subplot(4,1,4); plot(-200,20,'color',colorines(i,:),'linewidth',3); hold on
end


% Plots
for i = 1:length(varargin)
    
    pmovedat=[];vmovedat=[];vymovedat=[];pturndat=[];angvturndat=[];curvaturedat=[]; linearitydat=[]; % Resets variables
    
    for fly = 1:length(varargin{i})
        
        % Fills in data from each fly
        pmovedat(:,fly) = nanmean(varargin{i}(fly).pmove,2);
        vmovedat(:,fly) = nanmean(varargin{i}(fly).vmove,2);
        vymovedat(:,fly) = nanmean(varargin{i}(fly).vymove,2);

        pturndat(:,fly) = nanmean(varargin{i}(fly).pturn,2);
        angvturndat(:,fly) = nanmean(varargin{i}(fly).angvturn,2);

        curvaturedat(:,fly) = nanmean(varargin{i}(fly).curvature,2);
        if lin
        linearitydat(:,fly) = nanmean(varargin{i}(fly).linearity,2);
        end
        
    end
    
    % Removes the last 2 seconds to avoid noisy averaging
    pmovedat(end-100:end,:) = [];
    vmovedat(end-100:end,:) = [];
    vymovedat(end-100:end,:) = [];
    pturndat(end-100:end,:) = [];
    angvturndat(end-100:end,:) = [];
    curvaturedat(end-100:end,:) = [];
    if lin
    linearitydat(end-100:end,:)=[];
    end
    
    % Averages and allocates for the final representation
    pmove = nanmean(pmovedat,2); 
    vmove = nanmean(vmovedat,2); 
    vymove = nanmean(vymovedat,2); 

    pturn = nanmean(pturndat,2); 
    angvturn = nanmean(angvturndat,2); 

    curvature = nanmean(curvaturedat,2); 
    if lin
    linearity = nanmean(linearitydat,2);
    end
    
%     vy = nanmean(horzcat(varargin{i}.vy),2); vy(end-100:end) = [];
%     v = nanmean(horzcat(varargin{i}.v),2); v(end-100:end) = [];
%     linearity = nanmean(horzcat(varargin{i}.linearity),2); linearity(end-100:end) = [];
%     angv = nanmean(horzcat(varargin{i}.angv),2); angv(end-100:end) = [];
%     lsscore = nanmean(horzcat(varargin{i}.lsscore),2); lsscore(end-100:end) = [];
    
%     % Calculates standard errors
%     if errors == 1
%         vysem = sem(horzcat(varargin{i}.vy)); vysem(end-100:end) = [];
%         vsem = sem(horzcat(varargin{i}.v)); vsem(end-100:end) = [];
%         linearitysem = sem(horzcat(varargin{i}.linearity)); linearitysem(end-100:end) = [];
%         angvsem = sem(horzcat(varargin{i}.angv)); angvsem(end-100:end) = [];
% %         lsscoresem = sem(horzcat(varargin{i}.lsscore)); lsscoresem(end-100:end) = [];
%     end
    
    lab = ['Set #', num2str(i)]; %, ' ',varargin{i}(1).mode{1}];
    labels = [labels; lab];
    
    dur = length(vmove);
%     durli = length(linearity);
%     dursc = length(lsscore);
    
    stind = find(varargin{i}(1).stimulus(:,1) == 1);
    %if ~isempty(stind)
    %    switch alignment
    %        case 'onset'
    %            aligntime = stind(1)/50;
    %        case 'offset'
    %            aligntime = stind(end)/50;
    %    end
    %    plotmin = round(stind(1)/2)/50 -aligntime;
    %    plotmax = (dur/50) -2 -aligntime;
    %elseif isempty(stind)
    %    aligntime = 30;
    %    plotmin = -15;
    %    plotmax = 38;
    plotmin=20;
    plotmax=60;
    %end
    
    
    
    subplot(6,1,1);
    %plot((0.02:0.02:dur*0.02), pmove, 'color', colorines(i,:), 'linewidth',3)
    shadedErrorBar((0.02:0.02:dur*0.02), pmove,(nanstd(pmovedat')/sqrt(size(pmovedat,2)))',{'color',colorines(i,:),'lineWidth',2},0)
    hold on
    ylabel('P(v>1 mm/s)')
    title('PROBABILITY OF MOVING');
    box off
    axis tight
    xlim([plotmin, plotmax]);
    set(findall(gca, '-property', 'FontSize'), 'FontSize', 16)


    subplot(6,1,2);
    %plot((0.02:0.02:dur*0.02), vmove, 'color', colorines(i,:), 'linewidth',3)
    shadedErrorBar((0.02:0.02:dur*0.02), vmove,(nanstd(vmovedat')/sqrt(size(vmovedat,2)))',{'color',colorines(i,:),'lineWidth',2},0)
    hold on
    ylabel('mm/s')
    title('GROUND SPEED');
    box off
    axis tight
    xlim([plotmin, plotmax]);
    set(findall(gca, '-property', 'FontSize'), 'FontSize', 16)


    subplot(6,1,3);
    %plot((0.02:0.02:dur*0.02), vymove, 'color', colorines(i,:), 'linewidth',3)
    shadedErrorBar((0.02:0.02:dur*0.02), vymove,(nanstd(vymovedat')/sqrt(size(vymovedat,2)))',{'color',colorines(i,:),'lineWidth',2},0)
    hold on
    ylabel('mm/s')
    title('UPWIND VELOCITY');
    box off
    axis tight
    xlim([plotmin, plotmax]);
    set(findall(gca, '-property', 'FontSize'), 'FontSize', 16)


    subplot(6,1,4);
    %plot((0.02:0.02:dur*0.02), pturn, 'color', colorines(i,:), 'linewidth',3)
    shadedErrorBar((0.02:0.02:dur*0.02), pturn,(nanstd(pturndat')/sqrt(size(pturndat,2)))',{'color',colorines(i,:),'lineWidth',2},0)
    hold on
    ylabel('P(angv>10 deg/s')
    title('PROBABILITY OF TURNING');
    box off
    axis tight
    xlim([plotmin, plotmax]);
    set(findall(gca, '-property', 'FontSize'), 'FontSize', 16)

    
    subplot(6,1,5);
    %plot((0.02:0.02:dur*0.02), angvturn, 'color', colorines(i,:), 'linewidth',3)
    shadedErrorBar((0.02:0.02:dur*0.02), angvturn,(nanstd(angvturndat')/sqrt(size(angvturndat,2)))',{'color',colorines(i,:),'lineWidth',2},0)
    hold on
    ylabel('deg/s')
    title('ANGULAR VELOCITY');
    box off
    axis tight
    xlim([plotmin, plotmax]);
    set(findall(gca, '-property', 'FontSize'), 'FontSize', 16)

    
    subplot(6,1,6);
    %plot((0.02:0.02:dur*0.02), curvature, 'color', colorines(i,:), 'linewidth',3)
    shadedErrorBar((0.02:0.02:dur*0.02), curvature,(nanstd(curvaturedat')/sqrt(size(curvaturedat,2)))',{'color',colorines(i,:),'lineWidth',2},0)
    hold on
    ylabel('deg/mm')
    xlabel('time (s)')
    title('CURVATURE');
    box off
    axis tight
    xlim([plotmin, plotmax]);
    set(findall(gca, '-property', 'FontSize'), 'FontSize', 16)

    if lin
    subplot(7,1,7);
    plot((0.02:0.02:((dur-250)*0.02)), linearity, 'color', colorines(i,:), 'linewidth',3)
    hold on
    ylabel('?')
    xlabel('time (s)')
    title('LINEARITY');
    box off
    axis tight
    xlim([plotmin, plotmax]);
    set(findall(gca, '-property', 'FontSize'), 'FontSize', 16)

    end


    
    % Plots error lines if selected
    if errors == 1
        subplot(4,1,1);
        hold on
        plot((0.02:0.02:dur*0.02), vy+vysem, 'color', colorines(i,:), 'linewidth',1)
        plot((0.02:0.02:dur*0.02), vy-vysem, 'color', colorines(i,:), 'linewidth',1)
        axis tight
        xlim([plotmin, plotmax]);
        
        subplot(4,1,2);
        hold on
        plot((0.02:0.02:dur*0.02), v+vsem, 'color', colorines(i,:), 'linewidth',1)
        plot((0.02:0.02:dur*0.02), v-vsem, 'color', colorines(i,:), 'linewidth',1)
        axis tight
        xlim([plotmin, plotmax]);
        
        subplot(4,1,3);
        hold on
        plot((0.02:0.02:durli*0.02), linearity+linearitysem, 'color', colorines(i,:), 'linewidth',1)
        plot((0.02:0.02:durli*0.02), linearity-linearitysem, 'color', colorines(i,:), 'linewidth',1)
        axis tight
        xlim([plotmin, plotmax]);
        
        subplot(4,1,4);
        hold on
        plot((0.02:0.02:dur*0.02), angv+angvsem, 'color', colorines(i,:), 'linewidth',1)
        plot((0.02:0.02:dur*0.02), angv-angvsem, 'color', colorines(i,:), 'linewidth',1)
        axis tight
        xlim([plotmin, plotmax]);
    end

    
    
end


if ~lin
%subplot(6,1,3);
%plot([-100 100],[0 0],'color', 'k');
%subplot(6,1,1); legend('hot','cold');
end

set(gcf,'PaperPositionMode','auto');
