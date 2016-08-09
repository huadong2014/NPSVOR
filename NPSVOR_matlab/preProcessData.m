function [trainSet, testSet] = preProcessData(trainSet,testSet)


[trainSet, testSet] = deleteConstantAtributes(trainSet,testSet);
[trainSet, testSet] = standarizeData(trainSet,testSet);
%[trainSet, testSet] = obj.scaleData(trainSet,testSet);
[trainSet, testSet] = deleteNonNumericValues(trainSet, testSet);

end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Function: standarizeData (static)
        % Description: standarize a set of training and testing
        %               patterns.
        % Type: It returns the standarized patterns (train and test)
        % Arguments: 
        %           trainSet--> Array of training patterns
        %           testSet--> Array of testing patterns
        % 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function [trainSet, testSet] = standarizeData(trainSet,testSet)
                     [trainSet.patterns, trainMeans, trainStds] = standarizeFunction(trainSet.patterns);
                     testSet.patterns = standarizeFunction(testSet.patterns,trainMeans,trainStds);
        end
        
        function [trainSet, testSet] = scaleData(trainSet,testSet)
                    for i = 1:size(trainSet.patterns,1)
                        for j = 1:size(trainSet.patterns,2)
                            trainSet.patterns(i,j) = 1/(1+exp(-trainSet.patterns(i,j)));
                        end
                    end
                    for i = 1:size(testSet.patterns,1)
                        for j = 1:size(testSet.patterns,2)
                            testSet.patterns(i,j) = 1/(1+exp(-testSet.patterns(i,j)));
                        end
                    end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Function: deleteNonNumericalValues (static)
        % Description: This function deletes non numerical
        %               values in the data, as NaN or Inf.
        % Type: It returns the patterns without non numerical
        %               values (train and test)
        % Arguments: 
        %           trainSet--> Array of training patterns
        %           testSet--> Array of testing patterns
        % 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function [trainSet, testSet] = deleteNonNumericValues(trainSet,testSet)
                
                [fils,cols]=find(isnan(trainSet.patterns) | isinf(trainSet.patterns));
                cols = unique(cols);
                for a = size(cols):-1:1,
                    trainSet.patterns(:,cols(a)) = [];
                end

                [fils,cols]=find(isnan(trainSet.targets) | isinf(trainSet.targets));
                cols = unique(cols);
                for a = size(cols):-1:1,
                    trainSet.patterns(:,cols(a)) = [];
                end
                
                [fils,cols]=find(isnan(testSet.patterns) | isinf(testSet.patterns));
                cols = unique(cols);
                for a = size(cols):-1:1,
                    testSet.patterns(:,cols(a)) = [];
                end

                [fils,cols]=find(isnan(testSet.targets) | isinf(testSet.targets));
                cols = unique(cols);
                for a = size(cols):-1:1,
                    testSet.patterns(:,cols(a)) = [];
                end

        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Function: deleteConstantAtributes (static)
        % Description: This function deletes constant 
        %               atributes.
        % Type: It returns the patterns without this constant attributes
        % Arguments: 
        %           trainSet--> Array of training patterns
        %           testSet--> Array of testing patterns
        % 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function [trainSet,testSet] = deleteConstantAtributes(trainSet, testSet)
                
                all = [trainSet.patterns ; testSet.patterns];
                
                minvals = min(all);
                maxvals = max(all);

                r = 0;
                for k=1:size(trainSet.patterns,2)
                    if minvals(k) == maxvals(k)
                        r = r + 1;
                        index(r) = k;
                    end
                end

                if r > 0
                    r = 0;
                    for k=1:size(index,2)
                        trainSet.patterns(:,index(k)-r) = [];
                        testSet.patterns(:,index(k)-r) = [];
                        r = r + 1;
                    end
                end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Function: standarizeFunction (static)
        % Description: Function for data standarization.
        % Type: It returns the standardized patterns (XN), 
	%	the mean (Xmeans) and the standard deviation (XStds)
        % Arguments: 
        %           X--> data
        %           XMeans--> Data mean (optional)
	%	    XStds --> Standard deviation for the data (optional)
        % 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	function [XN, XMeans, XStds] = standarizeFunction(X,XMeans,XStds)

		if (nargin<3) 
		    XStds = std(X);
		end
		if (nargin<2) 
		    XMeans = mean(X);
		end
		XN = zeros(size(X));
		for i=1:size(X,2)
		    XN(:,i) = (X(:,i) - XMeans(i)) / XStds(i);
		end
    end