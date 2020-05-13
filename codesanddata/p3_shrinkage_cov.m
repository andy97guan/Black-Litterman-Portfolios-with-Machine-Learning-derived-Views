clc;
clearvars;

%% Load Excess Returns Data 

load excess_returns.mat;
load excess_benchmark_returns.mat;

u=exs_rts(:,2:end);

[sigma,shrinkage]=covCor(u);

%%