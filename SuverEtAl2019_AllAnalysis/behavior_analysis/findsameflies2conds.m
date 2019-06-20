function [inds1,inds2]=findsameflies2conds(resdata1,resdata2)

%get the indices where the flies match
%return those inds
%will be the same length
%check that
%make sure Fly# is the same
%make sure the experiment # is the same
%shouldn't have a problem with mislabelling
%go through the list of which one is bigger -> find that one's paired flies
inds1=[];
inds2=[];
if numel(resdata1)>=numel(resdata2)
    big=resdata1;
    small=resdata2;
    
else
    big=resdata2;
    small=resdata1;
end

bigflies={big.fly}';
smallflies={small.fly}';
bigexps={big.experiment}';
smallexps={small.experiment}';
bigdates={big.date}';
smalldates={small.date}';
% if numel(resdata1)>=numel(resdata2)
%     inds2=1:numel(resdata2);
% else
%     inds1=1:numel(resdata1);
% end
p=1;
for k=1:numel(bigdates)
    if ~isstring(bigdates{k})
    bigdates{k}=mat2str(bigdates{k});
    end
end
for k=1:numel(smalldates)
    if ~isstring(smalldates{k})
    smalldates{k}=mat2str(smalldates{k});
    end
end
for k=1:numel(smallflies)
    a=strfind(bigflies,smallflies{k});
    b=strfind(bigexps,smallexps{k});
    c=strfind(bigdates,smalldates{k});
        
    ea = ~cellfun('isempty',a);
    eb = ~cellfun('isempty',b);
    ec = ~cellfun('isempty',c);
    ed=ea+eb+ec;
    if find(ed>2) %if there is a 3 - meaning all are hits
        ind=find(ed>2);%should only be one.
        if numel(resdata1)>=numel(resdata2)
            inds1(p)=ind;
            inds2(p)=k;
            p=p+1;
        else
            try
            inds2(p)=ind;
            catch
                disp('error');
            end
            inds1(p)=k;
            p=p+1;
        end
    end
end






end


