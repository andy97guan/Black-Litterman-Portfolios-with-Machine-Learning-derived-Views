clc;
clearvars;

%% Load Asset Data 

load assets.mat;
load rf.mat;
load benchmark.mat;

%% Converte date to number 

Date=datenum(pf(1).Date);

%% Create matrix of prices 

AdjClose=[Date, pf(1).AdjClose, pf(2).AdjClose, pf(3).AdjClose, pf(4).AdjClose, pf(5).AdjClose];
rf_AdjClose=[Date,rf.AdjClose];
bm_AdjClose=[Date,bm.AdjClose];

%% Create a matrix for returns

[n,p]=size(AdjClose);

rts=zeros(n-1,p);
rts(:,1)=Date(2:end);

for i=2:p
     rts(:,i)= log(AdjClose(2:end,i)./AdjClose(1:end-1,i));
end

%% Create Risk free rate returns

rf_rts=zeros(n-1,2);
rf_rts(:,1)=Date(2:end);

rf_rts(:,2)= rf_AdjClose(2:end,2);

%% Create Benchmark returns

bm_rts=zeros(n-1,2);
bm_rts(:,1)=Date(2:end);

bm_rts(:,2)= log(bm_AdjClose(2:end,2)./bm_AdjClose(1:end-1,2));

%% Create Excess returns

exs_rts=zeros(n-1,p);

exs_rts(:,1)=Date(2:end);

for i=2:p
     exs_rts(:,i)=rts(:,i)-rf_rts(:,2);
end

%% Create Excess Benchmark returns

exs_bm_rts=zeros(n-1,2);
exs_bm_rts(:,1)=Date(2:end);

exs_bm_rts(:,2)= bm_rts(:,2)-rf_rts(:,2);


save('excess_benchmark_returns.mat','exs_bm_rts');
save('excess_returns.mat','exs_rts');

EFA=[0;cumsum(exs_rts(:,2))];
EEM=[0;cumsum(exs_rts(:,3))];
GLD=[0;cumsum(exs_rts(:,4))];
TLT=[0;cumsum(exs_rts(:,5))];
IYR=[0;cumsum(exs_rts(:,6))];


fig = figure;
plot( Date, EFA,...
    Date, EEM,...
    Date, GLD,...
    Date, TLT,...
    Date, IYR);
axis tight;
set(gcf, 'Color', 'w');
datetick( 'x', 'yyyy', 'keeplimits' );
grid on;
xlabel('Year');
ylabel('Return');
%title('Cummulative Excess Returns');
%legend('EFA','EEM','GLD','TLT','IYR','Location','best');
legend('iShares MSCI EAFE ETF','iShares MSCI Emerging Markets ETF'...
    ,'SPDR Gold Shares ETF','iShares 20+ Year Treasury Bond ETF',...
    'iShares U.S. Real Estate ETF','Location','best');

%set(gcf,'units','normalized','outerposition',[0 0 1 1])
orient(fig,'portrait')
print(fig,'1cum_ret.eps','-depsc2')





