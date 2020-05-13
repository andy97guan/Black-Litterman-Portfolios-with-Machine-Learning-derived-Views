clc;
clearvars;

%% Load Excess Returns Data 

load excess_returns.mat;
load excess_benchmark_returns.mat;

%%
eem = exs_rts(:,2);

[n,p]=size(eem);

plain_var=zeros(n,1);
ewma_var=zeros(n,1);

for i=1:n
    d=eem(1:i,1);
    plain_var(i,1)=var(d);
    lambda=0.7;
    cov_ewma =ewma_covariance(d,lambda);
    ewma_var(i,1)= cov_ewma;
end

plot(plain_var);
hold on
plot(ewma_var);



function [cov_ewma] = ewma_covariance(X,lambda)
[n,p]         = size(X);
e_X      = X-repmat(mean(X,1),n,1);
weight     = lambda.^(0:1:n-1)';
X_hat    = repmat(sqrt(weight),1,p).*e_X;
cov_ewma      = 1/sum(weight)*(X_hat'*X_hat);
end