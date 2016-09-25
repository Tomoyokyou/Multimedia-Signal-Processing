
clear; clc;
%% Problem One
m = 5e1; n = 5e2; d = 5; sigma = 1e-2;

X1 = randn(m,n); b1 = zeros(n,1); b1(randsample(n,d)) = 1;
y1 = X1*b1 + sigma*randn(m,1);
X1test = randn(100,n);
y1test = X1test*b1;


% Least Square
b1_ls = LeastSquare(X1, y1);
regressionError_1 = norm(X1*b1_ls-y1);
testingError_1 = norm(X1test*b1_ls-y1test);



% LASSO
lambda = 0.1;
b1_la = LASSO(X1, y1, lambda);
regressionError_1_la = norm(X1*b1_la-y1);
testingError_1_la = norm(X1test*b1_la-y1test);


% OMP
tic;
b1_I = OMP(X1, y1, d);
regressionError_1_OMP = norm(X1*b1_I-y1);
testingError_1_OMP = norm(X1test*b1_I-y1test);
toc;

disp('Press a key to continue!')  
pause;
%% Problem Two
m = 5e2; n = 5e3; d = 5; sigma = 1e-2;

X2 = randn(m,n); b2 = zeros(n,1); b2(randsample(n,d)) = 1;
y2 = X2*b2 + sigma*randn(m,1);
X2test = randn(100,n);
y2test = X2test*b2;


% Least Square
b2_ls = LeastSquare(X2, y2);
regressionError_2 = norm(X2*b2_ls-y2);
testingError_2 = norm(X2test*b2_ls-y2test);



% LASSO
lambda = 0.1;
b2_la = LASSO(X2, y2, lambda);
regressionError_2_la = norm(X2*b2_la-y2);
testingError_2_la = norm(X2test*b2_la-y2test);


% OMP
tic;
b2_I = OMP(X2, y2, d);
regressionError_2_OMP = norm(X2*b2_I-y2);
testingError_2_OMP = norm(X2test*b2_I-y2test);
toc;

disp('Press a key to continue!')  
pause;


%% Problem Three
m = 5e3; n = 5e4; d = 5; sigma = 1e-2;

X3 = randn(m,n); b3 = zeros(n,1); b3(randsample(n,d)) = 1;
y3 = X3*b3 + sigma*randn(m,1);
X3test = randn(100,n);
y3test = X3test*b3;


% Least Square
b3_ls = LeastSquare(X3, y3);
regressionError_3 = norm(X3*b3_ls-y3);
testingError_3 = norm(X3test*b3_ls-y3test);

% LASSO
lambda = 0.1;
b3_la = LASSO(X3, y3, lambda);
regressionError_3_la = norm(X3*b3_la-y3);
testingError_3_la = norm(X2test*b2_la-y3test);


% OMP
tic;
b3_I = OMP(X3, y3, d);
regressionError_3_OMP = norm(X3*b3_I-y3);
testingError_3_OMP = norm(X3test*b3_I-y3test);
toc;