
function [traces_wPN_ipsiX traces_wPN_contraX] = CombineGlueRemoveTraces(traces_wPN_ipsi, traces_wPN_ipsiRemove, traces_wPN_contra, traces_wPN_contraRemove)

traces_wPN_ipsiX = traces_wPN_ipsi;
n1 = traces_wPN_ipsi.numFlies;
n2 = traces_wPN_ipsiRemove.numFlies;
traces_wPN_ipsiX.avgVmTrace = (traces_wPN_ipsi.avgVmTrace*n1+traces_wPN_ipsiRemove.avgVmTrace.*n2)/(n1+n2);
traces_wPN_ipsiX.errorVm = (traces_wPN_ipsi.errorVm*n1+ traces_wPN_ipsiRemove.errorVm.*n2)/(n1+n2);
traces_wPN_ipsiX.numFlies = [n1+n2];

traces_wPN_contraX = traces_wPN_contra;
n1 = traces_wPN_contra.numFlies;
n2 = traces_wPN_contraRemove.numFlies;
traces_wPN_contraX.avgVmTrace = (traces_wPN_contra.avgVmTrace*n1+traces_wPN_contraRemove.avgVmTrace.*n2)/(n1+n2);
traces_wPN_contraX.errorVm = (traces_wPN_contra.errorVm*n1+traces_wPN_contraRemove.errorVm.*n2)/(n1+n2);
traces_wPN_contraX.numFlies = [n1+n2];

traces_wPN_ipsiX.indvTonicWindAvg = [traces_wPN_ipsiX.indvTonicWindAvg; traces_wPN_ipsiRemove.indvTonicWindAvg];
traces_wPN_ipsiX.indvOnsetWindAvg_meanCrossFly = [traces_wPN_ipsiX.indvOnsetWindAvg_meanCrossFly; traces_wPN_ipsiRemove.indvOnsetWindAvg_meanCrossFly];
traces_wPN_ipsiX.indvTonicWindAvg_meanCrossFly = [traces_wPN_ipsiX.indvTonicWindAvg_meanCrossFly; traces_wPN_ipsiRemove.indvTonicWindAvg_meanCrossFly];
traces_wPN_ipsiX.avgWR = (traces_wPN_ipsiX.avgWR*n1+traces_wPN_ipsiRemove.avgWR.*n2)/(n1+n2);
traces_wPN_ipsiX.avgWRMax = (traces_wPN_ipsiX.avgWRMax*n1+traces_wPN_ipsiRemove.avgWRMax.*n2)/(n1+n2);

traces_wPN_contraX.indvTonicWindAvg = [traces_wPN_contraX.indvTonicWindAvg; traces_wPN_contraRemove.indvTonicWindAvg];
traces_wPN_contraX.indvOnsetWindAvg_meanCrossFly = [traces_wPN_contraX.indvOnsetWindAvg_meanCrossFly;traces_wPN_contraRemove.indvOnsetWindAvg_meanCrossFly];
traces_wPN_contraX.indvTonicWindAvg_meanCrossFly = [traces_wPN_contraX.indvTonicWindAvg_meanCrossFly;traces_wPN_contraRemove.indvTonicWindAvg_meanCrossFly];
traces_wPN_contraX.avgWR = (traces_wPN_contraX.avgWR*n1+traces_wPN_contraRemove.avgWR.*n2)/(n1+n2);
traces_wPN_contraX.avgWRMax = (traces_wPN_contraX.avgWRMax*n1+traces_wPN_contraRemove.avgWRMax.*n2)/(n1+n2);