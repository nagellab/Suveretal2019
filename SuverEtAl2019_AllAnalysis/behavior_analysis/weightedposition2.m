function [wp, np] = weightedposition2(resdata,segment)
%specify the segment start and end in seconds
%ie [30 40] start at 30seconds and end at 40s to take the data. 
%uses average position rather than binned histograms 

if nargin>1
segment=segment*50; %convert to samples
else
    segment=[1/50 70]*50;%by default use the whole trial if not specified
end
wp=[];
np=[];

binis=linspace(0,140,28);
n=size(resdata,2);%number of flies - generate for each 
%figure; hold on;
for k=1:n
    
    y=resdata(k).yfilt;
    suby=y(segment(1):segment(2),:);
    
    w=(suby(:));
    h=histc(w,binis);
    %wp=[wp;prctile(w,30)];
    %wp=[wp;prctile(w,70)];
    normalized_probs=h./nansum(h);
    np=[np,normalized_probs];
    wp=[wp;nanmean(w)];
    %figure;
    %barh(binis+bin_size,h./nansum(h),'facecolor','m');
    %title([num2str(nansum(weighted))]);
end
end
%close all;
    