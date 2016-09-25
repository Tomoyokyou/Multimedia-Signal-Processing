% OMP
function b_I = OMP(X, y, k)

[m, n] = size(X); y_res = y;
b_I = zeros(n, 1); I =[];

for i = 1:k
    innerproduct = y_res'*X;
    [innerproduct_max, max_idx] = max(innerproduct);
    I = [I max_idx];
    y_res = y_res - innerproduct_max*X(:,max_idx)/(norm(X(:,max_idx))^2); %Projection
end

b_I(I) = inv(X(:,I)'*X(:,I))*X(:,I)'*y;  