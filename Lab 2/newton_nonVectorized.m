function [final_theta] = newton_nonVectorized(epoch_length)

x = load('ex4x.dat');
y = load('ex4y.dat');

[x_rows,x_columns] = size(x);
theta = zeros(epoch_length,x_columns+1);
x = [ones(x_rows,1), x];
g = ones(x_rows,1);

sigmoid = @(z) 1.0 /(1.0 + exp(-z));

for epoch = 1:epoch_length
    
    %% Compute the Gradient
    
    for features = 1:x_columns+1
        
        delta_J = 0;
        delta2_J = 0;
        
        for sample = 1:x_rows 
            z = 0;
            x_j = 0;
            for feature = 1:x_columns+1
                z = z + (theta(epoch,feature) * x(sample,feature));
                x_j = x_j + x(sample,feature)^2;
            end
        
            delta_J = delta_J + ((sigmoid(z) - y(sample)) * x(sample,features));  
            delta2_J = delta2_J + sigmoid(z)*(1-sigmoid(z))*sqrt(x_j)*x(sample,features);
        
        end
        
        theta(epoch+1,features) = theta(epoch,features) - delta_J/delta2_J;
    end
end
    final_theta = theta(end,:);
end
    
    

