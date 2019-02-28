% Import data
x = load('ex3x.dat');
y = load('ex3y.dat');

% Preprocessing
[m,n] = size(x);

sigma = std(x);
mu = mean(x);

x(:,1) = (x(:,1) - mu(1))./ sigma(1);
x(:,2) = (x(:,2) - mu(2))./ sigma(2);
x = [ones(m,1), x];

% Start model

alpha = 0.1;
theta = [1;1;1];
epoch = 100;
err = zeros(epoch,1);

for i = 1:epoch
 
      err(i) = (1/2*m)*((x*theta)-y)'*((x*theta)-y);
      delta = (1/m)*x'*((x*theta)-y);
      theta = theta - alpha*delta;

end

% plot([1:1:epoch],err);

x_space = linspace(-100,100,100)';
axis_space = [min(x(:,2)),max(x(:,2))];
y_pred = ([x_space,x_space,x_space]*theta);

scatter3(x(:,2),x(:,end),y,'r')
hold on
plot3(x_space,x_space,y_pred)
xlim(axis_space)
ylim(axis_space)
