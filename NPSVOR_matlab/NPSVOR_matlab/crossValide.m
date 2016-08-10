      function optimals = crossValide(obj,train)
             nOfFolds = obj.nOfFolds;
             parameters = obj.parameters;
            % obj.method= obj.method;
            % obj.cvCriteria.

            par = fieldnames(parameters);
            
            combinations = getfield(parameters,par{1});
            
            for i=1:(numel(par)-1),
                if i==1,
                    aux1 = getfield(parameters, par{i});
                else
                    aux1 = combinations;
                end
                aux2 = getfield(parameters, par{i+1});
                combinations = combvec(aux1,aux2);
            end
            
            % Avoid problems with very low number of patterns for some
            % classes
            uniqueTargets = unique(train.targets);
            nOfPattPerClass = sum(repmat(train.targets,1,size(uniqueTargets,1))==repmat(uniqueTargets',size(train.targets,1),1));
            for i=1:size(uniqueTargets,1),
                if(nOfPattPerClass(i)==1)
                    train.patterns = [train.patterns; train.patterns(train.targets==uniqueTargets(i),:)];
                    train.targets = [train.targets; train.targets(train.targets==uniqueTargets(i),:)];
                    [train.targets,idx] = sort(train.targets);
                    train.patterns = train.patterns(idx,:);
                end
            end
            
            % Use the seed
%             s = RandStream.create('mt19937ar','seed',obj.seed);
%             RandStream.setDefaultStream(s);
            rand('twister',1);
            
            CVO = cvpartition(train.targets,'k',nOfFolds);

            result1 = zeros(CVO.NumTestSets,size(combinations,2));
            result2 = zeros(CVO.NumTestSets,size(combinations,2));
            % Foreach fold
            for ff = 1:CVO.NumTestSets,
                % Build fold dataset
                trIdx = CVO.training(ff);
                teIdx = CVO.test(ff);
                
                auxTrain.targets = train.targets(trIdx,:);
                auxTrain.patterns = train.patterns(trIdx,:);
                auxTest.targets = train.targets(teIdx,:);
                auxTest.patterns = train.patterns(teIdx,:);
                for i=1:size(combinations,2),
                    % Extract the combination of parameters
                    currentCombination = combinations(:,i);
                    model = obj.method.runAlgorithm(auxTrain, auxTest, currentCombination);
                    result1(ff,i) = obj.cvCriteria1.calculateCrossvalMetric(auxTest.targets, model.predictedTest);
                    result2(ff,i) = obj.cvCriteria2.calculateCrossvalMetric(auxTest.targets, model.predictedTest);
                end

            end  

            [bestValue,bestIdx] = min(mean(result1));
            optimals.pram1 = combinations(:,bestIdx);
            [bestValue,bestIdx] = min(mean(result2));
            optimals.pram2 = combinations(:,bestIdx);          
        end