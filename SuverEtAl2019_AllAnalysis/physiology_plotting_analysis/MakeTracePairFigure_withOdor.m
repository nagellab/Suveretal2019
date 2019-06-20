%%
% Make figure with a pair of traces side by side on same scale
% inputs: trace1 (typically raw trace), trace2 (typically set of averages)
%
% Suver et al. 2019
%%

function [figHandle] = MakeTracePairFigure_withOdor(trace, ERROR, position, SPIKERATE)
load_figure_constants;
%%
RAW = 0;
name = trace.name;
trace = trace.traces;

if strcmp(trace.condition, '2015_08_28') 
    ANE = 1; else ANE = 0; end
if strcmp(trace.condition, 'PID')
    PID = 1; else PID = 0;
end

%%
figHandle = figure('color', 'w', 'Position', position); hold on
dsamp = trace.DSAMP;
if DOWNSAMPLE dsamp = dsamp*DOWNSAMPLE; end
samplerate = trace.samplerate;
preStim = 1*samplerate/dsamp;
stimDuration_wind = 8*samplerate/dsamp;
stimDuration_odor = 2*samplerate/dsamp;
preOdor = preStim+4*samplerate/dsamp;
baseline = 1:preStim;
axis off
spacing = preStim;
xlim([-preStim 13000]);
if ANE scaleSize = 10; else scaleSize = 3; end %mV
scaleSizeSR = 10;
if SPIKERATE
    scaleSize = scaleSizeSR*traces2.SCALE_SR;
end

%aPN2 raw and average traces
if SPIKERATE  
    if YAXIS_SPIKERATE
        vmAvg = trace.avgSRTrace([2 4 6 8 10],1:DOWNSAMPLE:end)+traces2.avgSR;
    else
        vmAvg = trace.avgSRTrace([2 4 6 8 10],1:DOWNSAMPLE:end);
    end
else
    vmAvg = trace.avgVmTrace([2 4 6 8 10],1:DOWNSAMPLE:end);
end
if ERROR
    if RAW == 0
        vmError1 = trace.errorVm([2 4 6 8 10],1:DOWNSAMPLE:end);
    end
else
    vmError1 = zeros(size(trace.errorVm([2 4 6 8 10],1:DOWNSAMPLE:end)));
end
max_traces_avg = nanmax(nanmax(vmAvg+vmError1./2));
min_traces_avg = nanmin(nanmin(vmAvg-vmError1./2));

if ANE
    yScale = traces_scale_anemometerWithOdor
    yWindBar = min_traces_avg-htWindBar*10;
    htWindBar = htWindBar*6;
elseif strcmp(trace.condition, 'PID') %increase size of trace
    yScale = traces_scale_PID;
    yWindBar = min_traces_avg-htWindBar*1;
    htWindBar = htWindBar*0.25;
else
    yScale = traces_scale;
    yWindBar = min_traces_avg-htWindBar*3;
    htWindBar = htWindBar*1.5;
end
ymin = yWindBar-htWindBar;
ymax = ymin+yScale;
ylim([ymin ymax]);

%plot left trace(s)
%plot patches
if ERROR
    for ii = 1:size(vmAvg, 1)
        cc = colors_fiveDirections(ii,:);
        ccLt = cc + tintSingleFly*(1-cc);
        xx = (1:length(vmError1(ii,:))); %length of trace
        yy = vmAvg(ii,:); %mean line
        err = vmError1(ii,:); %error values (cross-fly, over mean)
        errorTop = yy + err/2;
        errorBottom = yy - err/2;
        if PATCH
            xData = [xx; xx; [xx(2:end) xx(end)]; [xx(2:end) xx(end)]];
            yData = [errorBottom; errorTop; [errorTop(2:end) errorTop(end)]; [errorBottom(2:end) errorBottom(end)]];
            zData = ones(4,length(yData));
            patch(xData, yData, zData, 'FaceColor', ccLt, 'EdgeColor', 'none', 'EdgeAlpha', errorTransparency, 'FaceAlpha', errorTransparency)
        else
            plot(errorTop', 'Color', ccLt)
            plot(errorBottom', 'Color', ccLt)
        end
    end
end
%plot averages
for ii = 1:size(vmAvg, 1)
    plot([vmAvg(ii,:)'], 'Linewidth', width_avgTrace, 'Color', colors_fiveDirections(ii,:))
end
if TITLES
    text(preStim+stimDuration_wind/2, max_traces_avg+htWindBar*5, name, 'Fontname', figureFont, 'Fontsize', fontSize_titles, 'HorizontalAlignment', 'center')
end

% Plot wind stimulus bar below traces
%[preStim+nanLen yWindBar stimOn htWindBar];
rectangle('Position', [preStim yWindBar stimDuration_wind htWindBar], 'FaceColor', 'k', 'EdgeColor', 'none');
gray = [0.6 0.6 0.6];
rectangle('Position', [preOdor yWindBar stimDuration_odor htWindBar], 'FaceColor', gray, 'EdgeColor', 'none');
% Plot wind/odor timing
    text(3*samplerate/dsamp,yWindBar-htWindBar*7.0, {'4 s','wind'}, 'Fontname', figureFont, 'Fontsize', fontSize_axis, 'HorizontalAlignment', 'center')
    text(6*samplerate/dsamp,yWindBar-htWindBar*7.0, {'2 s','odor'}, 'Fontname', figureFont, 'Fontsize', fontSize_axis, 'HorizontalAlignment', 'center')
% And plot N=X (num flies) to the right of the wind stim bar

if ANE
    text(preStim*2+stimDuration_wind, yWindBar, ['N = 5'],'Fontname', figureFont, 'Fontsize', fontSize_titles, 'HorizontalAlignment', 'left')
else
    text(preStim*2+stimDuration_wind, yWindBar, ['N = ' num2str(trace.numFlies)],'Fontname', figureFont, 'Fontsize', fontSize_titles, 'HorizontalAlignment', 'left')
end
% plot scale bar
if ~PID && ~ANE
    if ~YAXIS_SPIKERATE || ~SPIKERATE
        bottomScale = 1.5; %HARD-CODED!
        scaleX = preStim+size(trace.avgVmTrace,2)/DOWNSAMPLE;
        line([scaleX scaleX], [bottomScale bottomScale+scaleSize], 'Color', 'k', 'Linewidth', width_scale)
        scaleTextX = scaleX+0.2*samplerate/dsamp;
        scaleTextY = bottomScale+scaleSize/2;
        if ANE
            text(scaleTextX, scaleTextY, [num2str(scaleSizeSR) ' cm/s'], 'Fontname', figureFont, 'Fontsize', fontSize_axis, 'HorizontalAlignment', 'left')
        elseif SPIKERATE
            text(scaleTextX, scaleTextY, [num2str(scaleSizeSR) ' Hz'], 'Fontname', figureFont, 'Fontsize', fontSize_axis, 'HorizontalAlignment', 'left')
        else
            text(scaleTextX, scaleTextY, [num2str(scaleSize) ' mV'], 'Fontname', figureFont, 'Fontsize', fontSize_axis, 'HorizontalAlignment', 'left')
        end
    elseif SPIKERATE && YAXIS_SPIKERATE
        if strfind(name2, 'WPN')
            tickLocs_y = yAxis_SR_wPN;
        elseif strfind(name2, 'APN')
            tickLocs_y = yAxis_SR_aPN3;
        end
        %% y-axis
        tickLength_yAxis = preStim*0.1;
        yAxis_xLoc = preStim*0.5; %place y-axis left of left rick on x axis by same amount as x axis is below data (convert - axes are different sizes!)
        for ii = 1:length(tickLocs_y)
            line([yAxis_xLoc yAxis_xLoc+tickLength_yAxis], [tickLocs_y(ii) tickLocs_y(ii)], 'Color', axisColor, 'Linewidth', lineWid_axis)
            text(yAxis_xLoc-tickLength_yAxis, tickLocs_y(ii), num2str(tickLocs_y(ii)), 'HorizontalAlignment', 'right', 'Color', axisColor, 'Fontname', figureFont, 'Fontsize', fontSize_axis);
        end
        line([yAxis_xLoc yAxis_xLoc], [tickLocs_y(1) tickLocs_y(end)], 'Color', axisColor, 'Linewidth', lineWid_axis)
        yAxisLabelMid = tickLocs_y(1)+(tickLocs_y(end)-tickLocs_y(1))/2;
        h = text(yAxis_xLoc-tickLength_yAxis*17,yAxisLabelMid, 'response (Hz)', 'HorizontalAlignment', 'center', 'Color', axisColor, 'Fontname', figureFont, 'Fontsize', fontSize_axis);
        set(h,'Rotation',90);
    end
end

