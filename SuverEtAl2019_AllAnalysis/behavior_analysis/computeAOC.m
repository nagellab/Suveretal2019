function [aoc,baseline,bssubaoc] = computeAOC(type,window,resdata)
%enter the type of data you will take the area of the curveunder
%generally for computing the off response size and differences between hot
%and cold - performs area under curve calculation (baseline subtracted) and
%also gives the baseline (for h/c comparison)
% 1 curvature
% 2 angular velocity

%window - in seconds where does the window fall
%helper function for generating the fly-by-fly area under curve for the 1
%fly average.AOC is the same as mean here.
%resdata - give all the flies data for the trial type.


aoc=[];
baseline=[];
bssubaoc=[];
samp=50;
%resdata=a_vels(resdata);
%figure;
for k=1:length(resdata)%
    
    if type ==1
        %get the  curvature
        base = nanmean(nanmean(resdata(k).curvature(10*samp:25*samp,:),2)); %compute baseline for the given trial type [hardcoded baseline]
        baseall=nanmean(resdata(k).curvature(10*samp:25*samp,:),2);
        offcurve= nanmean(resdata(k).curvature(window(1)*samp:window(2)*samp,:),2);
        %check to make sure there aren't any nans in offcurve
        b=isnan(offcurve);
        if sum(b)>=1 
            in=~isnan(offcurve);
            offcurve=offcurve(in);
        end
        c=isnan(baseall);
        if sum(c)>=1
            in=~isnan(baseall);
            baseall=baseall(in);
        end
        if numel(baseall>100)
        bssubaoc_off = trapz(offcurve-(base));
        %bssubaoc_off = nanmean(offcurve-(base));
        %hold on;
        %plot(offcurve-(base),'b');
        aoc_off = trapz(offcurve);
        %aoc_off = nanmean(offcurve);
        baseaoc=trapz(baseall);
        %baseaoc=nanmean(baseall);
        else
        bssubaoc_off = nan;
        aoc_off = nan;
        baseaoc=nan;
        end
            
        if isnan(aoc_off)
          
            aoc_off=nan;
        end
        baseline=[baseline;baseaoc/length(baseall)];
        aoc=[aoc;aoc_off/length(offcurve)];
        bssubaoc=[bssubaoc;bssubaoc_off/length(offcurve)];

        
    elseif type==2
        base = nanmean(nanmean(resdata(k).angvturn(10*samp:25*samp,:),2)); %compute baseline for the given trial type
        baseall = nanmean(resdata(k).angvturn(10*samp:25*samp,:),2);
        offcurve= nanmean(resdata(k).angvturn(window(1)*samp:window(2)*samp,:),2);
        b=isnan(offcurve);
        if sum(b)>=1 
            in=~isnan(offcurve);
            offcurve=offcurve(in);
        end
        c=isnan(baseall);
        if sum(c)>=1
            in=~isnan(baseall);
            baseall=baseall(in);
        end
        
        if numel(baseall>100)
        bssubaoc_off = trapz(offcurve-(base));
        aoc_off = trapz(offcurve);
        baseaoc=trapz(baseall);
        else
            bssubaoc_off = nan;
            aoc_off = nan;
            baseaoc = nan;
        end
        
        if isnan(aoc_off)
            aoc_off=nan;
        end
        
        baseline=[baseline;baseaoc/length(baseall)];
        aoc=[aoc;aoc_off/length(offcurve)];
        bssubaoc=[bssubaoc;bssubaoc_off/length(offcurve)];
    else
        disp('no option above 2! Pick 1(curvature) or 2 (angvel)');
    end
    
end
