%%
% Plot wind and odor time trace plots
%  Will output some statistics.
%
% Suver et al. 2019
%%

function [figHandle] =  MakeWindOdorAvgFigure(tt, position, yAxisTicks)
load_figure_constants;
figHandle = figure('color', 'w', 'Position', position); hold on
xMin = 0; xMax = 3;
xlim([xMin xMax]); 

traceName = tt.name;
traces = tt.traces;

%% Plot single-fly averages
for ii = 1:length(traces.indvTonicWindAvg_meanCrossFly)
    tw = traces.indvTonicWindAvg_meanCrossFly{ii};
    to = traces.indvOdorAvg_meanCrossFly{ii};
    for jj = 1:5
        cc = colors_fiveDirections(jj,:);
        ccLt = cc + tintSingleFly*(1-cc);
        plot([1 2], [tw(jj) to(jj)], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', ccLt, 'MarkerSize', behaviorIndvSize, 'Linewidth', behaviorLineSizeIndv)
    end
end
%% Plot cross-fly averages
for ii = 1:length(traces.avgWR)
    cc = colors_fiveDirections(ii,:);
    plot([1 2], [traces.avgWR(ii) traces.avgOR(ii)], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', cc, 'MarkerSize', behaviorMeanSize, 'Linewidth', behaviorLineSizeMean)
end
%gather cross-direction data
allMeansW = [];
allMeansO = [];
for ii = 1:length(traces.indvTonicWindAvg_meanCrossFly)
    allMeansW = [allMeansW traces.indvTonicWindAvg_meanCrossFly{ii}];
    allMeansO = [allMeansO traces.indvOdorAvg_meanCrossFly{ii}];
end
plot([1 2], [mean(allMeansW(:)) mean(allMeansO(:))], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', 'k', 'MarkerSize', behaviorMeanSize, 'Linewidth', 2)

%% make y axis
yAxisX = xMin+0.75;
for ii = 1:length(yAxisTicks)
   line([yAxisX yAxisX+0.07], [yAxisTicks(ii) yAxisTicks(ii)], 'Linewidth', lineWid_axis, 'Color', axisColor) 
   text(yAxisX-0.13, yAxisTicks(ii), num2str(yAxisTicks(ii)), 'HorizontalAlignment', 'right', 'Color', axisColor, 'Fontsize', fontSize_axis) 
end
line([yAxisX yAxisX], [yAxisTicks(1) yAxisTicks(end)], 'Linewidth', lineWid_axis, 'Color', axisColor) 
axis off
text(yAxisX-0.5, mean(yAxisTicks), 'response (mV)', 'Rotation', 90, 'HorizontalAlignment', 'center','Fontsize', fontSize_axis)
%% format y-axis
minDiff = min(yAxisTicks);
maxDiff = max(yAxisTicks);
top = maxDiff+2;
ylim([minDiff-10 top]) %make room in y for text labels (below) and statistical tests (above)

%% make x-axis ticks and text labels for paired data
textShift = -2.5;
tickLength_xAxis = 0.5;
xAxis_yLoc = min(yAxisTicks)-2;
xMin_data = 1;
xMax_data = 2;
tickLocs_x = [1 2];
line([xMin_data xMin_data], [xAxis_yLoc xAxis_yLoc+tickLength_xAxis], 'Color', axisColor, 'Linewidth', lineWid_axis)
line([xMax_data xMax_data], [xAxis_yLoc xAxis_yLoc+tickLength_xAxis], 'Color', axisColor, 'Linewidth', lineWid_axis)
text(xMin_data, minDiff+textShift, 'wind', 'Color', black, 'Rotation', rotateIpsiContraText, 'HorizontalAlignment', 'right', 'Fontsize', fontSize_axis);
text(xMax_data, minDiff+textShift, 'odor', 'Color', black, 'Rotation', rotateIpsiContraText, 'HorizontalAlignment', 'right', 'Fontsize', fontSize_axis);
line([xMin_data xMax_data], [xAxis_yLoc xAxis_yLoc], 'Color', axisColor, 'Linewidth', lineWid_axis)

%% Plot significance value
% two-sample t-test for equal means between samples
% *** = p<0.001, ** p<0.01, * p<0.05
for ii = 1:5
    [h,pVal,ci,stats] = ttest2(allMeansW(ii,:), allMeansO(ii,:));
    pVals_crossFlyPerDirection(ii) = pVal;
end
traceName
pVals_crossFlyPerDirection
pVals = pVals_crossFlyPerDirection;

[h,pVal,ci,stats] = ttest2(allMeansW(:), allMeansO(:));
display([traceName(1:4) ' all wind vs. odor means pVal = ' num2str(pVal)])

% inefficient yet accurate depiction of significance values...
for ii = 1:length(pVals)
   if pVals(ii) <= 0.001
       stars{ii} = '***'; 
   elseif pVals(ii) <= 0.01
       stars{ii} = '**'; 
   elseif pVals(ii) <= 0.05
       stars{ii} = '*'; 
   else
       stars{ii} = 'ns'; %no stars for you!
   end
end
starY = maxDiff;
text(1.5, starY+1, stars{ii}, 'Color', black, 'HorizontalAlignment', 'center', 'Fontsize', fontSize_axis);
lineY = starY-0.5;
line([1 2], [lineY lineY], 'Color', 'k')

%%
if TITLES
   text(1.5, top+1, traceName, 'Color', 'k', 'Fontname', figureFont, 'Fontsize', fontSize_axis, 'HorizontalAlignment', 'center') 
end

