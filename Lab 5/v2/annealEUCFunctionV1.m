function [D_b,D,tCurrentRange,cR,fracAccepted] = annealEUCFunctionV1(pStart,pEnd,numCoolingLoops,numEquilbriumLoops,...
    fracFunction,tCurrentFunction,numCities,cC,tempFunction,breakCondition,cR_Best,overRideBest,customPermRoute)

tStart = -1.0/log(pStart);  % Initial temperature
tEnd = -1.0/log(pEnd);  % Final temperature
idx = linspace(0,4,numCoolingLoops); % Set the boundaries for tanh/sig Temp function
% frac = fracFunction(tEnd,tStart,numCoolingLoops); % Fractional reduction per cycle // can change this cycle

if isempty(cR_Best) || overRideBest == false
    cityRoute_i = randperm(numCities); % Get initial route
else
    cityRoute_i = cR_Best;
end

cityRoute_b = cityRoute_i;
cityRoute_j = cityRoute_i;
cityRoute_o = cityRoute_i;

% Initial distances
D_j = computeEUCDistance(numCities, cC, cityRoute_i);
D_o = D_j; D_b = D_j; D(1) = D_j;
numAcceptedSolutions = 1.0;
tCurrent = tStart; % Current temperature = initial temperature
DeltaE_avg = 0.0; % DeltaE Average

for i=1:numCoolingLoops
%     disp(['Cycle: ',num2str(i),' starting temperature: ',num2str(tCurrent)])
    
    for j=1:numEquilbriumLoops
        
        if (customPermRoute(1) == true) && (rand(1) < (customPermRoute(3)-(0.001*numAcceptedSolutions)))
            cityRoute_j = perturbRouteV2(numCities,cityRoute_b,customPermRoute(2));
        else
            cityRoute_j = perturbRoute(numCities,cityRoute_b);
        end
        D_j = computeEUCDistance(numCities,cC,cityRoute_j);
        DeltaE = abs(D_j-D_b);
        
        if (D_j > D_b) % objective function is worse
            
            if (i==1 && j==1) DeltaE_avg = DeltaE; end
            p = exp(-DeltaE/(DeltaE_avg * tCurrent));
            
            if (p > rand()) accept = true; else accept = false; end
        else accept = true; % objective function is better
        end
        
        if (accept==true)
            cityRoute_b = cityRoute_j;
            D_b = D_j;
            numAcceptedSolutions = numAcceptedSolutions + 1.0;
            DeltaE_avg = (DeltaE_avg * (numAcceptedSolutions-1.0) + ... 
                                            DeltaE) / numAcceptedSolutions;
        end
    end
  
    switch tempFunction
        case {0,1}
            frac = fracFunction(tEnd,tStart,numCoolingLoops);
            tCurrent = tCurrentFunction(frac,tCurrent);
        case 2
            frac = fracFunction(D_b,D_j,tCurrent); % Adaptive Temp cycle
            tCurrent = tCurrentFunction(frac,tCurrent);
        case {3,4}
            frac = fracFunction(idx(i)); % Adaptive tanh/sig Temp cycle 
            tCurrent = tCurrentFunction(frac,tCurrent,tEnd);
    end
    
    tCurrentRange(i) = tCurrent;
    cityRoute_o = cityRoute_b;  % Update optimal route at each cycle
    D(i+1) = D_b; %record the route distance for each temperature setting
    D_o = D_b; % Update optimal distance
    
    if breakCondition == true
        if i~=1
            if (abs(D(i)-D(i-1))/D(i-1) < 1E-7); break; end
        end
    end

end %end numCoolingLoops

% Print solution
% disp(['Best solution: ',num2str(cityRoute_o)])

% Compute distance
D_b=0; cR = cityRoute_o;

for i=1:numCities-1
	D_b = D_b + sqrt((cC(cR(i),1)-cC(cR(i+1),1))^2 + (cC(cR(i),2)-cC(cR(i+1),2))^2);
end

D_b = D_b + sqrt((cC(cR(numCities),1)-cC(cR(1),1))^2 + (cC(cR(numCities),2)-cC(cR(1),2))^2);
fracAccepted = numAcceptedSolutions/(numCoolingLoops*numEquilbriumLoops);

end
