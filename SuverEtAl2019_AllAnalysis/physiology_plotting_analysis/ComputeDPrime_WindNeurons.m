%%
% Compute dprime values for a set of experiments
% For use with PlotDPrime_crossDirection() or PlotDPrime_table
%
% Suver et al. 2019
%%


function [dPrime_crossFlyAvg, dPrime_crossFlyStd, numFlies, dPrime_allFlies] = ComputeDPrime_WindNeurons(exptName, pairs)
%%
filename = ['../SuverEtAl2019_DATA/' num2str(exptName)]
load(filename);

for flyNum = 1:traces.numFlies
    %compute mean and standandard deviation for the four comparisons
    traces
    avg = traces.indvTonicWindAvg_meanCrossFly{flyNum};
    indv = traces.indvTonicWindAvg{flyNum};
    if iscell(indv);
        indv = indv{:};
    end
    std_crossTrial = std(indv'); %compute std across trials for one fly (one per direction)
    for dirInd = 1:size(pairs,1)
        ind1 = pairs(dirInd,1);
        ind2 = pairs(dirInd,2);
        dPrime(flyNum, dirInd) = (avg(ind1)-avg(ind2))/sqrt(0.5*(std_crossTrial(ind1)^2+std_crossTrial(ind2)^2));
    end
end
dPrime_allFlies = abs(dPrime);
dPrime_crossFlyAvg = abs(mean(dPrime,1));
dPrime_crossFlyStd = std(dPrime)/sqrt(length(dPrime));
numFlies = traces.numFlies;

