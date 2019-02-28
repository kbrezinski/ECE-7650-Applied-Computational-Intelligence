clear;clc
format long
x = load('ex4x.dat');
y = load('ex4y.dat');

pos = find(y==1);
neg = find(y==0);
[m,n] = size(x);

theta = [0;0;0];
x = [ones(m,1),x];
alpha = 0.001;
epoch = 1000;
lambda = 1;
g = @(z) 1.0./(1.0 + exp(-z));

for i = 1:epoch
    
%     z = x * theta;
    h = g(x * theta);
    delta = (1/m) .* (x' * (h-y));
    theta = theta - (alpha .* delta);
    
    cost(i) = (1/m) .* (-y' * log(h) - (1-y') * log(1-h)) + lambda/(2*m) .* sum(theta(2:end).^2);
    
end

subplot(1,2,1)

plot(1:1:epoch,cost)
subplot(1,2,2)
scatter(x(pos,2),x(pos,3)); hold on;
scatter(x(neg,2),x(neg,3));
plot([0,80],[-theta(1)/theta(3),-(theta(1)+80*theta(2))/theta(3)])