cityRoute = randperm(5);
randIndex1 = randi(5);
alreadyChosen = true;
while alreadyChosen == true
	randIndex2 = randi(5);
	if randIndex2 ~= randIndex1
		alreadyChosen = false;
	end
end
fprintf('Random index 1 = %d\n', randIndex1);
fprintf('Random index 2 = %d\n', randIndex2);

g=sprintf('%d ', cityRoute);
fprintf('City route before = %s\n', g);
dummy = cityRoute(randIndex1);
cityRoute(randIndex1) = cityRoute(randIndex2);
cityRoute(randIndex2) = dummy;
g=sprintf('%d ', cityRoute);
fprintf('City route after  = %s\n', g);
