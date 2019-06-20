%%
% MakeAntennaTraceFigure - designed to plot a raw and average antenna
% tracking set similar to MakeTracePairFigure (membrane potential time
% traces)
%
% Suver et al. 2019
%
%%

function figHandle = MakeAntennaTraceFigure(rawtraces, avgtraces, ERROR, TITLES, RIGHT, position)
load_figure_constants;
figHandle = figure('color', 'w', 'Position', position); hold on
name = avgtraces.name;
raw = rawtraces.trace;
rawName = rawtraces.name;
antTraces = avgtraces.antTraces;
samplerate = antTraces.samplerate;
spacing = antTraces.preStim*samplerate;
scaleSize = 5; %number of degrees to indicate with scale bar
axis off
if RIGHT
    avg = antTraces.avgRightAngles;
    error = antTraces.errRightAngles;
else %left!
    avg = antTraces.avgLeftAngles;
    error = antTraces.errLeftAngles;
end
max_traces = nanmax([nanmax(avg+error./2) nanmax(raw)]);
min_traces = nanmin([nanmin(avg-error./2) nanmin(raw)]);

plot([raw], 'Color', color_rawTrace, 'Linewidth', width_rawTrace)
if TITLES
    text(antTraces.preStim+antTraces.stim/2, max_traces+htWindBar*2, rawName, 'Fontname', figureFont, 'Fontsize', fontSize_titles, 'HorizontalAlignment', 'center')
end
% Plot wind stimulus bar below traces
yWindBar = min_traces-htWindBar*3;
xx = antTraces.preStim*samplerate;
rectangle('Position', [xx yWindBar antTraces.stim*samplerate htWindBar], 'FaceColor', 'k', 'EdgeColor', 'none');
text(xx+antTraces.stim*samplerate/2, yWindBar-htWindBar*4, ['4 s wind'],'Fontname', figureFont, 'Fontsize', fontSize_titles, 'HorizontalAlignment', 'center')

nanLen = length(raw)+spacing;
if ERROR
    for ii = 1:size(avg, 1)
        cc = colors_fiveDirections(ii,:);
        ccLt = cc + tintSingleFly*(1-cc);
        xx = (1:length(error(ii,:))); %length of trace
        yy = avg(ii,:); %mean line
        err = error(ii,:); %error values (cross-fly, over mean)
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
for ii = 1:size(avg, 1)
    plot([nan(nanLen, 1); avg(ii,:)'], 'Linewidth', width_avgTrace, 'Color', colors_fiveDirections(ii,:))
end

if TITLES
    text(antTraces.preStim*samplerate+nanLen+antTraces.stim/2*samplerate, max_traces+htWindBar*2, name, 'Fontname', figureFont, 'Fontsize', fontSize_titles, 'HorizontalAlignment', 'center')
end

% Plot wind stimulus bar below traces
% And plot N=X (num trials) to the right of the wind stim bar
yWindBar = min_traces-htWindBar*3;
xx = antTraces.preStim*samplerate+nanLen;
rectangle('Position', [xx yWindBar antTraces.stim*samplerate htWindBar], 'FaceColor', 'k', 'EdgeColor', 'none');
text(xx+antTraces.stim*samplerate/2, yWindBar-htWindBar*4, ['4 s wind'],'Fontname', figureFont, 'Fontsize', fontSize_titles, 'HorizontalAlignment', 'center')
numTraces = min(min([antTraces.numRight antTraces.numTraces]))
text(antTraces.preStim*2*samplerate+nanLen+antTraces.stim*samplerate, yWindBar, ['N=' num2str(numTraces) ' trials'],'Fontname', figureFont, 'Fontsize', fontSize_titles, 'HorizontalAlignment', 'left')

%% Plot scale bar 
bottomScale = -7.5;%%HARD-CODED!
scaleX = antTraces.preStim+nanLen+antTraces.stim+8*antTraces.samplerate;
line([scaleX scaleX], [bottomScale bottomScale+scaleSize], 'Color', 'k', 'Linewidth', width_scale)
scaleTextX = scaleX+0.1*antTraces.samplerate;
scaleTextY = bottomScale+scaleSize/2;
text(scaleTextX, scaleTextY, [num2str(scaleSize) ' deg'], 'Fontname', figureFont, 'Fontsize', fontSize_axis, 'HorizontalAlignment', 'left')

