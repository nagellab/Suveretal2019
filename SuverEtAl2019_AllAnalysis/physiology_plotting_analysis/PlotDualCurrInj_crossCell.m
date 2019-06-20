%%
% Plot cross-cell results for the three-cell (WPN) dual patch experiments
% if second arg (TEST) is 1, will plot traces
%
% Suver et al. 2019
%%

function fig = PlotDualCurrInj_crossCell(dualCellData)
COLORS = 0; %for testing - if 1, will plot single fly means in different colors
load_figure_constants;

meanI1_inj_1 = dualCellData.meanI1_inj{1};
meanI1_inj_2 = dualCellData.meanI1_inj{2};
meanI1_inj_3 = dualCellData.meanI1_inj{3};
meanVm1_inj_1 = dualCellData.meanVm1_inj{1};
meanVm1_inj_2 = dualCellData.meanVm1_inj{2};
meanVm1_inj_3 = dualCellData.meanVm1_inj{3};
meanVm2_resp_1 = dualCellData.meanVm2_resp{1};
meanVm2_resp_2 = dualCellData.meanVm2_resp{2};
meanVm2_resp_3 = dualCellData.meanVm2_resp{3};

meanI2_inj_1 = dualCellData.meanI2_inj{1};
meanI2_inj_2 = dualCellData.meanI2_inj{2};
meanI2_inj_3 = dualCellData.meanI2_inj{3};
meanVm1_resp_1 = dualCellData.meanVm1_resp{1};
meanVm1_resp_2 = dualCellData.meanVm1_resp{2};
meanVm1_resp_3 = dualCellData.meanVm1_resp{3};
meanVm2_1 = dualCellData.meanVm2_inj{1};
meanVm2_2 = dualCellData.meanVm2_inj{2};
meanVm2_3 = dualCellData.meanVm2_inj{3};

%% Plot steady state results (difference from baseline)
STEADY_INDS = 2*samplerate:4*samplerate;
BASE_INDS = 1:2*samplerate;
fig = figure('Color', 'w', 'Position', positionDualCurrInj_quant); hold on;

currInj1 = dualCellData.cmdCurr;
meanResp1(1,:) = mean(meanVm2_resp_1(:,STEADY_INDS),2)-mean(meanVm2_resp_1(:,BASE_INDS),2);
meanResp1(2,:) = mean(meanVm2_resp_2(:,STEADY_INDS),2)-mean(meanVm2_resp_2(:,BASE_INDS),2);
meanResp1(3,:) = mean(meanVm2_resp_3(:,STEADY_INDS),2)-mean(meanVm2_resp_3(:,BASE_INDS),2);
if COLORS
    for ii = 1:size(meanResp1,1)
        plot(currInj1', meanResp1(ii,:), 'Marker', '.', 'Linestyle', '--', 'Color', colors_fiveDirections(ii,:), 'Markersize', ipsiContraIndvSize)
    end
else
    plot(repmat(currInj1',3,1), meanResp1, 'Marker', '.', 'Linestyle', 'none', 'Color', color_ipsiContra_indv, 'Markersize', ipsiContraIndvSize)
end

xx = [(currInj1-jitterAmt*10) (currInj1+jitterAmt*10)];
yy = mean(meanResp1,1)';
for ii = 1:length(currInj1)
    line(xx(ii,:),yy(ii).*ones(size(xx)), 'Color', color_ipsiContra_mean, 'Linewidth', ipsiContraMeanLineSize)
end
currInj2 = dualCellData.cmdCurr+max(dualCellData.cmdCurr)+35;
meanResp2(1,:) = mean(meanVm1_resp_1(:,STEADY_INDS),2)-mean(meanVm1_resp_1(:,BASE_INDS),2);
meanResp2(2,:) = mean(meanVm1_resp_2(:,STEADY_INDS),2)-mean(meanVm1_resp_2(:,BASE_INDS),2);
meanResp2(3,:) = mean(meanVm1_resp_3(:,STEADY_INDS),2)-mean(meanVm1_resp_3(:,BASE_INDS),2);

if COLORS
    for ii = 1:size(meanResp2,1)
        plot(currInj2', meanResp2(ii,:), 'Marker', '.', 'Linestyle', '--', 'Color', colors_fiveDirections(ii,:), 'Markersize', ipsiContraIndvSize)
    end
else
    plot(repmat(currInj2',3,1), meanResp2, 'Marker', '.', 'Linestyle', 'none', 'Color', color_ipsiContra_indv, 'Markersize', ipsiContraIndvSize)
end

xx = [(currInj2-jitterAmt*10) (currInj2+jitterAmt*10)];
yy = mean(meanResp2,1)';
for ii = 1:length(currInj2)
    line(xx(ii,:),yy(ii).*ones(size(xx)), 'Color', color_ipsiContra_mean, 'Linewidth', ipsiContraMeanLineSize)
end
%% Plot axes
xMin_data1 = currInj1(1); xMax_data1 = currInj1(end);
xMin_data2 = currInj2(1); xMax_data2 = currInj2(end);
xMin = xMin_data1-10; xMax = xMax_data1+10; 
yMin = -5; yMax = 5;
xlim([-20 80])
ylim([-6 6])
oneUnitConverted = (xMax-xMin)/(yMax-yMin);
tickLength_xAxis = 0.2;
tickLength_yAxis = tickLength_xAxis*oneUnitConverted*1.5; %HARD-CODED

%%
minTick_Y = -3; %yMin;
maxTick_Y = 3; %yMax;
spacing_yTicks = 3;

%% Plot x-axis #1
%x-axis
tickLocs_x = currInj1;
xAxis_yLoc = minTick_Y-0.2;
for ii = 1:length(tickLocs_x)
    line([tickLocs_x(ii) tickLocs_x(ii)], [xAxis_yLoc xAxis_yLoc+tickLength_xAxis], 'Color', axisColor, 'Linewidth', lineWid_axis)
    text(tickLocs_x(ii), xAxis_yLoc-tickLength_xAxis*2.5, num2str(tickLocs_x(ii,:)), 'HorizontalAlignment', 'center', 'Color', axisColor, 'Fontname', figureFont, 'Fontsize', fontSize_axis);
end
line([xMin_data1 xMax_data1], [xAxis_yLoc xAxis_yLoc], 'Color', axisColor, 'Linewidth', lineWid_axis)
xAxisLabelMid = tickLocs_x(1)+(tickLocs_x(end)-tickLocs_x(1))/2;

%% Plot x-axis #2
%x-axis
tickLocs_x = currInj2;
xAxis_yLoc = minTick_Y-0.2;
for ii = 1:length(tickLocs_x)
    line([tickLocs_x(ii) tickLocs_x(ii)], [xAxis_yLoc xAxis_yLoc+tickLength_xAxis], 'Color', axisColor, 'Linewidth', lineWid_axis)
    text(tickLocs_x(ii), xAxis_yLoc-tickLength_xAxis*2.5, num2str(currInj1(ii,:)), 'HorizontalAlignment', 'center', 'Color', axisColor, 'Fontname', figureFont, 'Fontsize', fontSize_axis);
end
line([xMin_data2 xMax_data2], [xAxis_yLoc xAxis_yLoc], 'Color', axisColor, 'Linewidth', lineWid_axis)
xAxisLabelMid = tickLocs_x(1)+(tickLocs_x(end)-tickLocs_x(1))/2;
text(xMin_data1+(xMax_data2-xMin_data1)/2, xAxis_yLoc-tickLength_xAxis*6, 'injected current (pA)', 'HorizontalAlignment', 'center', 'Color', axisColor, 'Fontname', figureFont, 'Fontsize', fontSize_axis);

%% y-axis #1
tickLocs_y = minTick_Y:spacing_yTicks:maxTick_Y;
yAxis_xLoc = xMin_data1-5; %HARD-CODED
for ii = 1:length(tickLocs_y)
    line([yAxis_xLoc yAxis_xLoc+tickLength_yAxis], [tickLocs_y(ii) tickLocs_y(ii)], 'Color', axisColor, 'Linewidth', lineWid_axis)
    text(yAxis_xLoc-tickLength_yAxis, tickLocs_y(ii), num2str(tickLocs_y(ii)), 'HorizontalAlignment', 'right', 'Color', axisColor, 'Fontname', figureFont, 'Fontsize', fontSize_axis);
end
line([yAxis_xLoc yAxis_xLoc], [minTick_Y maxTick_Y], 'Color', axisColor, 'Linewidth', lineWid_axis)
yAxisLabelMid = tickLocs_y(1)+(tickLocs_y(end)-tickLocs_y(1))/2;
text(yAxis_xLoc-tickLength_yAxis*8, yAxisLabelMid, 'response (mV)', 'HorizontalAlignment', 'center', 'Color', axisColor, 'Fontname', figureFont, 'Fontsize', fontSize_axis, 'Rotation', 90);

%% Plot dotted lines at zero
line([xMin_data1-2 xMax_data1+2], [0 0], 'Color', lineColor_zeroDashed, 'Linewidth', 0.5, 'Linestyle', ':')
line([xMin_data2-2 xMax_data2+2], [0 0], 'Color', lineColor_zeroDashed, 'Linewidth', 0.5, 'Linestyle', ':')

text(xMin_data1+(xMax_data1-xMin_data1)/2, yMax+spacing_yTicks*0.25, 'cell1 --> cell2', 'HorizontalAlignment', 'center', 'Color', axisColor, 'Fontname', figureFont, 'Fontsize', fontSize_axis);
text(xMin_data2+(xMax_data2-xMin_data2)/2, yMax+spacing_yTicks*0.25, 'cell2 --> cell1', 'HorizontalAlignment', 'center', 'Color', axisColor, 'Fontname', figureFont, 'Fontsize', fontSize_axis);
axis off

%% Run statistical tests on desired pairs of data

% one-sample t-test : tests hyp. if data is from distribution with mean 0
% *** = p<0.001, ** p<0.01, * p<0.05
for ii = 1:size(meanResp1,2)
    [h,pVal,ci,stats] = ttest(meanResp1(:,ii));
    pVals1(ii) = pVal;
    [h,pVal,ci,stats] = ttest(meanResp2(:,ii));
    pVals2(ii) = pVal;
end
pVals1
pVals2

% inefficient yet accurate depiction of significance values...
for ii = 1:length(pVals1)
   if pVals1(ii) <= 0.001
       stars1{ii} = '***'; 
   elseif pVals1(ii) <= 0.01
       stars1{ii} = '**'; 
   elseif pVals1(ii) <= 0.05
       stars1{ii} = '*'; 
   else
       stars1{ii} = 'ns'; %no stars for you!
   end
end
for ii = 1:length(pVals2)
   if pVals2(ii) <= 0.001
       stars2{ii} = '***'; 
   elseif pVals2(ii) <= 0.01
       stars2{ii} = '**'; 
   elseif pVals2(ii) <= 0.05
       stars2{ii} = '*'; 
   else
       stars2{ii} = 'ns'; %no stars for you!
   end
end

%% Add significance values to difference plot
starY = yMax+0.5;
lineYTop = starY-0.25;
sft = 0.5;
for ii = 1:size(meanResp1,2)
   textX = currInj1(ii);
   text(textX, starY, stars1{ii}, 'HorizontalAlignment', 'center','Fontsize', fontSize_axis) 
   lineY = lineYTop;
   line([currInj1(ii) currInj1(ii)], [lineY lineY], 'Color', 'k')
end
for ii = 1:size(meanResp2,2)
   textX = currInj2(ii);
   text(textX, starY, stars2{ii}, 'HorizontalAlignment', 'center','Fontsize', fontSize_axis) 
   lineY = lineYTop;
   line([currInj2(ii) currInj2(ii)], [lineY lineY], 'Color', 'k')
end


