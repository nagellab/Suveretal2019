function filtresdata = removeedges(resdata,duration,threshold)
%duration has the format [starttime endtime]

samp=50;
tstart=duration(1)*samp;
tend=duration(2)*samp;

%want to remove anything where they spend too much time against the wall -
%whether that be the left or right one - only remove from xfilt for a given
%trial.


xfilt={resdata.xfilt};%get the xdata for each fly
filtresdata=resdata;
for k=1:numel(filtresdata)%go through each fly
    xf=xfilt{k};% get every run
    keep=[];
    for p=1:size(xf,2)
        singlerunx=xf(tstart:tend,p);%only look at the interval that matters to you
        leftwall=find(singlerunx<3);%check all the times the run is within 3mm of the edge
        rightwall=find(singlerunx>37);
        
        if length(leftwall)/length(singlerunx)<=threshold && length(rightwall)/length(singlerunx)<=threshold %skip trials that have more than 30% close to the edge
            keep=[keep,p]; %otherwise we'll ditch the trial 
        end
    end
    try
    filtresdata=filterspecfic(filtresdata,k,keep);%probably will be edge cases where keep is 0
    catch
        disp('wait')
    end
end
end
    
  
        
    