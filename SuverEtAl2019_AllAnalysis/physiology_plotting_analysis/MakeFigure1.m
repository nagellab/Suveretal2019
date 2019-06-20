%%
% Make behavior quantification plots for Suver et al. 2019 (with original data from A.M.M Matheson)
%
% There's a lot of hard-coding in here.
%%

function [fig1_upv fig2_upvBsub fig3_angv fig4_angvBsub] = MakeFigure1()
load_figure_constants;

%% glue names for figures:
conds = {'free'; 'single'; 'both'; 'no wind'};
xLocs_pairs = [1 2; 3.5 4.5; 6 7; 8.5 9.5];
condLabel_Locs = mean(xLocs_pairs');
xLocsBsub = [1 2 3 4]; %label positions (where data is plotted along x-axis)

%% P-values HARD-CODED (see separate script for generating these from raw behavior data)
%baseline vs. stim
pVals_upv_pairs = [0.0000401 0.00000066632 0.1075 0.2234];
stars_upv_pairs = {'***';'***';'ns';'ns'};

pVals_upv_free_vs_bsub = [0.0161 0.00000121];
stars_upv_bSubComp = { 'ns'; '***';};

pVals_upv_single_vs_both = [0.00048166];
stars_upv_single_vs_both = { '***';};

pVals_angv_pairs = [0.000053003 0.00000017191 0.00002618 0.0262];
stars_angv_pairs = {'***'; '***';'***';'*'};

pVals_angv_free_vs_bsub = [0.3196 0.1748];
stars_angv_bSubComp = {'ns'; 'ns'; ''};

pVals_angv_single_vs_both = [0.265];
stars_angv_single_vs_both = { 'ns';};

%% load behavior data (from Andrew)
filename = '../SuverEtAl2019_DATA/behaviorData.mat';

load(filename)
%% Upwind and angular speed data from Andrew
% angular velocity
angv_baseline = angvOFFbaseglue; %10-25s pre-odor???
angv_odorOffset = angvOFFglue; %2 s immediately after odor offset
angv_odorOffsetBsub = angvOFFgluebssub; %off-baseline

% upwind velocity
upv_baseline = upwindbaseglue; %15s pre-odor upwind velocity (10-25 s)
upv_odor = upwindglue; %10 s upwind velocity, during odor
upv_odorBsub = upwindgluebssub; %odor-baseline

upwindglueblank.dshamclean
%% Make baseline-subtracted upwind velocity odor response single-fly plot
fig1_upv = figure('color', 'w', 'Position', behaviorFigPosition1); hold on;
xMin = 0; xMax = 10;
xlim([xMin xMax]); 
jitter = (rand(size(upv_odorBsub.dshamclean'))-0.5)*jitterAmtBehavior;
%none glued ("sham")
for ii = 1:length(upv_baseline.dshamclean)
    plot(xLocs_pairs(1,:),[upv_baseline.dshamclean(ii) upv_odor.dshamclean(ii)], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', color_behaviorIndv, 'MarkerSize', behaviorIndvSize, 'Linewidth', behaviorLineSizeIndv)
end
plot(xLocs_pairs(1,:),[nanmean(upv_baseline.dshamclean) nanmean(upv_odor.dshamclean)], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', colorAntFree, 'MarkerSize', behaviorMeanSize, 'Linewidth', behaviorLineSizeMean)
%single glued
for ii = 1:length(upv_baseline.dsingleglue)
    plot(xLocs_pairs(2,:),[upv_baseline.dsingleglue(ii) upv_odor.dsingleglue(ii)], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', color_behaviorIndv, 'MarkerSize', behaviorIndvSize, 'Linewidth', behaviorLineSizeIndv)
end
plot(xLocs_pairs(2,:),[nanmean(upv_baseline.dsingleglue) nanmean(upv_odor.dsingleglue)], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', colorAntSingle, 'MarkerSize', behaviorMeanSize, 'Linewidth', behaviorLineSizeMean)
%both glued
for ii = 1:length(upv_baseline.dbothglueclean)
    plot(xLocs_pairs(3,:),[upv_baseline.dbothglueclean(ii) upv_odor.dbothglueclean(ii)], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', color_behaviorIndv, 'MarkerSize', behaviorIndvSize, 'Linewidth', behaviorLineSizeIndv)
end
plot(xLocs_pairs(3,:),[nanmean(upv_baseline.dbothglueclean) nanmean(upv_odor.dbothglueclean)], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', colorAntBothGlue, 'MarkerSize', behaviorMeanSize, 'Linewidth', behaviorLineSizeMean)

%no wind
for ii = 1:length(upwindglueblank.dshamclean)
    plot(xLocs_pairs(4,:),[upwindbaseglueblank.dshamclean(ii) upwindglueblank.dshamclean(ii)], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', color_behaviorIndv, 'MarkerSize', behaviorIndvSize, 'Linewidth', behaviorLineSizeIndv)
end
plot(xLocs_pairs(4,:),[nanmean(upwindbaseglueblank.dshamclean) nanmean(upwindglueblank.dshamclean)], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', colorAntNoWind, 'MarkerSize', behaviorMeanSize, 'Linewidth', behaviorLineSizeMean)


%% make y axis
if INDV_BEHAV
    yAxisTicks = yAxis_quant_BehaviorIndv;
else
    yAxisTicks = yAxis_quant_Behavior;
end
yAxisX = xMin;
for ii = 1:length(yAxisTicks)
   line([yAxisX yAxisX+0.2], [yAxisTicks(ii) yAxisTicks(ii)], 'Linewidth', lineWid_axis, 'Color', axisColor) 
   text(yAxisX-0.13, yAxisTicks(ii), num2str(yAxisTicks(ii)), 'HorizontalAlignment', 'right', 'Color', axisColor, 'Fontsize', fontSize_axis) 
end
line([yAxisX yAxisX], [yAxisTicks(1) yAxisTicks(end)], 'Linewidth', lineWid_axis, 'Color', axisColor) 
axis off
text(yAxisX-1, mean(yAxisTicks), 'mm/s', 'Rotation', 90, 'HorizontalAlignment', 'center','Fontsize', fontSize_axis)
%% format y-axis
if INDV_BEHAV
    minDiff = -15;
    maxDiff = 10;
    top = 16; 
else
    minDiff = -5;
    maxDiff = 10;
    top = 16; 
end
ylim([minDiff-10 top]) %make room in y for text labels (below) and statistical tests (above)

%%make x-axis ticks and text labels for paired data
if INDV_BEHAV
    textShift = +3.5;
    tickLength_xAxis = 0.4;
    xAxis_yLoc = min(yAxisTicks)-1;
else
    textShift = -1.6;
    tickLength_xAxis = 0.3;
    xAxis_yLoc = min(yAxisTicks)-1.4;
end
xMin_data = min(xLocs_pairs);
xMax_data = max(xLocs_pairs);
tickLocs_x = xLocs_pairs(:);
for ii = 1:length(xLocs_pairs)
    line([xLocs_pairs(ii,1) xLocs_pairs(ii,1)], [xAxis_yLoc xAxis_yLoc+tickLength_xAxis], 'Color', axisColor, 'Linewidth', lineWid_axis)
    line([xLocs_pairs(ii,2) xLocs_pairs(ii,2)], [xAxis_yLoc xAxis_yLoc+tickLength_xAxis], 'Color', axisColor, 'Linewidth', lineWid_axis)
    text(xLocs_pairs(ii,1), minDiff+textShift, 'base', 'Color', black, 'Rotation', rotateIpsiContraText, 'HorizontalAlignment', 'right', 'Fontsize', fontSize_axis);
    text(xLocs_pairs(ii,2), minDiff+textShift, 'odor', 'Color', black, 'Rotation', rotateIpsiContraText, 'HorizontalAlignment', 'right', 'Fontsize', fontSize_axis);
    line([xLocs_pairs(ii,1) xLocs_pairs(ii,2)], [xAxis_yLoc xAxis_yLoc], 'Color', axisColor, 'Linewidth', lineWid_axis)
end
%% make text labels for each set of data
if INDV_BEHAV
    textShift = 0.5;
else
    textShift = -5;
end
for ii = 1:length(conds)
   text(condLabel_Locs(ii), minDiff+textShift, conds{ii}, 'Color', black, 'Rotation', 0, 'HorizontalAlignment', 'center', 'Fontsize', fontSize_axis) 
end
%% Add significance values
if INDV_BEHAV
    starY = maxDiff+2;
else
    starY = maxDiff;
end
for ii = 1:length(stars_upv_pairs)
   text(condLabel_Locs(ii), starY+1, stars_upv_pairs{ii}, 'Color', black, 'HorizontalAlignment', 'center', 'Fontsize', fontSize_axis);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Make upwind velocity odor response single-fly plot
fig2_upvBsub = figure('color', 'w', 'Position', behaviorFigPosition2); hold on;
xMin = 0; xMax = 5;
xlim([xMin xMax]); 
jitter = (rand(size(upv_odorBsub.dshamclean'))-0.5)*jitterAmtBehavior;
xx = 1;
if INDV_BEHAV 
    plot(xx+jitter,[upv_odorBsub.dshamclean'], 'Marker', '.', 'Linestyle', 'none', 'Color', colorAntFree, 'MarkerSize', behaviorIndvSize); 
else
    line([xx xx], [mean([upv_odorBsub.dshamclean'])-nanstd([upv_odorBsub.dshamclean']) mean([upv_odorBsub.dshamclean'])+nanstd([upv_odorBsub.dshamclean'])], ...
        'Color', colorAntFree, 'Linewidth', ipsiContraMeanErrorLineSize);
end
plot(xx,mean([upv_odorBsub.dshamclean']), 'Marker', '.', 'Color', colorAntFree, 'MarkerSize', behaviorMeanSize)

jitter = (rand(size(upv_odorBsub.dsingleglue'))-0.5)*jitterAmtBehavior;
xx = 2;
if INDV_BEHAV 
    plot(xx+jitter,[upv_odorBsub.dsingleglue'], 'Marker', '.', 'Linestyle', 'none', 'Color', colorAntSingle, 'MarkerSize', behaviorIndvSize); 
else
    line([xx xx], [mean([upv_odorBsub.dsingleglue'])-nanstd([upv_odorBsub.dsingleglue']) mean([upv_odorBsub.dsingleglue'])+nanstd([upv_odorBsub.dsingleglue'])], ...
        'Color', colorAntSingle, 'Linewidth', ipsiContraMeanErrorLineSize);
end
plot(xx,mean([upv_odorBsub.dsingleglue']), 'Marker', '.', 'Color', colorAntSingle, 'MarkerSize', behaviorMeanSize)

jitter = (rand(size(upv_odorBsub.dbothglueclean'))-0.5)*jitterAmtBehavior;
xx = 3;
if INDV_BEHAV 
    plot(xx+jitter,[upv_odorBsub.dbothglueclean'], 'Marker', '.', 'Linestyle', 'none', 'Color', colorAntBothGlue, 'MarkerSize', behaviorIndvSize); 
else
    line([xx xx], [mean([upv_odorBsub.dbothglueclean'])-nanstd([upv_odorBsub.dbothglueclean']) mean([upv_odorBsub.dbothglueclean'])+nanstd([upv_odorBsub.dbothglueclean'])], ...
        'Color', colorAntBothGlue, 'Linewidth', ipsiContraMeanErrorLineSize);
end
plot(xx,mean([upv_odorBsub.dbothglueclean']), 'Marker', '.', 'Color', colorAntBothGlue, 'MarkerSize', behaviorMeanSize)


jitter = (rand(size(upwindglueblank.dshamclean'-upwindbaseglueblank.dshamclean'))-0.5)*jitterAmtBehavior;
xx = 4;
upwindglueblank.dshamclean'-upwindbaseglueblank.dshamclean'
if INDV_BEHAV 
    plot(xx+jitter,[upwindglueblank.dshamclean'-upwindbaseglueblank.dshamclean'], 'Marker', '.', 'Linestyle', 'none', 'Color', colorAntBothGlue, 'MarkerSize', behaviorIndvSize); 
else
    line([xx xx], [mean([upwindglueblank.dshamclean'-upwindbaseglueblank.dshamclean'])-nanstd([upwindglueblank.dshamclean'-upwindbaseglueblank.dshamclean']) mean([upwindglueblank.dshamclean'-upwindbaseglueblank.dshamclean'])+nanstd([upwindglueblank.dshamclean'-upwindbaseglueblank.dshamclean'])], ...
        'Color', colorAntBothGlue, 'Linewidth', ipsiContraMeanErrorLineSize);
end
plot(xx,mean([upwindglueblank.dshamclean'-upwindbaseglueblank.dshamclean']), 'Marker', '.', 'Color', colorAntNoWind, 'MarkerSize', behaviorMeanSize)



%% make y axis
if INDV_BEHAV
    yAxisTicks = yAxis_quant_BehaviorIndv;
else
    yAxisTicks = yAxis_quant_Behavior;
end
yAxisX = xMin;
for ii = 1:length(yAxisTicks)
   line([yAxisX yAxisX+0.2], [yAxisTicks(ii) yAxisTicks(ii)], 'Linewidth', lineWid_axis, 'Color', axisColor) 
   text(yAxisX-0.13, yAxisTicks(ii), num2str(yAxisTicks(ii)), 'HorizontalAlignment', 'right', 'Color', axisColor, 'Fontsize', fontSize_axis) 
end
line([yAxisX yAxisX], [yAxisTicks(1) yAxisTicks(end)], 'Linewidth', lineWid_axis, 'Color', axisColor) 
axis off
text(yAxisX-0.8, mean(yAxisTicks), 'mm/s', 'Rotation', 90, 'HorizontalAlignment', 'center','Fontsize', fontSize_axis)
%% make text labels for each set of data
if INDV_BEHAV
    minDiff = -15;
    maxDiff = 10;
    top = 16; 
else
    minDiff = -5;
    maxDiff = 10;
    top = 16; 
end

ylim([minDiff-10 top]) %make room in y for text labels (below) and statistical tests (above)
textShift = -0.5;
for ii = 1:length(conds)
   text(xLocsBsub(ii), minDiff+textShift, conds{ii}, 'Color', black, 'Rotation', rotateIpsiContraText, 'HorizontalAlignment', 'right', 'Fontsize', fontSize_axis) 
end
%% Add significance values
if INDV_BEHAV
    starY = maxDiff+6;
    starShift = 1;
else
    starY = maxDiff+2;
    starShift = 0.3;
end
for ii = 1:length(stars_upv_bSubComp)
   text((xLocsBsub(ii)+xLocsBsub(ii+1))/2, starY+starShift*0.2, stars_upv_bSubComp{ii}, 'Color', black, 'HorizontalAlignment', 'center', 'Fontsize', fontSize_axis);
   line([xLocsBsub(1) xLocsBsub(ii+1)], [starY-ii*starShift starY-ii*starShift], 'Color', axisColor, 'Linewidth', lineWid_axis)
end
% draw line at zero
line([xMin+0.5 xMax-0.5], [0 0], 'Color', lineColor_zeroDashed, 'Linestyle', ':')


%% Make baseline-subtracted angular velocity offset response single-fly plot
fig3_angv = figure('color', 'w', 'Position', behaviorFigPosition3); hold on;
xMin = 0; xMax = 10;
xlim([xMin xMax]); 
%none glued ("sham")
for ii = 1:length(angv_baseline.dshamclean)
    plot(xLocs_pairs(1,:),[angv_baseline.dshamclean(ii) angv_odorOffset.dshamclean(ii)], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', color_behaviorIndv, 'MarkerSize', behaviorIndvSize, 'Linewidth', behaviorLineSizeIndv)
end
plot(xLocs_pairs(1,:),[nanmean(angv_baseline.dshamclean) nanmean(angv_odorOffset.dshamclean)], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', colorAntFree, 'MarkerSize', behaviorMeanSize, 'Linewidth', behaviorLineSizeMean)
%single glued
for ii = 1:length(angv_baseline.dsingleglue)
    plot(xLocs_pairs(2,:),[angv_baseline.dsingleglue(ii) angv_odorOffset.dsingleglue(ii)], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', color_behaviorIndv, 'MarkerSize', behaviorIndvSize, 'Linewidth', behaviorLineSizeIndv)
end
plot(xLocs_pairs(2,:),[nanmean(angv_baseline.dsingleglue) nanmean(angv_odorOffset.dsingleglue)], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', colorAntSingle, 'MarkerSize', behaviorMeanSize, 'Linewidth', behaviorLineSizeMean)
%both glued
for ii = 1:length(angv_baseline.dbothglueclean)
    plot(xLocs_pairs(3,:),[angv_baseline.dbothglueclean(ii) angv_odorOffset.dbothglueclean(ii)], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', color_behaviorIndv, 'MarkerSize', behaviorIndvSize, 'Linewidth', behaviorLineSizeIndv)
end
plot(xLocs_pairs(3,:),[nanmean(angv_baseline.dbothglueclean) nanmean(angv_odorOffset.dbothglueclean)], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', colorAntBothGlue, 'MarkerSize', behaviorMeanSize, 'Linewidth', behaviorLineSizeMean)

%no wind
for ii = 1:length(angvOFFglueblank.dshamclean)
    plot(xLocs_pairs(4,:),[angvOFFbaseglueblank.dshamclean(ii) angvOFFglueblank.dshamclean(ii)], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', color_behaviorIndv, 'MarkerSize', behaviorIndvSize, 'Linewidth', behaviorLineSizeIndv)
end
plot(xLocs_pairs(4,:),[nanmean(angvOFFbaseglueblank.dshamclean) nanmean(angvOFFglueblank.dshamclean)], 'Marker', behaviorMarker, 'Linestyle', '-', 'Color', colorAntNoWind, 'MarkerSize', behaviorMeanSize, 'Linewidth', behaviorLineSizeMean)



%% make y axis
yAxisTicks = yAxis_quant_BehaviorAngvBase;
yAxisX = xMin;
for ii = 1:length(yAxisTicks)
   line([yAxisX yAxisX+0.2], [yAxisTicks(ii) yAxisTicks(ii)], 'Linewidth', lineWid_axis, 'Color', axisColor) 
   text(yAxisX-0.13, yAxisTicks(ii), num2str(yAxisTicks(ii)), 'HorizontalAlignment', 'right', 'Color', axisColor, 'Fontsize', fontSize_axis) 
end
line([yAxisX yAxisX], [yAxisTicks(1) yAxisTicks(end)], 'Linewidth', lineWid_axis, 'Color', axisColor) 
axis off
text(yAxisX-2.2, mean(yAxisTicks), 'deg/s', 'Rotation', 90, 'HorizontalAlignment', 'center','Fontsize', fontSize_axis)
%% format y-axis
minDiff = 0;
maxDiff = 200;
top = 350;
ylim([minDiff-10 top]) %make room in y for text labels (below) and statistical tests (above)

%%make x-axis ticks and text labels for paired data
textShift = -8;
tickLength_xAxis = 2;
xAxis_yLoc = min(yAxisTicks)-5;
%end
xMin_data = min(xLocs_pairs);
xMax_data = max(xLocs_pairs);
tickLocs_x = xLocs_pairs(:);
for ii = 1:length(xLocs_pairs)
    line([xLocs_pairs(ii,1) xLocs_pairs(ii,1)], [xAxis_yLoc xAxis_yLoc+tickLength_xAxis], 'Color', axisColor, 'Linewidth', lineWid_axis)
    line([xLocs_pairs(ii,2) xLocs_pairs(ii,2)], [xAxis_yLoc xAxis_yLoc+tickLength_xAxis], 'Color', axisColor, 'Linewidth', lineWid_axis)
    text(xLocs_pairs(ii,1), minDiff+textShift, 'base', 'Color', black, 'Rotation', rotateIpsiContraText, 'HorizontalAlignment', 'right', 'Fontsize', fontSize_axis);
    text(xLocs_pairs(ii,2), minDiff+textShift, 'offset', 'Color', black, 'Rotation', rotateIpsiContraText, 'HorizontalAlignment', 'right', 'Fontsize', fontSize_axis);
    line([xLocs_pairs(ii,1) xLocs_pairs(ii,2)], [xAxis_yLoc xAxis_yLoc], 'Color', axisColor, 'Linewidth', lineWid_axis)
end
%% make text labels for each set of data
textShift = -45;
for ii = 1:length(conds)
    text(condLabel_Locs(ii), minDiff+textShift, conds{ii}, 'Color', black, 'Rotation', 0, 'HorizontalAlignment', 'center', 'Fontsize', fontSize_axis)
end
%% Add significance values
starY = maxDiff;
for ii = 1:length(stars_upv_pairs)
   text(condLabel_Locs(ii), starY+1, stars_angv_pairs{ii}, 'Color', black, 'HorizontalAlignment', 'center', 'Fontsize', fontSize_axis);
end



%% Make angular velocity offset response plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig4_angvBsub = figure('color', 'w', 'Position', behaviorFigPosition4); hold on;
xMin = 0; xMax = 5;
xlim([xMin xMax]); 
jitter = (rand(size(angv_odorOffsetBsub.dshamclean'))-0.5)*jitterAmtBehavior;
xx = 1;
if INDV_BEHAV 
    plot(xx+jitter,[angv_odorOffsetBsub.dshamclean'], 'Marker', '.', 'Linestyle', 'none', 'Color', colorAntFree, 'MarkerSize', behaviorIndvSize); 
else
    line([xx xx], [mean([angv_odorOffsetBsub.dshamclean'])-nanstd([angv_odorOffsetBsub.dshamclean']) mean([angv_odorOffsetBsub.dshamclean'])+nanstd([angv_odorOffsetBsub.dshamclean'])], ...
        'Color', colorAntFree, 'Linewidth', ipsiContraMeanErrorLineSize);
end
plot(xx,mean([angv_odorOffsetBsub.dshamclean']), 'Marker', '.', 'Color', colorAntFree, 'MarkerSize', behaviorMeanSize)

jitter = (rand(size(angv_odorOffsetBsub.dsingleglue'))-0.5)*jitterAmtBehavior;
xx = 2;
if INDV_BEHAV 
    plot(xx+jitter,[angv_odorOffsetBsub.dsingleglue'], 'Marker', '.', 'Linestyle', 'none', 'Color', colorAntSingle, 'MarkerSize', behaviorIndvSize); 
else
    line([xx xx], [mean([angv_odorOffsetBsub.dsingleglue'])-nanstd([angv_odorOffsetBsub.dsingleglue']) mean([angv_odorOffsetBsub.dsingleglue'])+nanstd([angv_odorOffsetBsub.dsingleglue'])], ...
        'Color', colorAntSingle, 'Linewidth', ipsiContraMeanErrorLineSize);
end
plot(xx,mean([angv_odorOffsetBsub.dsingleglue']), 'Marker', '.', 'Color', colorAntSingle, 'MarkerSize', behaviorMeanSize)

jitter = (rand(size(angv_odorOffsetBsub.dbothglueclean'))-0.5)*jitterAmtBehavior;
xx = 3;
if INDV_BEHAV 
    plot(xx+jitter,[angv_odorOffsetBsub.dbothglueclean'], 'Marker', '.', 'Linestyle', 'none', 'Color', colorAntBothGlue, 'MarkerSize', behaviorIndvSize); 
else
    line([xx xx], [mean([angv_odorOffsetBsub.dbothglueclean'])-nanstd([angv_odorOffsetBsub.dbothglueclean']) mean([angv_odorOffsetBsub.dbothglueclean'])+nanstd([angv_odorOffsetBsub.dbothglueclean'])], ...
        'Color', colorAntBothGlue, 'Linewidth', ipsiContraMeanErrorLineSize);
end
plot(xx,mean([angv_odorOffsetBsub.dbothglueclean']), 'Marker', '.', 'Color', colorAntBothGlue, 'MarkerSize', behaviorMeanSize)


jitter = (rand(size(angvOFFglueblank.dshamclean'-angvOFFbaseglueblank.dshamclean'))-0.5)*jitterAmtBehavior;
xx = 4;
if INDV_BEHAV 
    plot(xx+jitter,[angvOFFglueblank.dshamclean'-angvOFFbaseglueblank.dshamclean'], 'Marker', '.', 'Linestyle', 'none', 'Color', colorAntNoWind, 'MarkerSize', behaviorIndvSize); 
else
    line([xx xx], [mean([angvOFFglueblank.dshamclean'-angvOFFbaseglueblank.dshamclean'])-nanstd([angvOFFglueblank.dshamclean'-angvOFFbaseglueblank.dshamclean']) mean([angvOFFglueblank.dshamclean'-angvOFFbaseglueblank.dshamclean'])+nanstd([angvOFFglueblank.dshamclean'-angvOFFbaseglueblank.dshamclean'])], ...
        'Color', colorAntBothGlue, 'Linewidth', ipsiContraMeanErrorLineSize);
end
plot(xx,mean([angvOFFglueblank.dshamclean'-angvOFFbaseglueblank.dshamclean']), 'Marker', '.', 'Color', colorAntNoWind, 'MarkerSize', behaviorMeanSize)

%% make y axis

if INDV_BEHAV
    yAxisTicks = yAxis_quant_Behavior2Indv;
else
    yAxisTicks = yAxis_quant_BehaviorAngvPairs;
end
yAxisX = xMin;
for ii = 1:length(yAxisTicks)
   line([yAxisX yAxisX+0.2], [yAxisTicks(ii) yAxisTicks(ii)], 'Linewidth', lineWid_axis, 'Color', axisColor) 
   text(yAxisX-0.13, yAxisTicks(ii), num2str(yAxisTicks(ii)), 'HorizontalAlignment', 'right', 'Color', axisColor, 'Fontsize', fontSize_axis) 
end
line([yAxisX yAxisX], [yAxisTicks(1) yAxisTicks(end)], 'Linewidth', lineWid_axis, 'Color', axisColor) 
axis off
text(yAxisX-1.5, mean(yAxisTicks), 'deg/s', 'Rotation', 90, 'HorizontalAlignment', 'center','Fontsize', fontSize_axis)

%% make text labels for each set of data
if INDV_BEHAV
    minDiff = -20;
    maxDiff = 120;
    top = 130;
else
    minDiff = 0;
    maxDiff = 150;
    top = 160;
end
ylim([minDiff-10 top]) %make room in y for text labels (below) and statistical tests (above)
textShift = -3;
for ii = 1:length(conds)
   text(xLocsBsub(ii), minDiff+textShift, conds{ii}, 'Color', black, 'Rotation', rotateIpsiContraText, 'HorizontalAlignment', 'right', 'Fontsize', fontSize_axis) 
end

%% Add significance values
if INDV_BEHAV
    starY = maxDiff+6;
    starShift = 2;
else
    starY = yAxisTicks(end)+10;
    starShift = 2.5;
end
for ii = 1:length(stars_upv_bSubComp)
   text((xLocsBsub(ii)+xLocsBsub(ii+1))/2, starY+starShift, stars_angv_bSubComp{ii}, 'Color', black, 'HorizontalAlignment', 'center', 'Fontsize', fontSize_axis);
   line([xLocsBsub(1) xLocsBsub(ii+1)], [starY-ii*starShift starY-ii*starShift], 'Color', axisColor, 'Linewidth', lineWid_axis)
end

if TITLES == 1
   figure(fig1_upv); 
   title('Upwind velocity', 'Color', black, 'HorizontalAlignment', 'center', 'Fontsize', fontSize_axis);
   
   figure(fig2_upvBsub);
   title({'Baseline-subtracted', 'upwind velocity'}, 'Color', black, 'HorizontalAlignment', 'center', 'Fontsize', fontSize_axis);
   
   figure(fig3_angv);
   title('Angular velocity', 'Color', black, 'HorizontalAlignment', 'center', 'Fontsize', fontSize_axis);
   
   figure(fig4_angvBsub);
   title({'Baseline-subtracted', 'angular velocity'}, 'Color', black, 'HorizontalAlignment', 'center', 'Fontsize', fontSize_axis);
end

