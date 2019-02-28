cityRoute = randperm(10);
g=sprintf('%d ', cityRoute);
fprintf('City route before = %s\n', g);
numCities = size(cityRoute',1);
for i=1:numCities
	randIndex = randi(numCities);
	temp = cityRoute(i);
	cityRoute(i) = cityRoute(randIndex);
	cityRoute(randIndex) = temp;
end
g=sprintf('%d ', cityRoute);
fprintf('City route after  = %s\n', g);


cityRoute = randperm(10);
g=sprintf('%d ', cityRoute);
fprintf('City route before = %s\n', g);
cityRoute = randperm(10);
g=sprintf('%d ', cityRoute);
fprintf('City route after  = %s\n', g);
