%%
% Quantify and plot steady state data
% Suver et al. 2019
%%


function [figDiffs] = MakeIpsiContraPlot(all_traces, ONSET, TEST, position, yAxisTicks, testPairs, starLevels)
load_figure_constants;
if TEST
    figTuningTest = figure('color', 'w', 'Position', diffFigPositionTest);
end
figDiffs = figure('color', 'w', 'Position', position);

xMin = 0; xMax = length(all_traces)+1;
xlim([xMin-1 xMax])

% draw line at zero
line([xMin+0.5 xMax-0.5], [0 0], 'Color', lineColor_zeroDashed, 'Linestyle', ':')

diff = cell(length(all_traces),1);
for ii = 1:length(all_traces)
   tt = all_traces{ii};
   traceName{ii} = tt.name;
   trace = tt.traces;
   for jj = 1:trace.numFlies
       %calculate individual averages
       if ONSET == 1 %onset response diff
           flyAvg = trace.indvOnsetWindAvg_meanCrossFly{jj}; 
           singleFlyDiff = flyAvg(5)-flyAvg(1);
       elseif ONSET == 2 %calculate magnitude of ipsi response
           flyAvg = trace.indvTonicWindAvg_meanCrossFly{jj}; 
           singleFlyDiff = flyAvg(5);
       else %default is steady-state tonic range
           flyAvg = trace.indvTonicWindAvg_meanCrossFly{jj}; 
           singleFlyDiff = flyAvg(5)-flyAvg(1);
       end
       diff{ii} = [diff{ii}; singleFlyDiff]; %ipsi-contra!
       if TEST
           figure(figTuningTest); subplot(length(all_traces),1,ii); ylim([-20 20]); hold on
           plot(flyAvg, '.-m')
       end
       figure(figDiffs); hold on
       randJitter = rand*jitterAmt-jitterAmt/2;
       plot(ii+randJitter, singleFlyDiff, 'Color', color_ipsiContra_indv, 'Marker', '.', 'MarkerSize', ipsiContraIndvSize)
   end
   
   line([ii-jitterAmt*.75 ii+jitterAmt*.75],[mean(diff{ii}) mean(diff{ii})], 'Color', color_ipsiContra_mean, 'Linewidth', ipsiContraMeanLineSize)   

   if TEST
       figure(figTuningTest); hold on; title(traceName{ii}); xlim([0 6]);
       plot(trace.avgWR, '-m', 'Linewidth', 2)
   end
end

%% make text labels for each set of data
minDiff = min(vertcat(diff{:}));
maxDiff = max(vertcat(diff{:}));
figure(figDiffs); hold on
if strcmp(traceName{1},'intact')
    bottom = min(yAxisTicks);
    top = scale_ipsiContra+bottom;
    ylim([bottom top]);
else
    top = scale_ipsiContra-minDiff-15;
    ylim([minDiff-5 top]) %make room in y for text labels (below) and statistical tests (above)
end

for ii = 1:length(all_traces)
   text(ii, minDiff-1, traceName{ii}, 'Color', black, 'Rotation', rotateIpsiContraText, 'HorizontalAlignment', 'right', 'Fontsize', fontSize_axis) 
end

%% manually draw y-axis (no x-axis needed)
yAxisX = xMin;
for ii = 1:length(yAxisTicks)
   line([yAxisX yAxisX+0.1], [yAxisTicks(ii) yAxisTicks(ii)], 'Linewidth', lineWid_axis, 'Color', axisColor) 
   text(yAxisX-0.1, yAxisTicks(ii), num2str(yAxisTicks(ii)), 'HorizontalAlignment', 'right', 'Color', axisColor, 'Fontsize', fontSize_axis) 
end
line([yAxisX yAxisX], [yAxisTicks(1) yAxisTicks(end)], 'Linewidth', lineWid_axis, 'Color', axisColor) 
axis off
text(yAxisX-0.75, mean(yAxisTicks), 'ipsi-contra (mV)', 'Rotation', 90, 'HorizontalAlignment', 'center','Fontsize', fontSize_axis)

%% Run statistical tests on desired pairs of data

%test for normality! 
tps = unique(testPairs);
for ii = 1:length(tps) 
    [h,p] = jbtest(diff{tps(ii)});
    display(['dataSet # ' num2str(tps(ii)) ' h=' num2str(h) ', p=' num2str(p) ' (jbtest)'])
end

% two-sample t-test for equal means between samples
% *** = p<0.001, ** p<0.01, * p<0.05
for ii = 1:(size(testPairs,1))        
    [h,pVal,ci,stats] = ttest2(diff{testPairs(ii,1)}, diff{testPairs(ii,2)});
    pVals(ii) = pVal;
end
traceName
pVals

numComparisons = 1; %no multiple comparisons here
% inefficient yet accurate depiction of significance values...
for ii = 1:length(pVals)
   if pVals(ii) <= 0.001./numComparisons
       stars{ii} = '***'; 
   elseif pVals(ii) <= 0.01./numComparisons
       stars{ii} = '**'; 
   elseif pVals(ii) <= 0.05./numComparisons
       stars{ii} = '*'; 
   else
       stars{ii} = 'ns'; 
   end
end

%% Add significance values to difference plot
starY = maxDiff+3;
lineYTop = starY-0.25;
sft = 0.5;
for ii = 1:size(testPairs,1)
   textX = testPairs(ii,2)-0.5;
   text(textX, starY, stars{ii}, 'HorizontalAlignment', 'center','Fontsize', fontSize_axis) 
   lineY = lineYTop-starLevels(ii)*sft;
   line([testPairs(ii,1) testPairs(ii,2)], [lineY lineY], 'Color', 'k')
end
