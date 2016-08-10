%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) Pedro Antonio Gutiérrez (pagutierrez at uco dot es)
% María Pérez Ortiz (i82perom at uco dot es)
% Javier Sánchez Monedero (jsanchezm at uco dot es)
%
% This file implements the code for the NPSVOR method.
% 
% The code has been tested with Ubuntu 12.04 x86_64, Debian Wheezy 8, Matlab R2009a and Matlab 2011
% 
% If you use this code, please cite the associated paper
% Code updates and citing information:
% http://www.uco.es/grupos/ayrna/orreview
% https://github.com/ayrna/orca
% 
% AYRNA Research group's website:
% http://www.uco.es/ayrna 
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 3
% of the License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA. 
% Licence available at: http://www.gnu.org/licenses/gpl-3.0.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef NPSVOR < Algorithm
    %NPSVOR: Nonparallel Support Vector Ordinal Regression
    
    properties
       
        name_parameters = {'C','e','k','rho'}

        parameters
    end
    
    methods
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Function: NPSVOR (Public Constructor)
        % Description: It constructs an object of the class
        %               NPSVOR Ordinal and sets its characteristics.
        % Type: Void
        % Arguments: 
        %           kernel--> Type of Kernel function
        % 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function obj = NPSVOR(kernel)
            obj.name = 'NPSVOR: Nonparallel Support Vector Ordinal Regression';
            if(nargin ~= 0)
                 obj.kernelType = kernel;
            else
                obj.kernelType = 'rbf';
            end
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Function: defaultParameters (Public)
        % Description: It assigns the parameters of the 
        %               algorithm to a default value.
        % Type: Void
        % Arguments: 
        %           No arguments for this function.
        % 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function obj = defaultParameters(obj)
            obj.parameters.C = 10.^(-3:1:3);
	    % kernel width
            obj.parameters.k = 10.^(-3:1:3);
            obj.parameters.e = 0.1;
            obj.parameters.rho = 1;
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Function: runAlgorithm (Public)
        % Description: This function runs the corresponding
        %               algorithm, fitting the model and 
        %               testing it in a dataset.
        % Type: It returns the model (Struct) 
        % Arguments: 
        %           Train --> Training data for fitting the model
        %           Test --> Test data for validation
        %           parameters --> vector with the parameter information
        % 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function [model_information] = runAlgorithm(obj,train, test, parameters)
                param.C = parameters(1);
                param.k = parameters(2);
                param.e = parameters(3);
                param.rho =1;
                
                train.uniqueTargets = unique([train.targets]);
                test.uniqueTargets = train.uniqueTargets;
                train.nOfClasses = max(train.uniqueTargets);
                test.nOfClasses = train.nOfClasses;
                train.nOfPatterns = length(train.targets);
                test.nOfPatterns = length(test.targets);                
                
                c1 = clock;
                model = obj.train(train, param);
                c2 = clock;
                model_information.trainTime = etime(c2,c1);
                
                c1 = clock;
                [model_information.projectedTrain, model_information.predictedTrain] = obj.test(train,train, model,param);
                [model_information.projectedTest,model_information.predictedTest ] = obj.test(train, test,model,param);
                c2 = clock;
                model_information.testTime = etime(c2,c1);
                           
                model.algorithm = 'NPSVOR';
                model.parameters = param;
                model_information.model = model;

        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Function: train (Public)
        % Description: This function train the model for
        %               the NPSVOR algorithm.
        % Type: It returns the model
        % Arguments: 
        %           train --> Train struct
        %           param--> struct with the parameter information
        % 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        function [model]= train( obj, train, param)  
            
            H=Kernel( obj.kernelType, train.patterns',train.patterns', param.k);
            n = train.nOfPatterns;
           % A = [ H + param.rho*eye(n)]\speye(n);
            A = invChol_mex(H + param.rho*eye(n));
%             for k = 1:train.nOfClasses 
% %                 eta = sum(train.targets==k)/sum(train.targets~=k);
%                 eta=1;
%                 [Beta(:,k),b(k)] =  NonlinearNPSVOR(H, A, train.targets,k,param.C, eta*param.C, train.nOfPatterns, param.e, param.rho);
%             end
            [Beta,b] = NonlinearNPSVOR(H, A, train.targets,param.C, param.C, train.nOfPatterns, param.e, param.rho);
            model.Beta = Beta; 
            model.b = b;
            model.labelSet = unique(train.targets);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Function: test (Public)
        % Description: This function test a model given in
        %               a set of test patterns.
        % Outputs: Two arrays (decision values and predicted targets)
        % Arguments: 
        %           test --> Test struct data
        %           model --> struct with the model information
        % 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function [decv, pred]= test(obj, train, test,model,param)
          nT=test.nOfPatterns;  
          decv= zeros(nT,train.nOfClasses);         
          if nT >1000
              for j=1:nT/1000
                  xnewk=test.patterns(1000*(j-1)+1:1000*j,:);
                  decv(1000*(j-1)+1:1000*j,:) = -Kernel(obj.kernelType, xnewk',train.patterns',param.k)* model.Beta+ ones(size(xnewk,1),1)*model.b;
              end
              xnewk=test.patterns(1000*j+1:nT,:);
              decv(1000*j+1:nT,:)= -Kernel(obj.kernelType, xnewk',train.patterns',param.k)*model.Beta+ ones(size(xnewk,1),1)*model.b;
          else
              decv =  -Kernel(obj.kernelType, test.patterns',train.patterns',param.k)*model.Beta+ ones(nT,1)*model.b;
          end
          [~,pred] = min(abs(decv),[],2);
          pred = model.labelSet(pred);
          
        end
    end
end
