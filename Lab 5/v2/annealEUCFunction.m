clc; clear; close all;
dataFile = 'EUC_2D_100.txt';
cC = load(dataFile);
numCities = size(cC,1);
x=cC(1:numCities, 1);
y=cC(1:numCities, 2);
x(numCities+1)=cC(1,1);
y(numCities+1)=cC(1,2);

% figure
% hold on
% plot(x',y','.k','MarkerSize',14)
% labels = cellstr( num2str([1:numCities]') );  %' # labels correspond to their order
% text(x(1:numCities)', y(1:numCities)', labels, 'VerticalAlignment','bottom', ...
%                              'HorizontalAlignment','center');
% ylabel('Y Coordinate', 'fontsize', 18, 'fontname', 'Arial');
% xlabel('X Coordinate', 'fontsize', 18, 'fontname', 'Arial');
% title('City Coordinates', 'fontsize', 20, 'fontname', 'Arial');

%% Change the temperature schedule of the iterations
numCoolingLoops = 1000;
numEquilbriumLoops = 50;
pStart = 0.90;   % Probability of accepting worse solution at the start
pEnd = 0.01;   % Probability of accepting worse solution at the end
tempFunction = 0; %0:default, 1:linear, 2:adaptive

%% Set ranges of the iterations if required
pStartRange = linspace(pStart,pEnd,10);
pEndRange = linspace(0.5,pEnd,10);
numEquilbriumLoopsRange = linspace(2000,100,10);
numCoolingLoopsRange = linspace(numCoolingLoops,numEquilbriumLoops,10);
BestGlobal = 0;

%% Anonymous Temperature Function

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
    case 3 %'adaptiveV2'
        fracFunction = @(D_b,D_j,tCurrent)(1.0+((D_b-D_j)/D_b));
        tCurrentFunction = @(frac,tCurrent) frac * tCurrent;
end


for m = 1:length(pStartRange)
for l = 1:length(numEquilbriumLoopsRange)
% for k = 1:length(numCoolingLoopsRange)
% for n = 1:length(pEndRange)

if m == 1
    numEquilbriumLoops = numEquilbriumLoopsRange(l);
else
    numEquilbriumLoops = numEquilbriumLoopsRange(b);
end
% pEnd = pEndRange(n);
% numEquilbriumLoops = numEquilbriumLoopsRange(l);
% numCoolingLoops = numCoolingLoopsRange(k);

% %% Overide the parameters
% pStart = pStartRange(6);
% numEquilbriumLoops = numEquilbriumLoopsRange(5);
% numCoolingLoops = numCoolingLoopsRange(5);

tStart = -1.0/log(pStart);  % Initial temperature
tEnd = -1.0/log(pEnd);  % Final temperature
frac = fracFunction(tEnd,tStart,numCoolingLoops); % Fractional reduction per cycle // can change this cycle

cityRoute_i = randperm(numCities); % Get initial route
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
        
        cityRoute_j = perturbRoute(numCities, cityRoute_b); %% Can change the way the initial route is perturbed
        D_j = computeEUCDistance(numCities, cC, cityRoute_j);
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
        
    if tempFunction == 2
        frac = fracFunction(D_b,D_j,tCurrent); % Adaptive Temp cycle
    end
    
    tCurrent = tCurrentFunction(frac,tCurrent); % Lower the temperature for next cycle
    
    tCurrentRange(i) = tCurrent;
    cityRoute_o = cityRoute_b;  % Update optimal route at each cycle
    D(i+1) = D_b; %record the route distance for each temperature setting
    D_o = D_b; % Update optimal distance

    if i~=1
        if (abs(D(i)-D(i-1))/D(i-1) < 1E-6); break; end
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

%% Store Optimal Values in Range
D_bRange(m,l) = D_b;

% if exist('m') == 1; BestIndex(1,:) = b; end %pStart
% if exist('l') == 1; BestIndex(2,:) = b; end %numEquilib
% if exist('k') == 1; BestIndex(3,:) = b; end %numCooling
% if exist('n') == 1; BestIndex(4,:) = b; end %pEnd

%% Change the end statements
end

[a,b] = min(D_bRange(m,:));

end
% end

% if (BestGlobal(j) >= BestGlobal(j-1)) && (j ~= 1) 

% disp(['Best algo   objective: ',num2str(D_b)])
% disp(['Best global objective: ',num2str(D_o)])

% %Save city route to file
% fileID = fopen('BestCR.txt','w');
% fprintf(fileID,'%6.2f\n',cR);
% fclose(fileID);

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

%% Export Into Excel Sheet
filename = 'testdata.xlsx';
[existData] = xlsread(filename,'Sheet2');
newData = [existData;[pStart,pEnd,numEquilbriumLoops,numCoolingLoops,tempFunction,D_b,length(cC)]];
xlswrite(filename,newData,'Sheet2');  % to write new data into excel sheet.

%% Plotting the Map
hold off
subplot(2,2,1)
set(0, 'defaultaxesfontname', 'Arial');
set(0, 'defaultaxesfontsize', 14);
plot(D,'r.-')
ylabel('Distance', 'fontsize', 14, 'fontname', 'Arial');
xlabel('Route Number', 'fontsize', 14, 'fontname', 'Arial');
title('Distance vs Route Number', 'fontsize', 16, 'fontname', 'Arial');

%% Plotting the Temp curve
subplot(2,2,2)
set(0, 'defaultaxesfontname', 'Arial');
set(0, 'defaultaxesfontsize', 14);
plot(tCurrentRange,'b.-')
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


