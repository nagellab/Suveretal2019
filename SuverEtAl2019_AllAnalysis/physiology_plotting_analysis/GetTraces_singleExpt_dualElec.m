%%
% GetTraces_singleExpt_dualElec(data)
%
% Suver et al. 2019
%%

function [injI1 injVm1 respVm2 injI2 injVm2 respVm1 ...
    meanI1_inj meanVm1_inj meanVm2_resp meanI2_inj meanVm2_inj meanVm1_resp] ...
    = GetTraces_singleExpt_dualElec(date, expt)
samplerate = 10000;
if nargin < 2
   display('Please input: ')
   display('(1) date (string), e.g ''2018_02_25''')
   display('(2) expt (int), e.g. 2')
   return
end

filename = ['C:\Users\nagellab\Documents\Data\' date '\' date '_E' num2str(expt)];
load(filename)

%extract single traces corresponding to the same current pulse, for each
%electrode
for ii = 1:length(data)
   injCurr1(ii) = data(ii).injectedCurrent_elec1;
   injCurr2(ii) = data(ii).injectedCurrent_elec2;
end
currentSteps1 = unique(injCurr1);
currentSteps2 = unique(injCurr2);
injCurr = currentSteps1;

%gather single trace pairs for each current injection level
injVm1 = cell(length(injCurr), 1);
injI1 = cell(length(injCurr), 1);
respVm2 = cell(length(injCurr), 1);
injVm2 = cell(length(injCurr), 1);
injI2 = cell(length(injCurr), 1);
respVm1 = cell(length(injCurr), 1);
injInds1 = cell(length(injCurr), 1);
injInds2 = cell(length(injCurr), 1);

for ii = 1:length(data)
    in1 = data(ii).injectedCurrent_elec1;
    in2 = data(ii).injectedCurrent_elec2;
    
    vm1 = data(ii).Vm1;
    vm2 = data(ii).Vm2;
    
    if (in1 ~= 0) && (in2 == 0) %elec 1 injection
        injInd = find(in1==injCurr); %index for this level of current injection
        injInds1{injInd} = [injInds1{injInd}; injInd];
        injVm1{injInd} = [injVm1{injInd}; vm1'];
        injI1{injInd} = [injI1{injInd}; data(ii).I1'];
        respVm2{injInd} = [respVm2{injInd}; vm2'];
    elseif (in2 ~= 0) && (in1 == 0) %elec 2 injection
        injInd = find(in2==injCurr); %index for this level of current injection
        injInds2{injInd} = [injInds2{injInd}; injInd];
        injVm2{injInd} = [injVm2{injInd}; vm2'];
        injI2{injInd} = [injI2{injInd}; data(ii).I2'];
        respVm1{injInd} = [respVm1{injInd}; vm1'];
    elseif (in1 == 0) && (in2 == 0) %0 current
        injInd = find(in1==injCurr); %index for this level of current injection
        
        injInds1{injInd} = [injInds1{injInd}; injInd];
        injVm1{injInd} = [injVm1{injInd}; vm1'];
        injI1{injInd} = [injI1{injInd}; data(ii).I1'];
        respVm2{injInd} = [respVm2{injInd}; vm2'];
        
        injInds2{injInd} = [injInds2{injInd}; injInd];
        injVm2{injInd} = [injVm2{injInd}; vm2'];
        injI2{injInd} = [injI2{injInd}; data(ii).I2'];
        respVm1{injInd} = [respVm1{injInd}; vm1'];
    else
        display('Current injection from both electrodes - this is not expected!!')
        return
    end    
end

%compute the average traces
for ii = 1:length(injCurr)
    i1 = injI1{ii};
    vm1 = injVm1{ii};
    vm2 = respVm2{ii};
    meanI1_inj(ii,:) = mean(i1);
    meanVm1_inj(ii,:) = mean(vm1);
    meanVm2_resp(ii,:) = mean(vm2);
    
    i2 = injI2{ii};
    vm2 = injVm2{ii};
    vm1 = respVm1{ii};
    meanI2_inj(ii,:) = mean(i2);
   meanVm2_inj(ii,:) = mean(vm2); 
   meanVm1_resp(ii,:) = mean(vm1);    
end
