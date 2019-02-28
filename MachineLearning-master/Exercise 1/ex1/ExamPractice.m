clear all;clc;

%% Load Data
data = load('ex1data2.txt');
X = data(:,1:2);
y = data(:,3);
m = length(y);

% Scale features and set them to zero mean

X_norm = X;
mu = zeros(1, size(X, 2));
sigma = zeros(1, size(X, 2));

for i = 1:size(X, 2)
	mu(:,i) = mean(X_norm(:,i));
	sigma(:,i) = std(X_norm(:,i));
	X_norm(:,i) = (X_norm(:,i) - mu(:,i)) / sigma(:,i);
end

% Make predictions in linear regression
prediction = [1 1650 3];
price = prediction * theta;

     