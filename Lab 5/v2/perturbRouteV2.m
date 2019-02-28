function [theCityRoute] = perturbRouteV2(numCities,theCityRoute,permValue)

randIndex1 = randi(numCities);
randRange = [randIndex1-permValue,randIndex1+permValue];
idx = find(randRange >= 1 & randRange <= 110);

if length(idx) ~= 1
    if round(rand) == 1
        randIndex2 = randRange(1);
    else
        randIndex2 = randRange(2);
    end
else
    randIndex2 = randRange(idx);
end

if randIndex1 < randIndex2
    permRange = theCityRoute(randIndex1:randIndex2);
    theCityRoute(randIndex1:randIndex2) = permRange(randperm(length(permRange)));
else
    permRange = theCityRoute(randIndex2:randIndex1);
    theCityRoute(randIndex2:randIndex1) = permRange(randperm(length(permRange)));
end
    
end
