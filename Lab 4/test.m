%% Pre-amble

[y, x] = libsvmread('ex7Data/twofeature.txt');

%% -s (SVM classification); -t (a linear kernel); -c (a cost factor of 1)
model = svmtrain(trainlabels, trainfeatures, '-s 0 -t 0 -c 10E9');

w = model.SVs' * model.sv_coef;
b = -model.rho;
if (model.Label(1) == -1)
    w = -w; b = -b;
end

% Plot the data points
figure
pos = find(y == 1);
neg = find(y == -1);
plot(x(pos,1), x(pos,2), 'ko', 'MarkerFaceColor', 'b'); hold on;
plot(x(neg,1), x(neg,2), 'ko', 'MarkerFaceColor', 'g')

% Plot the decision boundary
plot_x = linspace(min(x(:,1)), max(x(:,1)), 30);
plot_y = (-1/w(2))*(w(1)*plot_x + b);
plot(plot_x, plot_y, 'k-', 'LineWidth', 2)

fprintf('Optimal b: %0.2f \n',b)
fprintf('Optimal w: %0.2f,%0.2f',w)