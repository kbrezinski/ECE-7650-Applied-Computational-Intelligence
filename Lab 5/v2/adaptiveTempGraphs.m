
numCoolingLoops = [1000,10000];
numEquilbriumLoops = [200,1000];

numEquilbriumLoopsRange = linspace(numEquilbriumLoops(1),numEquilbriumLoops(2),testLength);
numCoolingLoopsRange = linspace(numCoolingLoops(1),numCoolingLoops(2),testLength);

plot(1:1:testLength,numEquilbriumLoopsRange,'r'); hold on
plot(1:1:testLength,numCoolingLoopsRange,'b');
xlabel('Iterations'); ylabel('Loops'); legend('numEquilbriumLoops','numCoolingLoops','location','best');
