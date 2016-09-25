clear all; close all; clc;
%% Main for Question 4 

n = 100; A = randn(n,n); [U,R] = qr(A);
repeat = 100; gamma = 1;


%% Matrix 1 : All eigenvalues are one
X1 = U * diag(ones(1,n)) * U'; b1 = ones(n,1);

b1_GD= GradientDescent(b1, gamma, X1, repeat);
fb_1 =[];

for i= 1:repeat
    fb_1 = [ fb_1 0.5*b1_GD(:,i)'*X1*b1_GD(:,i)];
end

figure;
plot(1:repeat, fb_1, 'g');
title(['const step size \gamma= ' num2str(gamma) ' for (a)']);
xlabel('iteration n')
ylabel('f(\beta)^(^n^)')

%% Matrix 2 : A half of the eigenvalues are one
X2 = U * diag([ones(1,n/2) 1e-2*ones(1,n/2)]) * U'; b2 = ones(n,1);

b2_GD= GradientDescent(b2, gamma, X2, repeat);
fb_2 =[];
for i= 1:repeat
    fb_2 = [ fb_2 0.5*b2_GD(:,i)'*X2*b2_GD(:,i)];
end

figure;
plot(1:repeat, fb_2, 'r');
title(['const step size \gamma= ' num2str(gamma) ' for (b)']);
xlabel('iteration n')
ylabel('f(\beta)^(^n^)')
%% Matrix 3 : All other than a few very large eigenvalues are one
X3 = U * diag([1e2*ones(1,10) ones(1,n-10)]) * U'; b3 = ones(n,1);

b3_GD= GradientDescent(b3, gamma, X3, repeat);

fb_3 =[];
for i= 1:repeat
    fb_3 = [ fb_3 0.5*b3_GD(:,i)'*X3*b3_GD(:,i)];
end

figure;
plot(1:repeat, fb_3);
title(['const step size \gamma= ' num2str(gamma) ' for (c)']);
xlabel('iteration n')
ylabel('f(\beta)^(^n^)')
