clearvars -except theCityRouteCopy

numCities = 110;
Range = 2;

randIndex1 = randi(numCities);
randRange = [randIndex1-Range,randIndex1+Range];
idx = find(randRange >= 1 & randRange <= 110);

if length(idx) ~= 1
    if round(rand == 1)
        randIndex2 = randRange(1);
    else
        randIndex2 = randRange(2);
    end
else
    randIndex2 = randRange(idx);
end

if randIndex1 < randIndex2
    permRange = theCityRouteCopy(randIndex1:randIndex2);
    theCityRouteCopy(randIndex1:randIndex2) = permRange(randperm(length(permRange)));
else
    permRange = theCityRouteCopy(randIndex2:randIndex1);
    theCityRouteCopy(randIndex2:randIndex1) = permRange(randperm(length(permRange)));
end
