% Least Square
function b = LeastSquare(X, y)
[m n] = size(X);

cvx_begin
    variable b(n);
    minimize(norm(X*b-y));
cvx_end