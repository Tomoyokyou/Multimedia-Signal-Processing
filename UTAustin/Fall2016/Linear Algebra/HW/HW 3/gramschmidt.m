%%gramschmidt
function[Q, R] = gramschmidt(A, flag)
if ~exist('flag', 'var')
    flag = false;
end
[m, n] = size(A);
Q = zeros(m, n);
R = zeros(n, n);
% Classical Gram-Schmidt
if (flag == true)
    for j = 1:n
        v = A(:, j);
        for i = 1:(j-1)
            R(i,j) = Q(:,i)'*A(:,j);
            v = v - R(i, j)'*Q(:,i);
        end
        R(j,j) = norm(v, 2);
        Q(:, j) = v/R(j,j);
    end
% Modified Gram-Schmidt
else
    for i = 1:n
        R(i, i) = norm(A(:,i),2);
        Q(:, i) = A(:,i)/R(i,i);
        for j = i+1:n
            R(i,j) = Q(:,i)'*A(:,j);
            A(:, j) = A(:, j) - R(i, j)'*Q(:,i);
        end
    end
end
