clear;clc;close all
format long
x = load('ex4x.dat');
y = load('ex4y.dat');

pos = find(y==1);
neg = find(y==0);
[m,n] = size(x);

x = [ones(m,1),x];
theta = ones(n+1,1);
alpha = 0.003;
epoch = 1000;
g = @(z) 1 ./(1.0+exp(-z));

for i = 1:epoch
    
    h = g(x * theta);
    delta = (1/m) .* (x' * (h-y));
    theta = theta - (alpha .* delta);
%     cost(i) = h - y;
    cost(i) = (1/m) .* (-y' * log(h) - (1-y)' * log(1-h));
    
end

subplot(1,2,1)
plot(1:1:epoch,cost)

subplot(1,2,2)
scatter(x(neg,2),x(neg,3)); hold on; scatter(x(pos,2),x(pos,3))
plot([0,80],[-(theta(1)+(0*theta(2)))/theta(3),-(theta(1)+80*theta(2))/theta(3)])