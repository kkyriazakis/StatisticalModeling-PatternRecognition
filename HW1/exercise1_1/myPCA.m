function [U, S] = myPCA(X)
%PCA Run principal component analysis on the dataset X
%   [U, S, X] = myPCA(X) computes eigenvectors of the covariance matrix of X
%   Returns the eigenvectors U, the eigenvalues (on diagonal) in S
%

% Useful values
[m, n] = size(X);

% You need to return the following variables correctly.
U = zeros(n);
S = zeros(n);

% ====================== YOUR CODE GOES HERE ====================== 
Sigma_x = (1/m)*(X.'*X);

[V,D] = eig(Sigma_x);

eigenvalues = diag(D);
[eigenvalues, pos]= sort(eigenvalues ,1,'descend');
eigenvectors = V(:,pos);

U = eigenvectors;
S = eigenvalues;

% =========================================================================

end
