function [X_norm, mu, sigma] = featureNormalize(X)

    mu = mean(X);
    sigma = std(X);

    [Sample_size, Feature_size] = size(X);

    for i=1:Feature_size
       X_norm(:,i) = (X(:,i) - mu(i))/sigma(i);
    end

end
