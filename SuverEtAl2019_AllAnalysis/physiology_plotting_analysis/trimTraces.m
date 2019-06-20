%super lean function to trim a set of long time traces to certain experimental inds
function trace = trimTraces(trace,inds)
trace = trace(inds,:);