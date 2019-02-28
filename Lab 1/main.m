
function main
    %{
    Args: 
        alpha: 'int' setting the learning rate
        epoch: 'int' setting the number of epochs 
        batch_size: 'int' setting the min-batch size (default is batch)
    
    Returns: 
        new_theta: matrix of theta values
        %}
import regressor_object.*

%% Load Data
x = load('ex2x.dat');
y = load('ex2y.dat');
z = dlmread('d2noisy.txt'); %

%% Uncomment if using 'd2noisy.txt'
    x = z(:,1:2)
    y = z(:,end)

%%[object] = regressor_object(features,target,learning_rate,epochs)
    a = regressor_object(x,y,0.07,500);
    
%%[final_theta,cost] = linear_regressor(object,mini_batch_size)
    [final_theta,err]= linear_regressor(a,length(x)); %length(x) for batch

%%Plot regression and cost
    plot_graph(a,final_theta,err)

%%Use this output for total error after 500,000 iterations (set epochs in regressor object to 500,000)
fprintf('Total error after 500,000 epochs:%f',err(end))
       
end

