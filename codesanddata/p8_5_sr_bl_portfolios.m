clc;
clearvars;

%% Create Date Variable 
load exs_rts_cleaned.mat;
Date=exs_rts(:,1);

%% Create weights 

Measures_comp=zeros(12,11);
cum_ret_comp=zeros(142,12);


[weights1,Measures_comp(1,:),cum_ret_comp(:,1),~]=main_bl(1,1);
[weights2,Measures_comp(2,:),cum_ret_comp(:,2),~]=main_bl(2,1);
[weights3,Measures_comp(3,:),cum_ret_comp(:,3),~]=main_bl(3,1);
[weights4,Measures_comp(4,:),cum_ret_comp(:,4),~]=main_bl(4,1);

[weights5,Measures_comp(5,:),cum_ret_comp(:,5),~]=main_bl(1,2);
[weights6,Measures_comp(6,:),cum_ret_comp(:,6),~]=main_bl(2,2);
[weights7,Measures_comp(7,:),cum_ret_comp(:,7),~]=main_bl(3,2);
[weights8,Measures_comp(8,:),cum_ret_comp(:,8),~]=main_bl(4,2);

[weights9,Measures_comp(9,:),cum_ret_comp(:,9),~]=main_bl(1,3);
[weights10,Measures_comp(10,:),cum_ret_comp(:,10),~]=main_bl(2,3);
[weights11,Measures_comp(11,:),cum_ret_comp(:,11),~]=main_bl(3,3);
[weights12,Measures_comp(12,:),cum_ret_comp(:,12),~]=main_bl(4,3);

x=linspace(1,141,141);



fig=figure;
subplot(3,1,1)

area(x,weights3);
colormap(parula(5))
axis tight;
xlabel('Out of sample period');
ylabel('weights');
title('Max Sharpe portfolio weights for \delta=0.01 (Near Kelly Investor)');
legend('EFA','EEM','GLD','TLT','IYR','Location','bestoutside');
set(gcf, 'Color', 'w');

subplot(3,1,2);
area(x,weights7);
colormap(parula(5))
axis tight;
xlabel('Out of sample period');
ylabel('weights');
title('Max Sharpe portfolio weights for \delta=2.24 (Average Investor) ');
legend('EFA','EEM','GLD','TLT','IYR','Location','bestoutside');

subplot(3,1,3)
area(x,weights11);
colormap(parula(5))
axis tight;
xlabel('Out of sample period');
ylabel('weights');
title('Max Sharpe portfolio weights for \delta=6 (Risk Averse Investor) ');
legend('EFA','EEM','GLD','TLT','IYR','Location','bestoutside');
set(gcf, 'Color', 'w');
print(fig,'sharpe_weights.eps','-depsc2')





function [p_wts,Measures,cum_ret,cum_pnl]=main_bl(cov_choice,del_choice)
p_wts=zeros(141,5);
rel_wts=zeros(141,5);
for i=1:141
    [p_wts(i,:),~,~]=bl_weights(i,cov_choice,del_choice);
    %rel_wts(i,:)=p_wts(i,:)./sum(abs(p_wts(i,:)));
end


[Measures,cum_pnl,cum_ret]=bl_performance(p_wts);

end



%% Create performance realted measures

function [Measures,cum_pnl,cum_ret]=bl_performance(p_wts)
load exs_rts_cleaned;

rel_wts=zeros(141,5);
for i=1:141
    rel_wts(i,:)=p_wts(i,:)./sum(abs(p_wts(i,:)));
end

portfolio_pnl=zeros(141,1);
portfolio_ret=zeros(141,1);
HHI=zeros(141,1);

for i=1:141
w=p_wts(i,:);

money_invested = 1000000*w;
weekly_pnl=money_invested.*exs_rts(562+i,2:end);
portfolio_pnl(i)=sum(weekly_pnl);

weekly_ret=w.*exs_rts(562+i,2:end);
portfolio_ret(i)=sum(weekly_ret);

hhi=norm(w)^2;
HHI(i)=hhi;
end


cum_pnl=[0;cumsum(portfolio_pnl)]; % cummulative pnl
cum_ret=[0;cumsum(portfolio_ret)]; % cummulative returns
mean_ret=mean(portfolio_ret); % mean of returns
var_ret=var(portfolio_ret); % variance of returns

mean_ret_apa=mean_ret*52*100;
sd_ret_apa=sqrt(var_ret*52)*100;


skew_ret=skewness(portfolio_ret); % skewness of returns
kurt_ret=kurtosis(portfolio_ret); % kurtosis of returns

VaR_cf=0.95;
sorted_returns = sort(portfolio_ret);
num_returns = numel(portfolio_ret);
VaR_index = ceil((1-VaR_cf)*num_returns);
VaR_ret = sorted_returns(VaR_index); % VaR of returns
CVaR_ret = mean(sorted_returns(1:VaR_index)); % CVaR of returns
muVaR=mean_ret/VaR_ret; % mean/VaR
muCVaR=mean_ret/CVaR_ret; % mean/CVaR

mean_HHI= mean(HHI); %average heifendahl index

sharpe_ratio=mean_ret/sqrt(var_ret); %sharpe ratio
sr_apa=sharpe_ratio*sqrt(52);


nr=max(zeros(141,1),portfolio_ret);
dr=max(zeros(141,1),-1.*portfolio_ret);
omega=mean(nr)/mean(dr); % Omega Ratio

[MDD, ~, ~] = mdd(portfolio_ret); % Maximum DrawDown

change_weights=zeros(140,5);
sum_change_weights=zeros(140,1);
for i=1:140
    for j=1:5
    change_weights(i,j)=p_wts(i+1,j)-p_wts(i,j);
    end
    sum_change_weights(i)=sum(change_weights(i,:));
end

PT_turnover= mean(sum_change_weights); % portfolio turnover

Measures=[mean_ret_apa,sd_ret_apa,skew_ret,kurt_ret,muVaR,muCVaR,mean_HHI,sr_apa,omega,MDD,PT_turnover];

end




%%


function [MDD, MDDs, MDDe] = mdd(r)
n = max(size(r));
cr = cumsum(r);
dd = zeros(n,1);
for i = 1:n
    dd(i) = max(cr(1:i))-cr(i);
end
MDD = max(dd);
MDDe = find(dd==MDD);
MDDs = find(abs(cr(MDDe)+ MDD - cr) < 0.000001);
end

function [w,pi_est,sigma_p]= bl_weights(i,cov_choice,del_choice)
load exs_rts_cleaned.mat;
load p_helper.mat
load pmatrix_helper.mat

rts=exs_rts(:,2:end);
returns=rts(1:561+i,:);
switch(del_choice)
    case 1
        delta=0.01;
    case 2
        delta=2.24;
    case 3
        delta=6;
end

tau = 1/(561+i);
sigma=bl_cov(returns,cov_choice);

mcap=[77562.7; 38406.3; 34722.9; 6742.8; 3713.3];
weq= mcap/sum(mcap);


pi=delta*sigma*weq;

P=eye(5);
Q=zeros(5,1);
for k=1:5
    A=P*pi;
    B=P*sigma*P';
    Q(k,1)=A(k,1)+pmatrix_helper(i,k)*sqrt(B(k,k));
end


Omega=tau*diag(diag(P*sigma*P'));
%Omega=(1/tau)*P*sigma*P';

pi_est = pi+ tau*sigma*P'*inv((tau*P*sigma*P')+Omega)*(Q-P*pi);
% M=tau*sigma-tau*sigma*P'*inv((tau*P*sigma*P')+Omega)*(P*tau*sigma);
% sigma_p=sigma+M;
sigma_p=((1+tau)*sigma)-(tau*tau*sigma*P')*inv((tau*P*sigma*P')+Omega)*(P*sigma);


%w= inv(delta*sigma_p)*pi_est;

w=portfoliofmincon(pi_est,sigma_p,delta);
end


function optPortfolio = portfoliofmincon(mu_bl,sig_bl,delta )
Aeq = ones(1,5);
beq = 1;
% Nested function which is used as the objective function
function objValue = objfunction(x)
objValue = - x' * mu_bl /sqrt(delta*x'*sig_bl*x) ;
end
% Use the equal-weighted portfolio as the starting point
x0 = ones(5,1)./5;

lb=zeros(5,1);
ub=ones(5,1);
% Set the algorithm to interior-point method
options = optimset('Algorithm', 'interior-point');
optPortfolio = fmincon(@objfunction, x0, [], [], Aeq, beq,...
lb, ub, [], options);
end




