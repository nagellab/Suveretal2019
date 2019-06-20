%function to remove any flies that have less than 5 runs from a given
%resdata set

function filtresdata = minrun(resdata, minnum)

xfilt={resdata.xfilt};%use xfilt as proxy for number of runs completed
keep=[];%keep index of those with less than the minnum
for k=1:numel(xfilt)%for the number of flies you have check the number of runs
    xf=xfilt{k};
    if size(xf,2)>=minnum
        keep=[keep,k];
    end
end
filtresdata=resdata(keep);

end