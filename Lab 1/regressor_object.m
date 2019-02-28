classdef regressor_object

    properties
        alpha=0;
        epoch=0;
        feature=[];
        target=[];
    end
    
    methods 
        
        function self = regressor_object(feature,target,alpha,epoch)
            
            self.feature = feature;
            self.target = target;
            
            if (isnumeric(alpha)) && (alpha~=0)
                self.alpha=alpha;
            else
                self.alpha=0.05; %Default to 0.05
            end
            if (isnumeric(epoch)) && (epoch~=0)
                self.epoch=epoch;
            else
                self.epoch=1500; %Default to 1500
            end
        end 
        
        function [final_theta, err] = linear_regressor(obj,batch_size)
            
            period = obj.epoch/10;
            [m,n] = size(obj.feature);
            new_features = [ones(m,1), obj.feature];
            theta = ones(obj.epoch,n+1);%*mean(obj.feature(:,1))*100;  
            err = zeros(obj.epoch,1);
            
            for i = 1:obj.epoch
            
                for j = 1:(n+1)
                 
                Eucl = (sum((theta(i,:)*new_features')',2)-obj.target);
                
                err(i) = ((1/(2*m))*(sum(Eucl.^2)));
                    
                theta(i+1,j) = theta(i,j)-(obj.alpha*(1/batch_size)...
                    *sum(Eucl.*new_features(:,j))); 
                
                end
                
                if (mod(i,period) == 0)
                fprintf('Epoch %2d: current theta values: %.2d, %.2d, \n %.2d. \n',...
                    i,theta(i,:));
                
                end 
           
            end
            
        final_theta = theta(end,:);
        
        end
        
        function plot_graph(obj,theta,err)

%             fontSize = 20;
            
            subplot(1,2,1)
            if length(theta) == 3
                
                x_space = linspace(-100,100,100)';
                axis_space = [min(obj.feature(:,1)),max(obj.feature(:,1))]
                
                y_pred = sum(([x_space,x_space,x_space]*theta'),2);
                
                plot3(x_space,x_space,y_pred,'k--')           
                hold on
                scatter3(obj.feature(:,1),obj.feature(:,end),obj.target,'r')
                xlabel('feature_1')
                ylabel('feature_2')
                zlabel('target')
                xlim([min(obj.feature(:,1)),max(obj.feature(:,1))])
                ylim([min(obj.feature(:,2)),max(obj.feature(:,2))])
                zlim([min(obj.target),max(obj.target)])
                legend('Regression','Training Data','location','best')
                
            elseif length(theta) == 2
            
                plot(obj.feature,((obj.feature.*theta(end,end))...
                    +theta(end,1)),'k')
                hold on
                scatter(obj.feature,obj.target,'r')
                xlabel('feature_1')
                ylabel('target')
                legend('Regression','Training Data','location','best')
             
            else
            end
%             colors = {'r','g','b'}
            
            subplot(1,2,2)
            plot(1:1:obj.epoch,err,'b')
            xlabel('epoch')
            ylabel('J_{\theta}')
            legend('Cost','location','best')
            
        end   
        
    end
    

end