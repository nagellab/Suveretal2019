
function trackslidesf (resdata,type)

for i = 1:length(resdata)
    
    plotflytracksf(resdata(i),type);
    
    set(gcf,'numbertitle','off', 'name',['FLY #',num2str(i)])
    
    input('')
    
    close
end