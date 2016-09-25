%% Main for Question 2
clc; clear; close all;

repeattime = 100;
kappa = [1,1e3, 1e6, 1e9];
error = zeros(3, size(kappa,2));
orthogonality = zeros(3, size(kappa,2));
isUpperTriangular = zeros(3, size(kappa,2));

for j = 1 : repeattime
    for i = 1:size(kappa,2)

    A = gallery('randsvd', 100, kappa(i));  
    [Q_matlab, R_matlab] = qr(A);

    error(1, i) =  error(1, i)+ norm((A-Q_matlab*R_matlab))/norm(A);
    orthogonality(1, i) = orthogonality(1, i)+ norm(Q_matlab*Q_matlab'-eye(size(Q_matlab)))/norm(eye(size(Q_matlab)));
    isUpperTriangular(1, i) = isUpperTriangular(1, i) + istriu(R_matlab);

    [Q_classical, R_classical] = gramschmidt(A, true);

    error(2, i) = error(2, i)+ norm((A-Q_classical*R_classical))/norm(A);
    orthogonality(2, i) =orthogonality(2, i)+  norm(Q_classical*Q_classical'-eye(size(Q_classical)))/norm(eye(size(Q_classical)));
    isUpperTriangular(2, i) = isUpperTriangular(2, i) + istriu(R_classical);

    [Q_modified, R_modified] = gramschmidt(A);

    error(3, i) = error(3, i) + norm((A-Q_modified*R_modified))/norm(A);
    orthogonality(3, i) = orthogonality(3, i) +  norm(Q_modified*Q_modified'-eye(size(Q_modified)))/norm(eye(size(Q_modified)));
    isUpperTriangular(3, i) = isUpperTriangular(3, i)+ istriu(R_modified);

    end
    
end

error = error./repeattime;
orthogonality = orthogonality./repeattime;
isUpperTriangular = isUpperTriangular./repeattime;