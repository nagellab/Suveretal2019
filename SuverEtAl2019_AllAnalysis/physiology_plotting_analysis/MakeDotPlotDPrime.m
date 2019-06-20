%%
% Quantify and plot steady state comparisons
%
% Suver et al. 2019
%%


function [figDiffs] = MakeDotPlotDPrime(all_dots, all_std, TEST, position, yAxisTicks, testPairs, starLevels, names, exptNames, cellTypeColors)
load_figure_constants;
if TEST
    figTuningTest = figure('color', 'w', 'Position', diffFigPositionTest);
end
figDiffs = figure('color', 'w', 'Position', position);

xMin = 0; xMax = length(all_dots)*3+1;
xlim([xMin-1 xMax])

% draw line at zero
line([xMin+0.5 xMax-0.5], [0 0], 'Color', lineColor_zeroDashed, 'Linestyle', ':')

dots = cell(length(all_dots),2);
dotsSequential = cell(length(all_dots)*size(all_dots{1},2),1);
for ii = 1:size(all_dots,2)
   tt = all_dots{ii};
   for jj = 1:size(tt,1)
        for kk = 1:size(tt,2)
            flyAvg = tt(jj,kk); %individual averages
            dots{ii,kk} = [dots{ii,kk}; flyAvg];
            (ii-1)*2+kk
            dotsSequential{(ii-1)*2+kk} = [dotsSequential{(ii-1)*2+kk}; flyAvg];
            if TEST
                figure(figTuningTest); subplot(length(all_dots),1,ii); ylim([-20 20]); hold on
                plot(flyAvg, '.-m')
            end
            figure(figDiffs); hold on
            randJitter = rand*jitterAmt-jitterAmt/2;
            plot((ii-1)*3+kk+randJitter, flyAvg, 'Color', color_ipsiContra_indv, 'Marker', '.', 'MarkerSize', ipsiContraIndvSize)
        end
   end
   for kk = 1:size(tt,2)
       line([(ii-1)*3+kk-jitterAmt*.75 (ii-1)*3+kk+jitterAmt*.75],[mean(dots{ii,kk}) mean(dots{ii,kk})], 'Color', color_ipsiContra_mean, 'Linewidth', ipsiContraMeanLineSize)
       line([(ii-1)*3+kk-jitterAmt*.75 (ii-1)*3+kk+jitterAmt*.75],[mean(dots{ii,kk}) mean(dots{ii,kk})], 'Color', color_ipsiContra_mean, 'Linewidth', ipsiContraMeanLineSize)
   end
   if TEST
       figure(figTuningTest); hold on; title(names{ii}); xlim([0 6]);
       plot(trace.avgWR, '-m', 'Linewidth', 2)
   end
end
dots
dotsSequential

%% make text labels for each set of data
minDiff = min(vertcat(dots{:}));
maxDiff = max(vertcat(dots{:}));
figure(figDiffs); hold on
if strcmp(names{1},'intact')
    bottom = min(yAxisTicks)
    top = scale_ipsiContra+bottom
    ylim([bottom top])
else
    top = scale_ipsiContra-minDiff-15;
    ylim([minDiff-5 top]) %make room in y for text labels (below) and statistical tests (above)
end

for ii = 1:size(all_dots,2)
    for kk = 1:size(all_dots{ii},2)
        text((ii-1)*3+kk, minDiff-1, names{kk}, 'Color', black, 'Rotation', rotateIpsiContraText, 'HorizontalAlignment', 'right', 'Fontsize', fontSize_axis)
    end
end
for ii = 1:size(all_dots,2)
    text((ii-1)*3+0.5, minDiff-4, exptNames{ii}, 'Color', cellTypeColors(ii,:), 'Rotation', 0, 'HorizontalAlignment', 'left', 'Fontsize', fontSize_axis)
end

%% manually draw y-axis (no x-axis needed)
yAxisX = xMin;
for ii = 1:length(yAxisTicks)
   line([yAxisX yAxisX+0.1], [yAxisTicks(ii) yAxisTicks(ii)], 'Linewidth', lineWid_axis, 'Color', axisColor) 
   text(yAxisX-0.1, yAxisTicks(ii), num2str(yAxisTicks(ii)), 'HorizontalAlignment', 'right', 'Color', axisColor, 'Fontsize', fontSize_axis) 
end
line([yAxisX yAxisX], [yAxisTicks(1) yAxisTicks(end)], 'Linewidth', lineWid_axis, 'Color', axisColor) 
axis off
text(yAxisX-0.75, mean(yAxisTicks), 'd''', 'Rotation', 90, 'HorizontalAlignment', 'center','Fontsize', fontSize_axis)

%% Run statistical tests on desired pairs of data

% two-sample t-test for equal means between samples
% *** = p<0.001, ** p<0.01, * p<0.05
testPairs
for ii = 1:(size(testPairs,1))
    [h,pVal,ci,stats] = ttest2(dotsSequential{testPairs(ii,1)}, dotsSequential{testPairs(ii,2)});
    pVals(ii) = pVal;
end
names
pVals
numComparisons = 1;%length(testPairs); %we are not correcting here - these are independent groups!

% inefficient yet accurate depiction of significance values...
for ii = 1:length(pVals)
   if pVals(ii) <= 0.001./numComparisons
       stars{ii} = '***'; 
   elseif pVals(ii) <= 0.01./numComparisons
       stars{ii} = '**'; 
   elseif pVals(ii) <= 0.05./numComparisons
       stars{ii} = '*'; 
   else
       stars{ii} = 'ns'; %no stars for you!
   end
end

%% Add significance values to difference plot
starY = maxDiff+3;
lineYTop = starY-0.25;
sft = 0.5;
for ii = 1:size(testPairs,1)
   textX = testPairs(ii,2)-0.5+kk*ii/3;
   text(textX, starY, stars{ii}, 'HorizontalAlignment', 'center','Fontsize', fontSize_axis) 
   lineY = lineYTop-starLevels(ii)*sft;
   line([testPairs(ii,1) testPairs(ii,2)+kk*ii/3], [lineY lineY], 'Color', 'k')
end
