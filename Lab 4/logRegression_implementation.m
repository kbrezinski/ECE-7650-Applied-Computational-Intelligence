clc; clear
%%Pre-amble
import logical_object.*
addpath('./libsvm-3.23/libsvm-3.23/matlab/');

%% Load Dataset
filestr = fileread('ex7Data/twofeature.txt');

%% Preprocessing
[a,b] = strsplit(filestr,{'1 1:',' 2:'},'CollapseDelimiters',true);
a = a(2:end); a = reshape(a,2,50)';...
a = strip(a,'right','-'); x = str2double(a);
y = [ones(20,1);zeros(30,1)];

%% Logical Regression
obj = logical_object(x,y,10);
tic;
[final_theta,err] = newton_vectorized(obj);
toc;
plot_graph(obj,final_theta,err);

%% Center of Gravity
pos = find(y == 1);
neg = find(y == 0);

[idx,C_pos] = kmeans(x(pos,:),1);[idx,C_neg] = kmeans(x(neg,:),1);

% Plot Centroids
plot(C_pos(1),C_pos(2),'r*'); plot(C_neg(1),C_neg(2),'r*')
% Midline
line([C_neg(1),C_pos(1)],[C_neg(2),C_pos(2)],'LineStyle','--','Color','k');
% Midline Point
plot((C_neg(1)+C_pos(1))/2, (C_neg(2)+C_pos(2))/2,'m*');
title('Centroid and midline determination w/overlapped decision boundary');

legend('positive','negative','Decision Boundary','pos centroid'...
    ,'neg centroid','midline','center of midline','location','best');

%% Random cluster of data
figure
cluster_x = (42-38).*rand(1000,1) + 38;
cluster_y = (52-48).*rand(1000,1) + 48;
scatter(cluster_x,cluster_y,'ko'); hold on
plot_graph(obj,final_theta,err); xlim([0,40]);ylim([0,50])
title('Dataset including cluster and twofeature.txt dataset');
hold off

%% Preprocessing by adding new clustter on new data
x = [x;[cluster_x,cluster_y]];
y = [y;ones(1000,1)];
 
model = svmtrain(y, x, '-s 0 -t 0 -c 10E9');

w = model.SVs' * model.sv_coef;
b = -model.rho;
if (model.Label(1) == -1)
    w = -w; b = -b;
end

% Plot the data points
figure
pos = find(y == 1);
neg = find(y == 0);
plot(x(pos,1), x(pos,2), 'ko', 'MarkerFaceColor', 'b'); hold on;
plot(x(neg,1), x(neg,2), 'ko', 'MarkerFaceColor', 'g')

% Plot the decision boundary
plot_x = linspace(min(x(:,1)), max(x(:,1)), 30);
plot_y = (-1/w(2))*(w(1)*plot_x + b);
plot(plot_x, plot_y, 'k-', 'LineWidth', 2); hold off;
xlim([0.5,4.5]); ylim([1.5,5]); xlabel('feature 1'); ylabel('feature 2');
title('SVM implementation on twofeature.txt + cluster dataset');

fprintf('\n Optimal b: %0.2f \n',b)
fprintf('Optimal w: %0.2f,%0.2f',w)
