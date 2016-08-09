function K = Kernel(ker,X1,X2,sigma)

switch ker
    case 'linear'
        if exist('X2','var')
            K = X1' * X2;
        else
            K = X1' * X1;
        end

    case 'poly'
        if exist('X2','var')
            K = (X1' * X2 + b).^d;
        else
            K = (X1' * X1 + b).^d;
        end

    case 'rbf'
        n1sq = sum(X1.^2,1);
        n1 = size(X1,2);

        if isempty(X2);
            D = (ones(n1,1)*n1sq)' + ones(n1,1)*n1sq -2*X1'*X1;
        else
            n2sq = sum(X2.^2,1);
            n2 = size(X2,2);
            D = (ones(n2,1)*n1sq)' + ones(n1,1)*n2sq -2*X1'*X2;
        end;
        K = exp(-sigma*D);
%          kernel=@(x,z) exp(-sigma*distance(x',z'));
%          K=kernel(X1',X2');
    case 'sam'
        if exist('X2','var');
            D = X1'*X2;
        else
            D = X1'*X1;
        end
        K = exp(-acos(D).^2/(2*sigma^2));

    otherwise
        error(['Unsupported kernel ' ker])
end
end