function [theCityRoute] = perturbRoute(numCities, theCityRoute)
    randIndex1 = randi(numCities);
    alreadyChosen = true;
    while alreadyChosen == true
        randIndex2 = randi(numCities);
        if randIndex2 ~= randIndex1
            alreadyChosen = false;
        end
    end
    dummy = theCityRoute(randIndex1);
    theCityRoute(randIndex1) = theCityRoute(randIndex2);
    theCityRoute(randIndex2) = dummy;
end
