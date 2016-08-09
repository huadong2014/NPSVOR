function [Alpha, bk, yk, history] = NonlinearNPSVOR(H, Y,k, c1,c2,n,epsilon,rho)
%'traindata' is a training data matrix , each line is a sample vector
%'targets' is a label vector,should  start  from 1 to p

%Global constants and defaults
MAX_ITER = 100;
ABSTOL   = 1e-6;
RELTOL   = 1e-3;

Z = 2*ones(n,1);  
U = zeros(n,1); 
i=1;
yk = 1*(Y<=k) -(Y>k);
H0 = H.*(yk*yk');
 A = [ H0 + rho*eye(n),yk;yk' 0 ]\speye(n+1);
while i <=MAX_ITER
    Alpha = A(1:end-1,:)*[rho*(Z-U);0];
%    Alpha = [ H0 + rho*eye(n),yk;yk' 0 ]\[rho*(Z-U);0];
%    Alpha = Alpha(1:end-1);
    Zold = Z; 
    Z= Alpha+U;
    Z(Y~=k) = median([zeros(sum(Y~=k),1),Z(Y~=k)+1/rho, c2*ones(sum(Y~=k),1) ],2);
    Sk = SoftThreshold(Z(Y==k), epsilon/rho);
    Z(Y==k) = median([-c1*ones(sum(Y==k),1),Sk, c1*ones(sum(Y==k),1)],2);
    %U- -update
    r = Alpha- Z;
    U = U + r;
    history.objval(i)  =  objective(H0,Y, k, Z,  epsilon);
    s = rho*(Z - Zold);
    history.r_norm(i) = norm(r);
    history.s_norm(i) = norm(s);
    history.eps_pri(i) = sqrt(n)*ABSTOL + RELTOL*max(norm(Alpha), norm(Z));
    history.eps_dual(i)= sqrt(n)*ABSTOL + RELTOL*norm(rho*U);
    if  history.r_norm(i) < history.eps_pri(i) && ...
            history.s_norm(i) < history.eps_dual(i);
        break
    end
    i = i+1;
end
%    Alpha = Z;
   bk_c1 =  H(Y==k&Alpha>0, :) * (yk.*Alpha) + epsilon;
   bk_c2 =  H(Y==k&Alpha<0, :) * (yk.*Alpha) - epsilon;
   bk_l =  H(Y<k&Alpha>0, :) * (yk.*Alpha) - 1;
   bk_r =  H(Y>k&Alpha>0, :) * (yk.*Alpha) + 1;
   bk = mean([bk_c1;bk_c2;bk_l;bk_r]);
end

function Znew = SoftThreshold(Zold,kappa)

Znew = (Zold + kappa).*(Zold<- kappa)+(Zold - kappa).*(Zold> kappa) ;

end

function obj = objective(H0,Y, k, Alpha,  epsilon)
    obj = 0.5*Alpha'*H0*Alpha+ epsilon* (Y==k)'*abs(Alpha) - (Y~=k)'*Alpha;
end
