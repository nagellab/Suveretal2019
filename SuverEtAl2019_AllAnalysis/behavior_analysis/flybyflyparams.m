function[flyparams,baseline]=flybyflyparams(param,window,resdata,mode)
%enter the parameter you're interested in looking at as the param (string)
%window will dictate whether it's an ONSET response or an OFFSET response
%enter window as 4 numbers [startbaseline endbaseline startdata enddata]
%
%pass resdata either for windpulse or odour pulse and appropriate windows
%param names are 'pmove', 'vmove','vymove','pturn'
%mode - whether to return the actual or the difference
flyparams=[];
baseline=[];
samp=50;%50hx behavioural sampling rate

for k=1:length(resdata)%for each fly
    
    flydata=getfield(resdata(k),param);
    base = nanmean(nanmean(flydata(window(1)*samp:window(2)*samp,:),2));%compute the baseline
    resp = nanmean(nanmean(flydata(window(3)*samp:window(4)*samp,:),2));
    %take the difference from baseline
    difference=resp-base;
    if mode==1
    flyparams=[flyparams;difference];
    else
        flyparams=[flyparams;resp];
    end
    baseline=[baseline;base];
end
end

    




