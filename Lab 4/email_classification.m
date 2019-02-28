clc; clear;
%% Pre-amble
addpath('./libsvm-3.23/libsvm-3.23/matlab/');
[y, x] = libsvmread('ex7Data/email_train-all.txt');

%% -s (SVM classification); -t (a linear kernel); -c (a cost factor of 1)

model = svmtrain(y, x, '-t 0');

w = model.SVs' * model.sv_coef;
b = -model.rho;
if (model.Label(1) == -1)
    w = -w; b = -b;
end

[y, x] = libsvmread('ex7Data/email_test.txt');
[predicted_label,accuracy] = svmpredict(y, x, model)