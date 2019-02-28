%clc; clear; close all;
cC = load('EUC_2D_110.txt');
numCities = size(cC,1);
x=cC(1:numCities, 1);
y=cC(1:numCities, 2);
x(numCities+1)=cC(1,1);
y(numCities+1)=cC(1,2);
% Compute distance
D_b=0; 
cR = load('BestCR.txt');
for i=1:numCities-1
	D_b = D_b + sqrt((cC(cR(i),1)-cC(cR(i+1),1))^2 + (cC(cR(i),2)-cC(cR(i+1),2))^2);
end
D_b = D_b + sqrt((cC(cR(numCities),1)-cC(cR(1),1))^2 + (cC(cR(numCities),2)-cC(cR(1),2))^2);
disp(['Best algo   objective: ',num2str(D_b)])

