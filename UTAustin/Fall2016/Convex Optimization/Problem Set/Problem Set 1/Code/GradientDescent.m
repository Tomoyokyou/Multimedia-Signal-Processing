% Gradient Decent
function b_arr = GradientDescent(b0, gamma, X, n)
b = b0;
b_arr = [b0];
for i=1:n
    b = (b-gamma*X*b);
    b_arr = [b_arr b];
end