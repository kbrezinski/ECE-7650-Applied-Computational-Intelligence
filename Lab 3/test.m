import neural_network.*

format longE
%%Pre-amble
x = [0,0; 0,1; 1,0; 1,1];
y = [1;0;0;1];

%%object = neural_network(input_layer,hidden_neurons,features,target,learning_rate,max_epochs,Logistic=false,TestingSet=false)
obj = neural_network(2,3,x,y,1,3000,true,false);
[error,final_weights,final_activations,random_set] = gradient_descent(obj);
plot_graph(obj,error);

% [] = gradient_descent(obj,x)
