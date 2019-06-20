%%
% Combine data across dual recording experiments
% (manual/hard-coded)
%
% Suver et al. 2019
%%

function dualCellData = CombineDualExperiments()

% set indices for cross-cell comparison 
% (injected additional amounts of current that vary and cannot be averaged)
cell1.date = '2018_02_27'; cell1.expt = 3; 
cell1.inds = [3 4 5 6];
cell2.date = '2018_02_28'; cell2.expt = 8; 
cell2.inds = [2 4 6 8];
cell3.date = '2018_03_01'; cell3.expt = 5; 
cell3.inds = [2 4 6 7];

%% Cell 1
[qq ww ee rr tt yy ...
    uu ii oo pp aa ss] ...
    = GetTraces_singleExpt_dualElec(cell1.date, cell1.expt);
inds = cell1.inds; ind = 1;
injI1{ind} = trimTraces(qq,inds);
injVm1{ind} = trimTraces(ww,inds);
respVm2{ind} = trimTraces(ee,inds);
injI2{ind} = trimTraces(rr,inds);
injVm2{ind} = trimTraces(tt,inds);
respVm1{ind} = trimTraces(yy,inds);
meanI1_inj{ind} = trimTraces(uu,inds);
meanVm1_inj{ind} = trimTraces(ii,inds);
meanVm2_resp{ind} = trimTraces(oo,inds);
meanI2_inj{ind} = trimTraces(pp,inds);
meanVm2_inj{ind} = trimTraces(aa,inds);
meanVm1_resp{ind} = trimTraces(ss,inds);
%% Cell 2
[qq ww ee rr tt yy ...
    uu ii oo pp aa ss] ...
    = GetTraces_singleExpt_dualElec(cell2.date, cell2.expt);
inds = cell2.inds;
ind = 2;
injI1{ind} = trimTraces(qq,inds);
injVm1{ind} = trimTraces(ww,inds);
respVm2{ind} = trimTraces(ee,inds);
injI2{ind} = trimTraces(rr,inds);
injVm2{ind} = trimTraces(tt,inds);
respVm1{ind} = trimTraces(yy,inds);
meanI1_inj{ind} = trimTraces(uu,inds);
meanVm1_inj{ind} = trimTraces(ii,inds);
meanVm2_resp{ind} = trimTraces(oo,inds);
meanI2_inj{ind} = trimTraces(pp,inds);
meanVm2_inj{ind} = trimTraces(aa,inds);
meanVm1_resp{ind} = trimTraces(ss,inds);
%% Cell 3
[qq ww ee rr tt yy ...
    uu ii oo pp aa ss] ...
    = GetTraces_singleExpt_dualElec(cell3.date, cell3.expt);
inds = cell3.inds;
ind = 3;
injI1{ind} = trimTraces(qq,inds);
injVm1{ind} = trimTraces(ww,inds);
respVm2{ind} = trimTraces(ee,inds);
injI2{ind} = trimTraces(rr,inds);
injVm2{ind} = trimTraces(tt,inds);
respVm1{ind} = trimTraces(yy,inds);
meanI1_inj{ind} = trimTraces(uu,inds);
meanVm1_inj{ind} = trimTraces(ii,inds);
meanVm2_resp{ind} = trimTraces(oo,inds);
meanI2_inj{ind} = trimTraces(pp,inds);
meanVm2_inj{ind} = trimTraces(aa,inds);
meanVm1_resp{ind} = trimTraces(ss,inds);

%% store data for later
dualCellData.cmdCurr = [-10; 0; 10; 20];
dualCellData.injI1 = injI1;
dualCellData.injVm1 = injVm1;
dualCellData.respVm2 = respVm2;
dualCellData.injI2 = injI2;
dualCellData.injVm2 = injVm2;
dualCellData.respVm1 = respVm1;
dualCellData.meanI1_inj = meanI1_inj;
dualCellData.meanVm1_inj = meanVm1_inj;
dualCellData.meanVm2_resp = meanVm2_resp;
dualCellData.meanI2_inj = meanI2_inj;
dualCellData.meanVm2_inj = meanVm2_inj;
dualCellData.meanVm1_resp = meanVm1_resp;

