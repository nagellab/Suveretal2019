%%
% Make tuning curve figure for Suver et al. 2018 (five wind directons)
% TRACE TYPE -  %0: steady state tuning, 1: stead+onset tuning, 2: antenna tuning
% last edited by Marie on 4/17/18
%%

function [figHandle] = MakeTuningCurveFigure(tt, TRACE_TYPE, TITLES, position, SPIKERATE)

load_figure_constants;
figHandle = figure('color', 'w', 'Position', position); hold on
axis off %drawing our own! woohoo!
traces = tt.traces;
name = tt.name;
minTraces = 0; maxTraces = 0;

if TRACE_TYPE == 2;
    minTraces = min([traces.rightDeflect_crossFlyAvgs traces.leftDeflect_crossFlyAvgs traces.rightDeflect_crossFlyAvgs-traces.leftDeflect_crossFlyAvgs]);
    errMin = min([nanstd(traces.rightDeflect_indvAvgs-traces.leftDeflect_indvAvgs) nanstd(traces.rightDeflect_indvAvgs) nanstd(traces.leftDeflect_indvAvgs)]);
    minTraces = minTraces-errMin/2; %make room for error bars!
    maxTraces = max([traces.rightDeflect_crossFlyAvgs traces.leftDeflect_crossFlyAvgs traces.rightDeflect_crossFlyAvgs-traces.leftDeflect_crossFlyAvgs]);
    errMax = 0;%max([nanstd(traces.rightDeflect_indvAvgs-traces.leftDeflect_indvAvgs) nanstd(traces.rightDeflect_indvAvgs) nanstd(traces.leftDeflect_indvAvgs)]);
    maxTraces = maxTraces+errMax/2; %make room for error bars!
    lenTraces = length(traces.rightDeflect_crossFlyAvgs);
else
    if TRACE_TYPE == 3
        lenTraces = length(traces{1}.indvTonicWindAvg);
    else
        lenTraces = length(traces.indvTonicWindAvg);
        
        for ii = 1:lenTraces
            if TRACE_TYPE == 1
                if SPIKERATE
                    minTraces = min([minTraces min(traces.indvTonicWindAvg_meanCrossFly_SR{ii}) min(traces.indvOnsetWindAvg_meanCrossFly_SR{ii})]);
                    maxTraces = max([maxTraces max(traces.indvTonicWindAvg_meanCrossFly_SR{ii}) max(traces.indvOnsetWindAvg_meanCrossFly_SR{ii})]);
                else
                    minTraces = min([minTraces min(traces.indvTonicWindAvg_meanCrossFly{ii}) min(traces.indvOnsetWindAvg_meanCrossFly{ii})]);
                    maxTraces = max([maxTraces max(traces.indvTonicWindAvg_meanCrossFly{ii}) max(traces.indvOnsetWindAvg_meanCrossFly{ii})]);
                end
            else
                if SPIKERATE
                    minTraces = min([minTraces min(traces.indvTonicWindAvg_meanCrossFly_SR{ii})]);
                    maxTraces = max([maxTraces max(traces.indvTonicWindAvg_meanCrossFly_SR{ii})]);
                else
                    minTraces = min([minTraces min(traces.indvTonicWindAvg_meanCrossFly{ii})]);
                    maxTraces = max([maxTraces max(traces.indvTonicWindAvg_meanCrossFly{ii})]);
                end
            end
        end
    end
end
for ii = 1:lenTraces
    if TRACE_TYPE == 2 || TRACE_TYPE == 3 %antenna data or normalized curves!
    else
        if SPIKERATE
            plot(traces.indvTonicWindAvg_meanCrossFly_SR{ii}', 'Color', color_tuningAvg_steady_indv, 'Linewidth', lineWid_tuning_indv)
        else
            plot(traces.indvTonicWindAvg_meanCrossFly{ii}', 'Color', color_tuningAvg_steady_indv, 'Linewidth', lineWid_tuning_indv)
        end
        if TRACE_TYPE == 1
            plot(traces.indvOnsetWindAvg_meanCrossFly{ii}', 'Color', color_tuningAvg_onset_indv, 'Linewidth', lineWid_tuning_indv)
        elseif TRACE_TYPE == 4
            plot(traces.indvOdorAvg_meanCrossFly{ii}', 'Color', color_odor_indv, 'Linewidth', lineWid_tuning_indv)
        end
    end
end
if TRACE_TYPE == 2 %antenna data!
    %% plot error patches
    xx = 1:5; %length of trace
    yy = nanmean(traces.rightDeflect_indvAvgs-traces.leftDeflect_indvAvgs); %mean line
    err = nanstd(traces.rightDeflect_indvAvgs-traces.leftDeflect_indvAvgs); %error values (cross-fly, over mean)
    errorTop = yy + err/2;
    errorBottom = yy - err/2;
    xData = [xx; xx; [xx(2:end) xx(end)]; [xx(2:end) xx(end)]];
    yData = [errorBottom; errorTop; [errorTop(2:end) errorTop(end)]; [errorBottom(2:end) errorBottom(end)]];
    zData = ones(4,length(yData));
    patch(xData, yData, zData, 'FaceColor', color_RMINL_patch, 'EdgeColor', 'none', 'EdgeAlpha', errorTransparency, 'FaceAlpha', errorTransparency)
    
    ccLt = color_rightAntenna + tintSingleFly*(1-color_rightAntenna);
    xx = 1:5; %length of trace
    yy = nanmean(traces.rightDeflect_indvAvgs); %mean line
    err = nanstd(traces.rightDeflect_indvAvgs); %error values (cross-fly, over mean)
    errorTop = yy + err/2;
    errorBottom = yy - err/2;
    xData = [xx; xx; [xx(2:end) xx(end)]; [xx(2:end) xx(end)]];
    yData = [errorBottom; errorTop; [errorTop(2:end) errorTop(end)]; [errorBottom(2:end) errorBottom(end)]];
    zData = ones(4,length(yData));
    patch(xData, yData, zData, 'FaceColor', ccLt, 'EdgeColor', 'none', 'EdgeAlpha', errorTransparency, 'FaceAlpha', errorTransparency)
    
    ccLt = color_leftAntenna + tintSingleFly*(1-color_leftAntenna);
    xx = 1:5; %length of trace
    yy = nanmean(traces.leftDeflect_indvAvgs); %mean line
    err = nanstd(traces.leftDeflect_indvAvgs); %error values (cross-fly, over mean)
    errorTop = yy + err/2;
    errorBottom = yy - err/2;
    xData = [xx; xx; [xx(2:end) xx(end)]; [xx(2:end) xx(end)]];
    yData = [errorBottom; errorTop; [errorTop(2:end) errorTop(end)]; [errorBottom(2:end) errorBottom(end)]];
    zData = ones(4,length(yData));
    patch(xData, yData, zData, 'FaceColor', ccLt, 'EdgeColor', 'none', 'EdgeAlpha', errorTransparency, 'FaceAlpha', errorTransparency)
    
    plot(traces.rightDeflect_crossFlyAvgs'-traces.leftDeflect_crossFlyAvgs', 'Color', color_RMINL, 'Linewidth', lineWid_tuning_avg)
    plot(traces.rightDeflect_crossFlyAvgs', 'Color', color_rightAntenna, 'Linewidth', lineWid_tuning_avg)
    plot(traces.leftDeflect_crossFlyAvgs', 'Color', color_leftAntenna, 'Linewidth', lineWid_tuning_avg)
elseif TRACE_TYPE == 3 %APN2, APN3 normalized tuning!
    %APN2
    tt = traces{1};  
    avg1 = tt.avgWR;
    indv = tt.indvTonicWindAvg;
    err1 = nanstd(indv); %error values (cross-fly, over mean)
    origAvg = nanmean(indv);
    err1 = (err1)/(max(origAvg)-min(origAvg)); %scale error using average data
    avg1 = (avg1-min(avg1))/(max(avg1)-min(avg1)); %0 to 1
    for id = 1:size(indv,1)
        indv(id,:) = (indv(id,:)-min(indv(id,:)))/(max(indv(id,:))-min(indv(id,:))); %0 to 1
    end
    %% plot error patches
    ccLt = color_APN2 + tintSingleFly*(1-color_APN2);
    xx = 1:5; %length of trace
    yy = avg1'; %mean line
    errorTop = yy + err1/2;
    errorBottom = yy - err1/2;
    xData = [xx; xx; [xx(2:end) xx(end)]; [xx(2:end) xx(end)]];
    yData = [errorBottom; errorTop; [errorTop(2:end) errorTop(end)]; [errorBottom(2:end) errorBottom(end)]];
    zData = ones(4,length(yData));
    patch(xData, yData, zData, 'FaceColor', ccLt, 'EdgeColor', 'none', 'EdgeAlpha', errorTransparency, 'FaceAlpha', errorTransparency)
    
    %APN3
    tt = traces{2};  
    avg2 = tt.avgWR;
    indv = tt.indvTonicWindAvg;
    err2 = nanstd(indv); %error values (cross-fly, over mean)
    origAvg = nanmean(indv);
    err2 = (err2)/(max(origAvg)-min(origAvg)); %scale error using average data
    avg2 = (avg2-min(avg2))/(max(avg2)-min(avg2)); %0 to 1
    for id = 1:size(indv,1)
        indv(id,:) = (indv(id,:)-min(indv(id,:)))/(max(indv(id,:))-min(indv(id,:))); %0 to 1
    end
    %% plot error patches
    ccLt = color_APN3 + tintSingleFly*(1-color_APN3);
    xx = 1:5; %length of trace
    yy = avg2'; %mean line
    errorTop = yy + err2/2;
    errorBottom = yy - err2/2;
    xData = [xx; xx; [xx(2:end) xx(end)]; [xx(2:end) xx(end)]];
    yData = [errorBottom; errorTop; [errorTop(2:end) errorTop(end)]; [errorBottom(2:end) errorBottom(end)]];
    zData = ones(4,length(yData));
    patch(xData, yData, zData, 'FaceColor', ccLt, 'EdgeColor', 'none', 'EdgeAlpha', errorTransparency, 'FaceAlpha', errorTransparency)
   
    plot(avg1, 'Color', color_APN2, 'Linewidth', lineWid_tuning_avg)
    plot(avg2, 'Color', color_APN3, 'Linewidth', lineWid_tuning_avg)
elseif TRACE_TYPE == 4
    plot(traces.avgWR, 'Color', color_tuningAvg_steady, 'Linewidth', lineWid_tuning_avg)
    plot(traces.avgOR, 'Color', color_odor_avg, 'Linewidth', lineWid_tuning_avg)
else
    if SPIKERATE
        plot(traces.avgWR_SR, 'Color', color_tuningAvg_steady, 'Linewidth', lineWid_tuning_avg)
    else
        plot(traces.avgWR, 'Color', color_tuningAvg_steady, 'Linewidth', lineWid_tuning_avg)
    end
    if TRACE_TYPE == 1
        if SPIKERATE
            plot(traces.avgWRMax_SR, 'Color', color_tuningAvg_onset, 'Linewidth', lineWid_tuning_avg)
        end
        plot(traces.avgWRMax, 'Color', color_tuningAvg_onset, 'Linewidth', lineWid_tuning_avg)
    end
end

%% Set x and y axis limits
if TRACE_TYPE == 2
    ylim([minTraces-3 minTraces-3+tuning_scale_antenna]);
    yRange = tuning_scale_antenna;
elseif TRACE_TYPE == 3
    ylim([-0.75 1.5]);
    yRange = tuning_scale_normalized;
elseif SPIKERATE
    ylim([minTraces-3 maxTraces]);
    yRange = tuning_scale_spikerate;
else
    ylim([minTraces-3 minTraces-3+tuning_scale_neural]);
    yRange = tuning_scale_neural;
end

xMin_data = 1; xMax_data = 5;
xlim([xMin_data-2 xMax_data+1]);
xRange = (xMax_data+1)-(xMin_data-2);
oneUnitConverted = xRange/yRange;
minTick_Y = floor(minTraces);
maxTick_Y = ceil(maxTraces);
if SPIKERATE
    spacing_yTicks = 10; %HARD-CODED
    tickLength_xAxis = 1;
    xAxis_yLoc = minTick_Y-1;

elseif TRACE_TYPE == 3
    spacing_yTicks = 10; %HARD-CODED
    tickLength_xAxis = 0.05;
    xAxis_yLoc = minTick_Y-0.5;
else
    spacing_yTicks = 4; %HARD-CODED
    tickLength_xAxis = 0.5;
    xAxis_yLoc = minTick_Y-1;
end

%% Plot x-axis (detached with directions)
tickLength_yAxis = tickLength_xAxis*oneUnitConverted*1.3; %HARD-CODED
if mod(minTick_Y, 2) %bottom value odd
    minTick_Y = minTick_Y-1; %decrease to even
    if mod(maxTick_Y, 2) == 1%top tick odd - increase to even
        maxTick_Y = maxTick_Y+1;
    end
else %even bottom tick 
    if mod(maxTick_Y, 2) == 1%top tick odd; increase to even
        maxTick_Y = maxTick_Y+1;
    end
end

%x-axis
tickLocs_x = [1 2 3 4 5];
for ii = 1:length(tickLocs_x)
    line([tickLocs_x(ii) tickLocs_x(ii)], [xAxis_yLoc xAxis_yLoc+tickLength_xAxis], 'Color', axisColor, 'Linewidth', lineWid_axis)
    text(tickLocs_x(ii), xAxis_yLoc-tickLength_xAxis*2, directionNames{ii}, 'HorizontalAlignment', 'center', 'Color', axisColor, 'Fontname', figureFont, 'Fontsize', fontSize_axis);
end
line([xMin_data xMax_data], [xAxis_yLoc xAxis_yLoc], 'Color', axisColor, 'Linewidth', lineWid_axis)
xAxisLabelMid = tickLocs_x(1)+(tickLocs_x(end)-tickLocs_x(1))/2;
text(xAxisLabelMid, xAxis_yLoc-tickLength_xAxis*5, 'wind direction', 'HorizontalAlignment', 'center', 'Color', axisColor, 'Fontname', figureFont, 'Fontsize', fontSize_axis);

%% y-axis
if TRACE_TYPE == 3
    maxTick_Y = 1;
    minTick_Y = 0;
    spacing_yTicks = 1;
elseif strcmp(name, 'APN3 wind+odor tuning')
    maxTick_Y = 10;
    spacing_yTicks = 10;
elseif strcmp(name, 'WPN wind+odor tuning')
    spacing_yTicks = 6;
end

tickLocs_y = minTick_Y:spacing_yTicks:maxTick_Y;
if maxTick_Y > tickLocs_y(end) %basically rounds down to nearest spaced tick
    maxTick_Y = tickLocs_y(end);
end
if TRACE_TYPE == 3
    yAxis_xLoc = xMin_data-0.3*oneUnitConverted; %place y-axis left of left tick on x axis by same amount as x axis is below data (convert - axes are different sizes!)
else
    yAxis_xLoc = xMin_data-2*oneUnitConverted; %place y-axis left of left tick on x axis by same amount as x axis is below data (convert - axes are different sizes!)
end
for ii = 1:length(tickLocs_y)
    line([yAxis_xLoc yAxis_xLoc+tickLength_yAxis], [tickLocs_y(ii) tickLocs_y(ii)], 'Color', axisColor, 'Linewidth', lineWid_axis)
    text(yAxis_xLoc-tickLength_yAxis, tickLocs_y(ii), num2str(tickLocs_y(ii)), 'HorizontalAlignment', 'right', 'Color', axisColor, 'Fontname', figureFont, 'Fontsize', fontSize_axis);
end
line([yAxis_xLoc yAxis_xLoc], [minTick_Y maxTick_Y], 'Color', axisColor, 'Linewidth', lineWid_axis)
yAxisLabelMid = tickLocs_y(1)+(tickLocs_y(end)-tickLocs_y(1))/2;
if TRACE_TYPE == 2
    h = text(yAxis_xLoc-tickLength_yAxis*6,yAxisLabelMid, 'response (deg)', 'HorizontalAlignment', 'center', 'Color', axisColor, 'Fontname', figureFont, 'Fontsize', fontSize_axis);
elseif TRACE_TYPE == 3
    h = text(yAxis_xLoc-tickLength_yAxis*6,yAxisLabelMid, 'response', 'HorizontalAlignment', 'center', 'Color', axisColor, 'Fontname', figureFont, 'Fontsize', fontSize_axis);
elseif SPIKERATE
    h = text(yAxis_xLoc-tickLength_yAxis*6,yAxisLabelMid, 'response (Hz)', 'HorizontalAlignment', 'center', 'Color', axisColor, 'Fontname', figureFont, 'Fontsize', fontSize_axis);
else
    h = text(yAxis_xLoc-tickLength_yAxis*6,yAxisLabelMid, 'response (mV)', 'HorizontalAlignment', 'center', 'Color', axisColor, 'Fontname', figureFont, 'Fontsize', fontSize_axis);
end
set(h,'Rotation',90);

%%Plot "legend"
if TRACE_TYPE == 4
    text(1.5, maxTick_Y, 'wind', 'HorizontalAlignment', 'center', 'Color', color_tuningAvg_steady, 'Fontname', figureFont, 'Fontsize', fontSize_axis);
    text(1.5, maxTick_Y-1.5, '+odor', 'HorizontalAlignment', 'center', 'Color', color_odor_avg, 'Fontname', figureFont, 'Fontsize', fontSize_axis);
end

%%
if TITLES
    title([name]);
end


