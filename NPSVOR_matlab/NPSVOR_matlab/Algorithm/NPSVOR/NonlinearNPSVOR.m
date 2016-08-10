
function [Beta, b, history] = NonlinearNPSVORall2(H,A,Y,c1,c2,n,epsilon,rho)
%'traindata' is a training data matrix , each line is a sample vector
%'targets' is a label vector,should  start  from 1 to p

%Global constants and defaults
MAX_ITER = 50;
ABSTOL   = 1e-2;
RELTOL   = 1e-2;
L = unique(Y);
m = length(L);
Z = ones(n,m);  
U = zeros(n,m);
i=1;
v2 = sum(A,2);
%  A = [ H + rho*eye(n),ones(n,1);ones(1,n) 0]\speye(n+1);
while i <=MAX_ITER
    v1 = A*(Z-U);
    v = rho*sum(v1,1)/sum(v2); 
    Beta = v1 -v2*v;
%    Alpha = [ H0 + rho*eye(n),yk;yk' 0 ]\[rho*(Z-U);0];
%    Alpha = Alpha(1:end-1);
    Zold = Z; 
    Z= Beta+U;
    for j=1:m
        k = L(j);
        yk = 1*(Y<=k) -(Y>k);
        Z(Y~=k,j) = median([zeros(sum(Y~=k),1),Z(Y~=k,j)+1/rho*yk(Y~=k), c2*yk(Y~=k)],2);
        Sk = SoftThreshold(Z(Y==k,j), epsilon/rho);
        Z(Y==k,j) = median([-c1*ones(sum(Y==k),1),Sk, c1*ones(sum(Y==k),1)],2);
    end
    %U- -update
    r = Beta- Z;
    U = U + r;
    for t=1:m
        history.objval(i,t)  =  objective(H,Y, t, Beta(:,t),  epsilon);
    end
    history.fun(i) = sum(history.objval(i,:));
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


for j = 1:m
    k = L(j); 
   bk_c1 =  H(Y==k&(0<Beta(:,j)&Beta(:,j)<c1), :) * Beta(:,j) + epsilon;
   bk_c2 =  H(Y==k&(Beta(:,j)<0&Beta(:,j)>-c1), :) * Beta(:,j)  - epsilon;
   bk_l =  H(Y<k&(Beta(:,j)>0 & Beta(:,j)<c2), :) * Beta(:,j) - 1;
   bk_r =  H(Y>k&(Beta(:,j)<0 & Beta(:,j)>-c2), :) * Beta(:,j) + 1;
   b(j) = mean([bk_c1;bk_c2;bk_l;bk_r]);
end

% for j = 1:m
%     k = L(j); eps =1e-6;
%    bk_c1 =  H(Y==k&(eps<Beta(:,j)&Beta(:,j)<c1-eps), :) * Beta(:,j) + epsilon;
%    bk_c2 =  H(Y==k&(Beta(:,j)<-eps&Beta(:,j)>-c1+eps), :) * Beta(:,j)  - epsilon;
%    bk_l =  H(Y<k&(Beta(:,j)>eps & Beta(:,j)<c2-eps), :) * Beta(:,j) - 1;
%    bk_r =  H(Y>k&(Beta(:,j)<-eps & Beta(:,j)>-c2+eps), :) * Beta(:,j) + 1;
%    b(j) = mean([bk_c1;bk_c2;bk_l;bk_r]);
% end

end

function Znew = SoftThreshold(Zold,kappa)

Znew = (Zold + kappa).*(Zold<- kappa)+(Zold - kappa).*(Zold> kappa) ;

end

function obj = objective(H,Y, k, Beta,  epsilon)
    obj = 0.5*Beta'*H*Beta+ epsilon* (Y==k)'*abs(Beta) - ((Y<k) - (Y>k))'*Beta;
end
