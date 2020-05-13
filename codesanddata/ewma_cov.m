function [cov_ewma] = ewma_cov(X)
lambda=0.81;
[n,p]         = size(X);
e_X      = X-repmat(mean(X,1),n,1);
weight     = lambda.^(0:1:n-1)';
X_hat    = repmat(sqrt(weight),1,p).*e_X;
cov_ewma      = 1/sum(weight)*(X_hat'*X_hat);
end