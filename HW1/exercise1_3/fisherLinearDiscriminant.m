function v = fisherLinearDiscriminant(X1, X2)

    m1 = size(X1, 1);
    m2 = size(X2, 1);

    mu1 = (1/m1)*sum(X1);
    mu2 = (1/m2)*sum(X2);

    S1 = cov(X1);
    S2 = cov(X2);

    Sw = (S1 + S2)/2;

    v = inv(Sw)*(mu1 - mu2)';
    
    v = v/norm(v);
    
    
