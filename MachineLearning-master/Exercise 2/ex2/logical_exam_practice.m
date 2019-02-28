clear ; close all; clc

%% Load Data
%  The first two columns contains the X values and the third column
%  contains the label (y).
data = load('ex2data2.txt');
X = data(:,(1:2));
y = data(:,3);

positive = find(y == 1);
negative = find(y == 0);
plot(X(positive, 1), X(positive, 2), 'k+', 'LineWidth', 2, 'MarkerSize', 7); hold on
plot(X(negative, 1), X(negative, 2), 'ko', 'MarkerFaceColor', 'y', 'MarkerSize', 7);

% Put some labels 
hold on; xlabel('Microchip Test 1'); ylabel('Microchip Test 2')
% Specified in plot order
legend('y = 1', 'y = 0');

% MAPFEATURE Feature mapping function to polynomial features
%
%   MAPFEATURE(X1, X2) maps the two input features
%   to quadratic features used in the regularization exercise.
%
%   Returns a new feature array with more features, comprising of 
%   X1, X2, X1.^2, X2.^2, X1*X2, X1*X2.^2, etc..
%
%   Inputs X1, X2 must be the same size
% 
degree = 6;
epoch = 1000;
out = ones(size(X(:,1)));
for i = 1:degree
    for j = 0:i
        out(:, end+1) = (X(:,1).^(i-j)).*(X(:,2).^j);
    end
end

X = out;

theta = zeros(size(X, 2), 1);
lambda = 1;
alpha = 1;
% Initialize some useful values
m = length(y); % number of training examples
grad = zeros(size(theta));
sigmoid = @(z) 1./(1+exp(-z));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta
for i = 1:epoch
    thetaT = theta;
    correction = (lambda/(2*m)) * sum(thetaT(2:end).^2);
    
    J(i) = (1/m) .* (-y' * log(sigmoid(X*thetaT)) - (1-y)' * log(1-sigmoid(X*thetaT))) + correction;
    grad = (X' * (sigmoid(X * thetaT) - y)) * (1/m) + thetaT * (lambda/m);
    
    theta = theta - (alpha .* grad);
end

u = linspace(-1, 1.5, 50);
v = linspace(-1, 1.5, 50);

z = zeros(length(u), length(v));
for i = 1:length(u)
    for j = 1:length(v)
        z(i,j) = mapFeature(u(i), v(j))*theta;
    end
end
z = z'; % important to transpose z before calling contour

% Plot z = 0
% Notice you need to specify the range [0, 0]
contour(u, v, z, [0, 0], 'LineWidth', 2)

