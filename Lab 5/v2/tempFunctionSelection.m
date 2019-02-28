function [fracFunction,tCurrentFunction] = tempFunctionSelection(tempFunction)

switch tempFunction
    case 0 %'default'
        fracFunction = @(tEnd,tStart,numCoolingLoops) (tEnd/tStart)^(1.0/(numCoolingLoops-1.0));
        tCurrentFunction = @(frac,tCurrent) frac * tCurrent;
    case 1 %'linear'
        fracFunction = @(tEnd,tStart,numCoolingLoops) (tStart-tEnd)/numCoolingLoops;
        tCurrentFunction = @(frac,tCurrent) tCurrent - frac;
    case 2 %'adaptiveV1'
        fracFunction = @(D_b,D_j,tCurrent) 1.0+((D_b-D_j)/D_b);
        tCurrentFunction = @(frac,tCurrent) frac * tCurrent;
    case 3 %'tanh'
        fracFunction = @(idx) tanh(-idx);
        tCurrentFunction = @(frac,tCurrent,tEnd) tCurrent*frac + tEnd;
    case 4 %'sig'
        fracFunction = @(idx) 1/(1+exp(idx));
        tCurrentFunction = @(frac,tCurrent,tEnd) tCurrent*frac + tEnd;
end