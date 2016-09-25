% LASSO
function b = LASSO(X, y, lambda)
[m n] = size(X);

cvx_begin
    variable b(n);
    minimize(norm(X*b-y)+lambda*norm(b,1));
cvx_end