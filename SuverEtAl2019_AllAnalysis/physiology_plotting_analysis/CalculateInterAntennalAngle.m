%%
% Calculate inter-antennal angle from antenna tracking data
%
%%

function [interAntennal_mean, interAntennal_std, interAntennal_indv] = CalculateInterAntennalAngle()


filename = ['../SuverEtAl2019_DATA/all_anterior.mat'];
load(filename)

rightAng = mean(traces.rightPreStim_avg,2);
leftAng = mean(traces.leftPreStim_avg,2);

interAntennal_indv = abs(rightAng)+abs(leftAng);
interAntennal_mean = mean(interAntennal_indv);
interAntennal_std = std(interAntennal_indv);