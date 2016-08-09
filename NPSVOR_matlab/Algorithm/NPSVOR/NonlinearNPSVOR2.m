
function [Beta, bk] = NonlinearNPSVOR2(H,A,Y,k, c1,c2,n,epsilon,rho)
%'traindata' is a training data matrix , each line is a sample vector
%'targets' is a label vector,should  start  from 1 to p

%Global constants and defaults
MAX_ITER = 50;
ABSTOL   = 1;
RELTOL   = 1e-2;
Z = 2*ones(n,1);  
U = zeros(n,1); 
i=1;
yk = 1*(Y<=k) -(Y>k);
%  A = [ H + rho*eye(n),ones(n,1);ones(1,n) 0]\speye(n+1);
while i <=MAX_ITER
    Beta = A(1:end-1,:)*[rho*(Z-U);0];
%    Alpha = [ H0 + rho*eye(n),yk;yk' 0 ]\[rho*(Z-U);0];
%    Alpha = Alpha(1:end-1);
    Zold = Z; 
    Z= Beta+U;
    Z(Y~=k) = median([zeros(sum(Y~=k),1),Z(Y~=k)+1/rho*yk(Y~=k), c2*yk(Y~=k)],2);
    Sk = SoftThreshold(Z(Y==k), epsilon/rho);
    Z(Y==k) = median([-c1*ones(sum(Y==k),1),Sk, c1*ones(sum(Y==k),1)],2);
    %U- -update
    r = Beta- Z;
    U = U + r;
 %   history.objval(i)  =  objective(H,Y, k, Beta,  epsilon);
    s = rho*(Z - Zold);
    history.r_norm(i) = norm(r);
    history.s_norm(i) = norm(s);
    history.eps_pri(i) = sqrt(n)*ABSTOL + RELTOL*max(norm(Beta), norm(Z));
    history.eps_dual(i)= sqrt(n)*ABSTOL + RELTOL*norm(rho*U);
    if  history.r_norm(i) < history.eps_pri(i) && ...
            history.s_norm(i) < history.eps_dual(i);
        break
    end
    i = i+1;
end
%    Beta = Z;
   bk_c1 =  H(Y==k&(0<Beta&Beta<c1), :) * Beta + epsilon;
   bk_c2 =  H(Y==k&(Beta<0&Beta>-c1), :) * Beta  - epsilon;
   bk_l =  H(Y<k&(Beta>0 & Beta<c2), :) * Beta - 1;
   bk_r =  H(Y>k&(Beta<0 & Beta>-c2), :) * Beta + 1;
   bk = mean([bk_c1;bk_c2;bk_l;bk_r]);
end

function Znew = SoftThreshold(Zold,kappa)

Znew = (Zold + kappa).*(Zold<- kappa)+(Zold - kappa).*(Zold> kappa) ;

end

function obj = objective(H,Y, k, Beta,  epsilon)
    obj = 0.5*Beta'*H*Beta+ epsilon* (Y==k)'*abs(Beta) - ((Y<k) - (Y>k))'*Beta;
end