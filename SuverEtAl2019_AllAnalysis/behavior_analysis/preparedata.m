function resdata = preparedata(resdata,window,threshold,edges)

%resdata is your imported data
%window is the [t1 t2] of where you care about in the trial for filtering
%edges
%threshold is the % of time they can spend within 3mm of the edge 
%edges is an on off flag to decide if you will do the edge filtering

resdata=a_vels(resdata);
if edges
    resdata=removeedges(resdata,window,threshold);
    resdata=removeedgestopbottom(resdata,window,threshold);
end
resdata=minrun(resdata,5);
end