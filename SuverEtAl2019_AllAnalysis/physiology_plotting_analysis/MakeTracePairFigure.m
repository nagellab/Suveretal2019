%%
% Make figure with a pair of traces side by side on same scale
% inputs: trace1 (typically raw trace), trace2 (typically set of averages)
%
% Used for multiple figures in
% Suver et al. 2019
%%

function [figHandle] = MakeTracePairFigure(trace1, trace2, ERROR, position, SPIKERATE)
load_figure_constants;
%%
if size(trace1.traces,2) == 2 %plotting two sets of raw traces!
    RAW = 2;
elseif size(trace1.traces,1) == 1
    RAW = 0;
else
    RAW = 1;
end

name1 = trace1.name;
traces1 = trace1.traces;
name2 = trace2.name;
traces2 = trace2.traces;
if strfind(traces2.condition, 'Ane') | strfind(traces2.condition, 'ANE') | strfind(traces2.condition, 'ane')
    ANE = 1; else ANE = 0; end

%%
figHandle = figure('color', 'w', 'Position', position); hold on
dsamp = traces2.DSAMP;
if DOWNSAMPLE dsamp = dsamp*DOWNSAMPLE; end
samplerate = traces2.samplerate;
preStim = traces2.preStim*samplerate/dsamp;
stimOn = traces2.stimOn*samplerate/dsamp;
baseline = 1:preStim;
axis off
spacing = preStim;
xlim([-preStim size(traces2.avgVmTrace,2)/DOWNSAMPLE*2+preStim*2])
if ANE scaleSize = 10; else scaleSize = 3; end %mV
scaleSizeSR = 10;
if SPIKERATE
    scaleSize = scaleSizeSR*traces2.SCALE_SR;
end

% Figure 2B and 2C: aPN2 raw and average traces
if RAW == 1
    traces1 = traces1(1:dsamp:end); %downsample!
    traces1 = traces1-mean(traces1(baseline)); %baseline-subtrace raw trace
elseif RAW == 2
    raw_ipsi = traces1(1:dsamp:end,1); %downsample!
    raw_ipsi = raw_ipsi-mean(traces1(baseline,1)); %baseline-subtrace raw trace
    raw_contra = traces1(1:dsamp:end,2); %downsample!
    raw_contra = raw_contra-mean(traces1(baseline,2)); %baseline-subtrace raw trace
else 
    vmAvg1 = traces1.avgVmTrace([2 4 6 8 10],1:DOWNSAMPLE:end);
end
if SPIKERATE  
    if YAXIS_SPIKERATE
        traces2.avgSR
        vmAvg = traces2.avgSRTrace([2 4 6 8 10],1:DOWNSAMPLE:end)+traces2.avgSR;
    else
        vmAvg = traces2.avgSRTrace([2 4 6 8 10],1:DOWNSAMPLE:end);
    end
else
    vmAvg = traces2.avgVmTrace([2 4 6 8 10],1:DOWNSAMPLE:end);
end
if ERROR
    if RAW == 0
        vmError1 = traces1.errorVm([2 4 6 8 10],1:DOWNSAMPLE:end);
    end
    if SPIKERATE %NO ERROR PRE-COMPUTED FOR SPIKERATE; NEED TO DO MANUALLY IF WE WANT THIS, OR EDIT ORIGINAL ANALYSIS
        vmError2 = nan(size(traces2.errorVm([2 4 6 8 10],1:DOWNSAMPLE:end)));
    else
        vmError2 = traces2.errorVm([2 4 6 8 10],1:DOWNSAMPLE:end);
    end
else
    vmError1 = zeros(size(traces2.errorVm([2 4 6 8 10],1:DOWNSAMPLE:end)));
    vmError2 = zeros(size(traces2.errorVm([2 4 6 8 10],1:DOWNSAMPLE:end)));
end
if RAW == 0
    max_traces_avg = nanmax([nanmax(vmAvg+vmError2./2) nanmax(vmAvg1+vmError1./2)]);
    min_traces_avg = nanmin([nanmin(vmAvg-vmError2./2) nanmin(vmAvg1-vmError1./2)]);
elseif RAW == 1
    max_traces_avg = nanmax([nanmax(vmAvg+vmError2./2) nanmax(traces1)]);
    min_traces_avg = nanmin([nanmin(vmAvg-vmError2./2) nanmin(traces1)]);
elseif RAW == 2
    max_traces_avg = nanmax([nanmax(vmAvg+vmError2./2) nanmax([raw_ipsi raw_contra])]);
    min_traces_avg = nanmin([nanmin(vmAvg-vmError2./2) nanmin([raw_ipsi raw_contra])]);
end

if ANE
    yScale = traces_scale_anemometer;
    yWindBar = min_traces_avg-htWindBar*10;
else
    yScale = traces_scale;
    yWindBar = min_traces_avg-htWindBar*2;
end
ymin = yWindBar-htWindBar;
ymax = ymin+yScale;
ylim([ymin ymax]);

%plot left trace(s)
if RAW == 1 
    if RAW_ZOOM && ~strcmp(trace1.name, [' '])%plot region in zoomed raw trace
        lenRaw = raw_len_stim/dsamp;
        leftRaw = raw_start_stim/dsamp;
        bottomRect = mean(traces1(leftRaw:(leftRaw+lenRaw)))-ht_stim/2;
        pos = [leftRaw bottomRect lenRaw ht_stim];
        rectangle('Position', pos, 'Edgecolor', color_zoom)
    end
    plot([traces1], 'Color', color_rawTrace, 'Linewidth', width_rawTrace)
    if TITLES
        text(preStim+stimOn/2, max_traces_avg+htWindBar*2, name1, 'Fontname', figureFont, 'Fontsize', fontSize_titles, 'HorizontalAlignment', 'center')
    end
    nanLen = length(traces1)+spacing;
elseif RAW == 2   
    if RAW_ZOOM && ~strcmp(trace1.name, [' '])%plot region in zoomed raw trace
        lenRaw = raw_len_stim/dsamp;
        leftRaw = raw_start_stim/dsamp;
        bottomIpsi = min(raw_ipsi(leftRaw:(leftRaw+lenRaw)))+boxShiftY;
        pos = [leftRaw bottomIpsi lenRaw ht_stim];
        rectangle('Position', pos, 'Edgecolor', color_zoom)
        bottomContra = min(raw_contra(leftRaw:(leftRaw+lenRaw)))+boxShiftY;
        pos = [leftRaw bottomContra lenRaw ht_stim];
        rectangle('Position', pos, 'Edgecolor', color_zoom)
    end
    
    plot([raw_ipsi], 'Color', colors_fiveDirections(5,:), 'Linewidth', width_rawTrace)
    plot([raw_contra], 'Color', colors_fiveDirections(1,:), 'Linewidth', width_rawTrace)
    if TITLES
        text(preStim+stimOn/2, max_traces_avg+htWindBar*2, name1, 'Fontname', figureFont, 'Fontsize', fontSize_titles, 'HorizontalAlignment', 'center')
    end
    nanLen = length(raw_ipsi)+spacing;
elseif RAW == 0 %plotting a second average set!
    %plot patches
    if ERROR
        for ii = 1:size(vmAvg1, 1)
            cc = colors_fiveDirections(ii,:);
            ccLt = cc + tintSingleFly*(1-cc);
            xx = (1:length(vmError1(ii,:))); %length of trace
            yy = vmAvg1(ii,:); %mean line
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
    for ii = 1:size(vmAvg1, 1)
        plot([vmAvg1(ii,:)'], 'Linewidth', width_avgTrace, 'Color', colors_fiveDirections(ii,:))
    end
    if TITLES
        text(preStim+stimOn/2, max_traces_avg+htWindBar*2, name1, 'Fontname', figureFont, 'Fontsize', fontSize_titles, 'HorizontalAlignment', 'center')
    end
    nanLen = length(vmAvg1)+spacing;
end

% Plot wind stimulus bar below traces
% And plot N=X (num flies) to the right of the wind stim bar
if ~strcmp(trace1.name, [' '])
    rectangle('Position', [preStim yWindBar stimOn htWindBar], 'FaceColor', 'k', 'EdgeColor', 'none');
    if RAW == 0
        text(preStim*2+stimOn, yWindBar, ['N = ' num2str(traces1.numFlies)],'Fontname', figureFont, 'Fontsize', fontSize_titles, 'HorizontalAlignment', 'left')
    end
    text(preStim+stimOn/2, yWindBar-htWindBar*3.0, '4 s wind','Fontname', figureFont, 'Fontsize', fontSize_titles, 'HorizontalAlignment', 'center')
end


%plot patches
if ERROR
    for ii = 1:size(vmAvg, 1)
        cc = colors_fiveDirections(ii,:);
        ccLt = cc + tintSingleFly*(1-cc);
        %xx = (1:length(traces2.errorVm(ii,:)))+nanLen; %length of trace
        xx = (1:length(vmError2(ii,:)))+nanLen; %length of trace
        yy = vmAvg(ii,:); %mean line
        err = vmError2(ii,:); %error values (cross-fly, over mean)
        errorTop = yy + err/2;
        errorBottom = yy - err/2;
        if PATCH
            xData = [xx; xx; [xx(2:end) xx(end)]; [xx(2:end) xx(end)]];
            yData = [errorBottom; errorTop; [errorTop(2:end) errorTop(end)]; [errorBottom(2:end) errorBottom(end)]];
            zData = ones(4,length(yData));
            patch(xData, yData, zData, 'FaceColor', ccLt, 'EdgeColor', 'none', 'EdgeAlpha', errorTransparency, 'FaceAlpha', errorTransparency)
        else
            plot([nan(nanLen, 1); errorTop'], 'Color', ccLt)
            plot([nan(nanLen, 1); errorBottom'], 'Color', ccLt)
        end
    end
end

%plot averages
for ii = 1:size(vmAvg, 1)
    plot([nan(nanLen, 1); vmAvg(ii,:)'], 'Linewidth', width_avgTrace, 'Color', colors_fiveDirections(ii,:))
end
if TITLES
    text(preStim+nanLen+stimOn/2, max_traces_avg+htWindBar*2, name2, 'Fontname', figureFont, 'Fontsize', fontSize_titles, 'HorizontalAlignment', 'center')
end

% Plot wind stimulus bar below traces
%[preStim+nanLen yWindBar stimOn htWindBar];
rectangle('Position', [preStim+nanLen yWindBar stimOn htWindBar], 'FaceColor', 'k', 'EdgeColor', 'none');
% Plot '4 s' below bar
if ANE
    text(preStim+nanLen+stimOn/2,yWindBar-htWindBar*30, ' 4 s wind', 'Fontname', figureFont, 'Fontsize', fontSize_axis, 'HorizontalAlignment', 'center')
else
    text(preStim+nanLen+stimOn/2,yWindBar-htWindBar*3.0, ' 4 s wind', 'Fontname', figureFont, 'Fontsize', fontSize_axis, 'HorizontalAlignment', 'center')
end
% And plot N=X (num flies) to the right of the wind stim bar
text(preStim*2+stimOn+nanLen, yWindBar, ['N = ' num2str(traces2.numFlies)],'Fontname', figureFont, 'Fontsize', fontSize_titles, 'HorizontalAlignment', 'left')

% plot scale bar
if ~YAXIS_SPIKERATE || ~SPIKERATE
    bottomScale = 1.5;% yWindBar+3; %HARD-CODED!
    scaleX = preStim+nanLen+stimOn+3*samplerate/dsamp;
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
    yAxis_xLoc = nanLen-preStim*0.5; %place y-axis left of left rick on x axis by same amount as x axis is below data (convert - axes are different sizes!)
    for ii = 1:length(tickLocs_y)
        line([yAxis_xLoc yAxis_xLoc+tickLength_yAxis], [tickLocs_y(ii) tickLocs_y(ii)], 'Color', axisColor, 'Linewidth', lineWid_axis)
        text(yAxis_xLoc-tickLength_yAxis, tickLocs_y(ii), num2str(tickLocs_y(ii)), 'HorizontalAlignment', 'right', 'Color', axisColor, 'Fontname', figureFont, 'Fontsize', fontSize_axis);
    end
    line([yAxis_xLoc yAxis_xLoc], [tickLocs_y(1) tickLocs_y(end)], 'Color', axisColor, 'Linewidth', lineWid_axis)
    yAxisLabelMid = tickLocs_y(1)+(tickLocs_y(end)-tickLocs_y(1))/2;
    h = text(yAxis_xLoc-tickLength_yAxis*17,yAxisLabelMid, 'response (Hz)', 'HorizontalAlignment', 'center', 'Color', axisColor, 'Fontname', figureFont, 'Fontsize', fontSize_axis);
    set(h,'Rotation',90); 
end

