
function filtresdata = removeedgestopbottom(resdata,duration,threshold)
%duration has the format [starttime endtime]

samp=50;
tstart=duration(1)*samp;
tend=duration(2)*samp;

%want to remove anything where they spend too much time against the wall -
%whether that be the left or right one - only remove from xfilt for a given
%trial.


yfilt={resdata.yfilt};%get the xdata for each fly
filtresdata=resdata;
for k=1:numel(filtresdata)%go through each fly
    yf=yfilt{k};% get every run
    keep=[];
    for p=1:size(yf,2)
        singleruny=yf(tstart:tend,p);%only look at the interval that matters to you
        topwall=find(singleruny>147);%check all the times the run is within 3mm of the edge
        bottomwall=find(singleruny<3);
        
        if length(topwall)/length(singleruny)<=threshold && length(bottomwall)/length(singleruny)<=threshold %skip trials that have more than 30% close to the edge
            keep=[keep,p]; %otherwise we'll ditch the trial 
        end
    end
    filtresdata=filterspecfic(filtresdata,k,keep);
end
end
    
  
        
    