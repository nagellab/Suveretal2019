function [genotypesparam,genotypesbaseline,genotypesbaselinsubtracted]=extractdata_allgenotypes(paramname,window,condition,condition2)

%set this function off in the folder where you've stored all your data in
%.mat files
%let it load each one sequenctially and pick out the parameters you care
%about and save them as separate arrays.

%run this with data1 as first and data2 as second and then flip to get
%values appopriately
folder = pwd;

files=dir(fullfile(folder,'*.mat'));

%genotypesparam={};
%genotypesbaseline={};
%genotypesbaselinesubtracted={};%will need a bit of work to get this for all of them



for k=1:length(files)
    dataname=files(k).name;
    S=load(dataname); %annoying shit to have deal with the fact everything is named differently
    fn=fieldnames(S);
    data=S.(fn{1});
    try
    resdata=data.(condition);%odour will need different for chrim inactivation
    resdata=preparedata(resdata,[30 35],0.25,1);
    catch
        resdata=preparedata(data,[30 35],0.25,1);%for single glue combination made without importer.
    end
  
    if nargin>3
        resdata2=data.(condition2);
        resdata2=preparedata(resdata2,[40 45],0.25,0);
        [i1,i2]=findsameflies2conds(resdata,resdata2);
    end
    
    if strcmp(paramname,'curvature')
        [flyparams,baseline,bssub]=computeAOC(1,window,resdata);
        g=resdata.genotype;
    elseif strcmp(paramname,'angv')
        [flyparams,baseline,bssub]=computeAOC(2,window,resdata);
    elseif strcmp(paramname,'dist')
        [flyparams,baseline,bssub]=totaly(resdata,window);
    elseif strcmp(paramname,'weightedpositionsingle')
        [flyparams,~]=weightedposition2(resdata,window);
        baseline=0;
        bssub=0;
    elseif strcmp(paramname,'weightedposition')
        %do something here to make sure that they only take flies which are
        %used in both conditions
        %if I want to do it for odour condition - lets look at it using
        %condition
        wind=data.('resblankalwayson');
        wind=minrun(wind,5);
        blank=data.('resblankalwaysoff');
        other=data.('res10salwayson');
        blank=minrun(blank,5);
        other=minrun(other,5);
        [i1,i2]=findsameflies2conds(wind,blank);
        [i3,i4]=findsameflies2conds(wind,other);
        [flyparams]=weightedposition2(wind(:,i1),window);%really
        baseline=weightedposition2(blank(:,i2),window);%really blank
        %baseline=weightedposition2(other(:,i4),window);
        bssub=baseline-flyparams;
    elseif strcmp(paramname,'cdf')
        
    else
        [flyparams,baseline]=flybyflyparams(paramname,window,resdata,2);%use the not baseline subtract type for now
        [bssub,~]=flybyflyparams(paramname,window,resdata,1);
    end
    %add to the struct to get all of them for the single genotype
    %use the filename to correctly name each one
    dataname=strcat(['d' dataname(1:end-4)]);
    if nargin>3
        genotypesparam.(dataname)=flyparams(i1);
        genotypesbaseline.(dataname)=baseline(i1);
        genotypesbaselinsubtracted.(dataname)=bssub(i1);
    else
        genotypesparam.(dataname)=flyparams;
        genotypesbaseline.(dataname)=baseline;
        genotypesbaselinsubtracted.(dataname)=bssub;
    end
    
    clear S %what about for orco and 5905 etc?
end
end