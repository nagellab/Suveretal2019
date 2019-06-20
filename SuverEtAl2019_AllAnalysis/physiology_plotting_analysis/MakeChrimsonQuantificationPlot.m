%% Quantification plot for chrimson activation
%
% Suver et al. 2019

function fig = MakeChrimsonQuantificationPlot(traces, traceNames, xLocs, position, testPairs, starLevels)
load_figure_constants;
tt = traces{1};
preStim = tt.preStim*tt.samplerate/tt.DSAMP;
stimEnd = preStim+tt.stimOn*tt.samplerate/tt.DSAMP;
stimInds_steadyState = stimEnd/2:stimEnd; %steady-state: last 2 s of light stim
stimInds_onset = preStim:(preStim+chrimsonOnset*tt.samplerate/tt.DSAMP);
preStimInds = 1:preStim;

fig = figure('color', 'w', 'Position', position); hold on
xMin = 0; xMax = max(xLocs) + 1;
xlim([xMin-1 xMax])

% draw line at zero
line([xMin+0.5 xMax-0.5], [0 0], 'Color', lineColor_zeroDashed, 'Linestyle', ':')

%% compute average light response for each condition
avgResp_ss = []; %average *steady state* response for each condition
avgResp_onset = []; %avg onset response for each condition
avgResp_ss_indv = []; %average response for each fly, for each condition
avgResp_onset_indv = []; %average response for each fly, for each condition
for ii = 1:length(traces)
    tt = traces{ii};
    avgResp_ss(ii) = nanmean(tt.avgVmTrace(stimInds_steadyState)); %
    avgResp_onset(ii) = nanmean(tt.avgVmTrace(stimInds_onset)); 
    indvAvgs_ss = [];
    indvAvgs_onset = [];
    for jj = 1:tt.numFlies
        indvTrace = tt.indvVmTrace{jj};
        indvAvgs_ss(jj) = nanmean(indvTrace(stimInds_steadyState));
        indvAvgs_onset(jj) = nanmean(indvTrace(stimInds_onset));
    end
    avgResp_ss_indv{ii} = indvAvgs_ss;
    avgResp_onset_indv{ii} = indvAvgs_onset;
end

%% Plot the averages!
jitterAmt = 0.2; 
for ii = 1:length(traces)
    indvAvgs_ss = avgResp_ss_indv{ii};
    indvAvgs_onset = avgResp_onset_indv{ii};
    xx = xLocs(ii);
    if ~CHRIMSON_INDV_AVGS
        line([xx-jitterAmt*.75 xx-jitterAmt*.75], [avgResp_ss(ii)-nanstd(indvAvgs_ss) avgResp_ss(ii)+nanstd(indvAvgs_ss)], 'Color', color_ipsiContra_mean, 'Linewidth', ipsiContraMeanErrorLineSize)   
        line([xx+jitterAmt*.75 xx+jitterAmt*.75], [avgResp_onset(ii)-nanstd(indvAvgs_onset) avgResp_onset(ii)+nanstd(indvAvgs_onset)], 'Color', color_chrimson_onset, 'Linewidth', ipsiContraMeanErrorLineSize)
    else
        for jj = 1:length(indvAvgs_ss)
            randJitter = rand*jitterAmt-jitterAmt/2;
            plot(xx+randJitter-jitterAmt*.75, indvAvgs_ss(jj), 'Color', color_ipsiContra_indv, 'Marker', '.', 'MarkerSize', ipsiContraIndvSize)
            plot(xx+randJitter+jitterAmt*.75, indvAvgs_onset(jj), 'Color', color_chrimson_onset, 'Marker', '.', 'MarkerSize', ipsiContraIndvSize)
        end
    end
    if ~CHRIMSON_INDV_AVGS
        plot([xx-jitterAmt*.75],[avgResp_ss(ii)], 'Marker', '.', 'Color', color_ipsiContra_mean, 'Markersize', chrimsonQuantMeanSize)
        %%left bottom width height
        wid = jitterAmt*1.25;
        left = xx+jitterAmt*.75-wid/2;
        height = wid*1.5;
        bottom = avgResp_onset(ii)-height/2;
        rectangle('Position', [left bottom wid height], 'Edgecolor', color_chrimson_onset,'Facecolor', color_chrimson_onset)
    else
        line([xx-jitterAmt*.75-jitterAmt*.75 xx+jitterAmt*.75-jitterAmt*.75],[avgResp_ss(ii) avgResp_ss(ii)], 'Color', color_ipsiContra_mean, 'Linewidth', ipsiContraMeanLineSize)
        line([xx-jitterAmt*.75+jitterAmt*.75 xx+jitterAmt*.75+jitterAmt*.75],[avgResp_onset(ii) avgResp_onset(ii)], 'Color', color_chrimson_onset, 'Linewidth', ipsiContraMeanLineSize)
    end
end

%% manually draw y-axis (no x-axis needed)
yAxisTicks = yAxis_quant_Chrimson;
yAxisX = xMin;
for ii = 1:length(yAxisTicks)
   line([yAxisX yAxisX+0.2], [yAxisTicks(ii) yAxisTicks(ii)], 'Linewidth', lineWid_axis, 'Color', axisColor) 
   text(yAxisX-0.1, yAxisTicks(ii), num2str(yAxisTicks(ii)), 'HorizontalAlignment', 'right', 'Color', axisColor, 'Fontsize', fontSize_axis) 
end
line([yAxisX yAxisX], [yAxisTicks(1) yAxisTicks(end)], 'Linewidth', lineWid_axis, 'Color', axisColor) 
axis off
text(yAxisX-1.5, mean(yAxisTicks), 'response (mV)', 'Rotation', 90, 'HorizontalAlignment', 'center','Fontsize', fontSize_axis)

%% make text labels for each set of data
minDiff = -4;
maxDiff = 4;
top = 6; %scale_ipsiContra-minDiff-15;
ylim([minDiff-5 top]) %make room in y for text labels (below) and statistical tests (above)
textShift = -0.5;
for ii = 1:length(traces)
   text(xLocs(ii), minDiff+textShift, traceNames{ii}, 'Color', black, 'Rotation', rotateIpsiContraText, 'HorizontalAlignment', 'right', 'Fontsize', fontSize_axis) 
end

%% Show legend for colors (black - steady state; green - peak)
text(max(xLocs(ii))-2.5,-2.5, 'steady state', 'HorizontalAlignment', 'left','Fontsize', fontSize_axis, 'Color', color_ipsiContra_mean)
text(max(xLocs(ii))-2.5,-3.5, 'onset', 'HorizontalAlignment', 'left','Fontsize', fontSize_axis, 'Color', color_chrimson_onset)

%%% Run statistical tests on desired pairs of data

% two-sample t-test for equal means between samples
% *** = p<0.001, ** p<0.01, * p<0.05
for ii = 1:(size(testPairs,1))
    indvAvgs_onset = avgResp_onset_indv{ii};
    
    [h,pVal,ci,stats] = ttest2(avgResp_ss_indv{testPairs(ii,1)}, avgResp_ss_indv{testPairs(ii,2)});
    pVals_ss(ii) = pVal;
    
    [h,pVal,ci,stats] = ttest2(avgResp_onset_indv{testPairs(ii,1)}, avgResp_onset_indv{testPairs(ii,2)});
    pVals_onset(ii) = pVal; 
end
%traceNames
pVals_ss
pVals_onset
% inefficient yet accurate depiction of significance values...
for ii = 1:length(pVals_ss)
   if pVals_ss(ii) <= 0.001
       stars_ss{ii} = '***'; 
   elseif pVals_ss(ii) <= 0.01
       stars_ss{ii} = '**'; 
   elseif pVals_ss(ii) <= 0.05
       stars_ss{ii} = '*'; 
   else
       stars_ss{ii} = 'ns'; 
   end
end

for ii = 1:length(pVals_onset)
   if pVals_onset(ii) <= 0.001
       stars_onset{ii} = '***'; 
   elseif pVals_onset(ii) <= 0.01
       stars_onset{ii} = '**'; 
   elseif pVals_onset(ii) <= 0.05
       stars_onset{ii} = '*'; 
   else
       stars_onset{ii} = 'ns'; 
   end
end

%% Add significance values to difference plot
starY = maxDiff+2.5 ;
lineYTop = starY-0.25;
sft = 0.25;
for ii = 1:size(testPairs,1)
   textX = xLocs(testPairs(ii,2))-0.5;
   text(textX, starY, stars_ss{ii}, 'HorizontalAlignment', 'center','Fontsize', fontSize_axis) 
   lineY = lineYTop-starLevels(ii)*sft;
   line([xLocs(testPairs(ii,1)) xLocs(testPairs(ii,2))], [lineY lineY], 'Color', 'k')
   
   onsetShift = jitterAmt*.75;
   textX = xLocs(testPairs(ii,2));
   text(textX, starY-1, stars_onset{ii}, 'HorizontalAlignment', 'center','Fontsize', fontSize_axis) 
   lineY = lineYTop-starLevels(ii)*sft-1;
   line([xLocs(testPairs(ii,1))+onsetShift xLocs(testPairs(ii,2))+onsetShift], [lineY lineY], 'Color', 'k')
end

