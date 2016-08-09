clear 
% datasets
name1 = {'contact-lenses','pasture','squash-stored','squash-unstored','tae','newthyroid','balance-scale',...
'SWD','car','bondrate','toy','eucalyptus','LEV','automobile','winequality-red','ESL','ERA'}; n0=30;
%Datasets of Collaborative Filtering
name1={'X4058_400','X4058_350','X4058_300','X4058_250','X4058_200','X4058_150','X4058_100'};
%more datasets
%name1={'pyrim','machine','bostonhousing','abalone','bank32nh','cpu_act','cal_housing','house_16L'}; n0=20;

%The pathes of above datasets
path0={'/root/orca-master0/orca-master/datasets/discretized-regression/5bins/',...
        '/root/orca-master0/orca-master/datasets/discretized-regression/10bins/',...     
        '/root/orca-master0/orca-master/datasets/ordinal-regression/'};
path=path0{3};

for i=[1:9]
    for h=[1:17]
    name0=name1{h};
    % name={'SVC1V1','SVC1VA','SVR','CSSVC','SVMOP','SVOREX','SVORIM','REDSVM','NPSVOR','NPSVOR_C','OPBE'};
    switch i
        case 1
            Algorithm = SVC1V1();
            name = 'SVC1V1';
%           %  Parameter C (Cost)
%             param(1) = 100;
%           %  Parameter k (kernel width)
%             param(2) = 1; 
            obj.parameters.C = 10.^(-3:3);
            obj.parameters.k = 10.^(-3:3);
        case 2
            Algorithm = SVC1VA();
            name = 'SVC1VA';
          %  Parameter C (Cost)
            param(1) = 100;
          %  Parameter k (kernel width)
            param(2) = 1;
            obj.parameters.C = 10.^(-3:3);
            obj.parameters.k = 10.^(-3:3); 
        case 3
            Algorithm = SVR();
            name = 'SVR';
            % Parameter C (Cost)
            param(1) = 100;
            % Parameter k (kernel width)
            param(2) = 1;
            %  Parameter e
            param(3) = 0.1;
%           obj.parameters.C = 10.^(-3:3);
%           obj.parameters.k = 10.^(-3:3);
%           obj.parameters.e = 10.^(-1);  
        case 4
            Algorithm = CSSVC();
            name = 'CSSVC';
            % Parameter C (Cost)
            param(1) = 100;
            % Parameter k (kernel width)
            param(2) = 1;
%           obj.parameters.C = 10.^(-3:3);
%           obj.parameters.k = 10.^(-3:3);
        case 5
            Algorithm = SVMOP();
            name = 'SVMOP';
            % Parameter C (Cost)
            param(1) = 100;
            % Parameter k (kernel width)
            param(2) = 1;
%           obj.parameters.C = 10.^(-3:3);
%           obj.parameters.k = 10.^(-3:3); 
        case 6
            Algorithm = SVOREX();
            name = 'SVOREX';
            % Parameter C (Cost)
            param(1) = 100;
            % Parameter k (kernel width)
            param(2) = 1;
%           obj.parameters.C = 10.^(-3:3);
%           obj.parameters.k = 10.^(-3:3);                                 
        case 7
            Algorithm = SVORIM();
            name = 'SVORIM';
            % Parameter C (Cost)
%             param(1) = 100;
%             % Parameter k (kernel width)
%             param(2) = 1;
            obj.parameters.C = 10.^(-3:3);
            obj.parameters.k = 10.^(-3:3);             
        case 8
            Algorithm = REDSVM();
            name = 'REDSVM';
            % Parameter C (Cost)
%             param(1) = 100;
%             Parameter k (kernel width)
%             param(2) = 1;
            obj.parameters.C = 10.^(-3:3);
            obj.parameters.k = 10.^(-3:3);                  
          case 9
            Algorithm = NPSVOR();  % matlab code
            name = 'NPSVOR';
            % Parameter C (Cost)
%           param(1) = 100;
%           % Parameter k (kernel width)
%           param(2) = 1;
%           param(3) = 0.1;
            obj.parameters.C = 10.^(-3:3);
            obj.parameters.k = 10.^(-3:3);
            obj.parameters.e = [0.2]; 
           case 10
            Algorithm = OPBE();
            name = 'OPBE';
%           % Parameter C (Cost)
%           param(1) = 100;
%           % Parameter k (kernel width)
%           param(2) = 1;
            obj.parameters.C = 10.^(-3:3);
            obj.parameters.k = 10.^(-3:3);           
    end

pathsave={'/root/orca-master0/orca-master/exampledata/','/root/orca-master0/orca-master/exampledata/xietongguolv/','/root/orca-master0/orca-master/src/Algorithms'};
pathsave=pathsave{3};

for k=1:n0
 
fname1 = strcat(path,name0,'/matlab/', 'train_',name0,'.', num2str(k-1));
fname2 = strcat(path, name0,'/matlab/','test_',name0,'.', num2str(k-1));

Train = load(fname1);
Test = load(fname2);

train.patterns =Train(:,1:end-1);
train.targets =  Train(:,end);
test.patterns = Test(:,1:end-1);
test.targets =  Test(:,end);
[train, test] = preProcessData(train,test); % normalization

% Running the algorithm
obj.nOfFolds=5;
obj.method = Algorithm;
obj.cvCriteria1 = MZE;
obj.cvCriteria2 = MAE;

c1 = clock;    
param = crossValide(obj,train);
c2 = clock;
time=etime(c2,c1);

%time information for Cross Validation
CVtime(k) = time;

info1 = Algorithm.runAlgorithm(train,test,param.pram1);
time1(k,1) = info1.trainTime; 
time1(k,2) = info1.testTime; 
error1(k)=sum(test.targets~=info1.predictedTest)/size(test.targets,1);
abserror1(k)=sum(abs(test.targets-info1.predictedTest))/size(test.targets,1);
fprintf('%d %f %f %f\n',k, info1.trainTime,error1(k),abserror1(k))

if(param.pram1==param.pram2)
    info2=info1;
else   
    info2 = Algorithm.runAlgorithm(train,test,param.pram2);
end
time2(k,1) = info2.trainTime;
time2(k,2) = info2.testTime; 
error2(k)=sum(test.targets~=info2.predictedTest)/size(test.targets,1);
abserror2(k)=sum(abs(test.targets-info2.predictedTest))/size(test.targets,1);
fprintf('%d %f %f %f\n',k, info2.trainTime,error2(k),abserror2(k))
end
    

fsave0 = strcat(pathsave,name, name0);
Result = [error1',abserror2',CVtime',time1,time2];
save(fsave0,'Result','-ascii')

%  param=[];
time1=[];
error1=[];
abserror1=[];
time2=[];
error2=[];
abserror2=[];
CVtime = [];
mean(Result)
end

end
