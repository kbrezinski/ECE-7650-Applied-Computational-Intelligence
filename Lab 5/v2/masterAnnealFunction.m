clc; clear; close all;
dataFile = 'EUC_2D_110.txt';
cC = load(dataFile);
numCities = size(cC,1);
x=cC(1:numCities, 1);
y=cC(1:numCities, 2);
x(numCities+1)=cC(1,1);
y(numCities+1)=cC(1,2);

%% Change the temperature schedule of the iterations
numCoolingLoops = [1000,10000];
numEquilbriumLoops = [100,3000];
pStart = 0.55;   % Probability of accepting worse solution at the start
pEnd = 0.01;   % Probability of accepting worse solution at the end

%0:default, 1:linear, 2:adaptiveV1, 3:adaptive(tanh), 4:adaptive(sig)
tempFunction = [3,3];
testLength = 20;
breakCondition = false; %Set the breakcondition to break early in the equilibrium step
overRideBest = [false,false]; %Allow for the best route to carry over each iteration
customPermRoute = [false,5,0.1]; %Custom perm route inpit

%% Set ranges of the iterations if required
% pStartRange = linspace(pStart,0.5,10);
% pEndRange = linspace(0.5,pEnd,20);
numEquilbriumLoopsRange = linspace(numEquilbriumLoops(1),numEquilbriumLoops(2),testLength);
numCoolingLoopsRange = linspace(numCoolingLoops(1),numCoolingLoops(2),testLength);

BestGlobal = 0;
D_bBest = 0;
cR_Best = [];
customPermRange = round(linspace(numCities/2,1,testLength));

% for m = 1:length(pStartRange)
% for l = 1:length(numEquilbriumLoopsRange)
% for k = 1:length(numCoolingLoopsRange)
% for n = 1:length(pEndRange)
for i = 1:testLength

% pStart = pStartRange(m);
% pEnd = pEndRange(n);
% numEquilbriumLoops = numEquilbriumLoopsRange(l);
% numCoolingLoops = numCoolingLoopsRange(k);
% customPermRoute(2) = customPermRange(i);

if i < 0.9*testLength
    [fracFunction,tCurrentFunction] = tempFunctionSelection(tempFunction(2));
    [D_b,D,tCurrentRange,cR,fracAccepted] = annealEUCFunctionV1(pStart,pEnd,numCoolingLoopsRange(i),numEquilbriumLoopsRange(i),...
        fracFunction,tCurrentFunction,numCities,cC,tempFunction(2),breakCondition,cR_Best,overRideBest(1),customPermRoute);
else
    [fracFunction,tCurrentFunction] = tempFunctionSelection(tempFunction(2));
    [D_b,D,tCurrentRange,cR,fracAccepted] = annealEUCFunctionV1(pStart,pEnd,numCoolingLoopsRange(i),numEquilbriumLoopsRange(i),...
        fracFunction,tCurrentFunction,numCities,cC,tempFunction(2),breakCondition,cR_Best,overRideBest(2),customPermRoute);
end
 
%% Store Optimal Values in Range
if D_bBest == 0 
    D_bBest = D_b;
    cR_Best = cR;
elseif D_bBest > D_b
    D_bBest = D_b;
    cR_Best = cR;
    D_Best = D;
    tCurrentBestRange = tCurrentRange;
    if exist('m') == 1; BestIndex(1,:) = m; end %pStart
    if exist('l') == 1; BestIndex(2,:) = l; end %numEquilib
    if exist('k') == 1; BestIndex(3,:) = k; end %numCooling
    if exist('n') == 1; BestIndex(4,:) = n; end %pEnd 
end
fracAcceptedRange(i) = fracAccepted;

%% Change the end statements
end
% end
% end

%% Determine Optimal parameters to Export
if exist('BestIndex') == 1
    if BestIndex(1) ~= 0
    pStart = pStartRange(BestIndex(1));
    elseif BestIndex(2) ~= 0
    numEquilbriumLoops = numEquilbriumLoopsRange(BestIndex(2));
    elseif BestIndex(3) ~= 0
    numCoolingLoops = numCoolingLoopsRange(BestIndex(3));
    elseif BestIndex(4) ~= 0
    pEnd = pEndRange(BestIndex(4));
    end
end

%Save city route to file
if D_bBest < 47234
fileID = fopen('BestCR.txt','w');
fprintf(fileID,'%6.2f\n',cR);
fclose(fileID);
end

%% Export Into Excel Shee25t
filename = 'testdata.xlsx';
[existData] = xlsread(filename,'Sheet1');
newData = [existData;[pStart,pEnd,numEquilbriumLoops(2),numCoolingLoops(2),tempFunction(2),D_b,length(cC),D_bBest,cR_Best]];
xlswrite(filename,newData,'Sheet1');  % write new data into excel sheet.

%% Plotting the Map
hold off
subplot(2,2,1)
set(0, 'defaultaxesfontname', 'Arial');
set(0, 'defaultaxesfontsize', 14);
plot(D_Best,'r.-')
ylabel('Distance', 'fontsize', 14, 'fontname', 'Arial');
xlabel('Route Number', 'fontsize', 14, 'fontname', 'Arial');
title('Distance vs Route Number', 'fontsize', 16, 'fontname', 'Arial');

%% Plotting the Temp curve
subplot(2,2,2)
set(0, 'defaultaxesfontname', 'Arial');
set(0, 'defaultaxesfontsize', 14);
plot(tCurrentBestRange,'b.-')
ylabel('Temperature', 'fontsize', 14, 'fontname', 'Arial');
xlabel('numCoolingLoops', 'fontsize', 14, 'fontname', 'Arial');
title('Temperature Curve', 'fontsize', 16, 'fontname', 'Arial');

for i=1:numCities
    x(i)=cC(cR(i),1);
    y(i)=cC(cR(i),2);
end

x(numCities+1)=cC(cR(1),1);
y(numCities+1)=cC(cR(1),2);

subplot(2,2,3)
hold on
plot(x',y',...
    'g',...
    'LineWidth',1,...
    'MarkerSize',8,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[1.0,1.0,1.0])
plot(x(1),y(1),...
    'r',...
    'LineWidth',1,...
    'MarkerSize',8,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[1.0,0.0,0.0])
labels = cellstr( num2str([1:numCities]') );  %' # labels correspond to their order
text(x(1:numCities)', y(1:numCities)', labels, 'VerticalAlignment','middle', ...
                             'HorizontalAlignment','center')

%plot(x',y','MarkerSize',24)
ylabel('Y Coordinate', 'fontsize', 18, 'fontname', 'Arial');
xlabel('X Coordinate', 'fontsize', 18, 'fontname', 'Arial');
title('Best City Route', 'fontsize', 20, 'fontname', 'Arial');

subplot(2,2,4)
set(0, 'defaultaxesfontname', 'Arial');
set(0, 'defaultaxesfontsize', 14);
plot(1:1:testLength,fracAcceptedRange*100,'b.-');
ylabel('Percent of iterations kept', 'fontsize', 14, 'fontname', 'Arial');
xlabel('Iterations', 'fontsize', 14, 'fontname', 'Arial');
title('Test', 'fontsize', 16, 'fontname', 'Arial');

