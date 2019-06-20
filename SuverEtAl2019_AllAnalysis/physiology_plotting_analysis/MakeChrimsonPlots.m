%%
% Plot Chrimson results for Suver et al. 2018
% 
% Suver et al. 2019
%%

function [figTraces] = MakeChrimsonPlots(traces1, names1, traces2, names2, ERROR_AVG_VM_TRACES, position, SPIKERATE)
load_figure_constants;
scaleSize = 2;
samplerate = traces1{1}.samplerate/traces1{1}.DSAMP;
figTraces = figure('color', 'w', 'Position', position); hold on

for ii = 1:length(traces1)
    tt = traces1{ii};
    plot(tt.avgVmTrace, 'Color', colors_chrimson(ii,:), 'Linewidth', width_avgTrace)
end

nanLen = length(tt.avgVmTrace)+1*samplerate;

for ii = 1:length(traces2)
    tt = traces2{ii};
    plot([nan(1,nanLen) tt.avgVmTrace], 'Color', colors_chrimson(3,:), 'Linewidth', width_avgTrace)
end

if strcmp(names1, 'APN2+B1')
    yymin = -7;
    yymax = 4;
else    
    yymin = -5;
    yymax = 6;
end
ylim([yymin yymax])
xlim([-samplerate nanLen*2]); 
axis off;

% plot scale bar
bottomScale = 1;% %HARD-CODED!
scaleX = tt.preStim+tt.stimOn*samplerate+4*samplerate;
line([scaleX scaleX], [bottomScale bottomScale+scaleSize], 'Color', 'k', 'Linewidth', width_scale)
scaleTextX = scaleX+0.3*samplerate;
scaleTextY = bottomScale+scaleSize/2;
text(scaleTextX, scaleTextY, [num2str(scaleSize) ' mV'], 'Fontname', figureFont, 'Fontsize', fontSize_axis, 'HorizontalAlignment', 'left')

% plot stimulus bars:
yWindBar = -4; htWindBar = 0.15;
rectangle('Position', [tt.preStim*samplerate yWindBar tt.stimOn*samplerate htWindBar], 'FaceColor', 'k', 'EdgeColor', 'none');
text(tt.preStim*samplerate+tt.stimOn*samplerate/2,yWindBar-htWindBar*1.5, ' 4 s light', 'Fontname', figureFont, 'Fontsize', fontSize_axis, 'HorizontalAlignment', 'center')
if ~isempty(traces2)
    rectangle('Position', [tt.preStim*samplerate+nanLen yWindBar tt.stimOn*samplerate htWindBar], 'FaceColor', 'k', 'EdgeColor', 'none');
    text(tt.preStim*samplerate+nanLen+tt.stimOn*samplerate/2,yWindBar-htWindBar*1.5, ' 4 s light', 'Fontname', figureFont, 'Fontsize', fontSize_axis, 'HorizontalAlignment', 'center')
end
%plot legend for trace colors
xx1 = samplerate*6;
xx2 = nanLen+samplerate*6;
yy = -2;
sft = -0.6;
for ii = 1:length(traces1)
    text(xx1,yy+sft*(ii-1), names1{ii}, 'Color', colors_chrimson(ii,:), 'Fontname', figureFont, 'Fontsize', fontSize_axis, 'HorizontalAlignment', 'left')
end
for ii = 1:length(traces2)
    text(xx2,yy+sft*(ii-1), names2{ii}, 'Color', colors_chrimson(3,:), 'Fontname', figureFont, 'Fontsize', fontSize_axis, 'HorizontalAlignment', 'left')
end


