clc;
clearvars;

%% Load Excess Returns Data 

load excess_returns.mat;
load excess_benchmark_returns.mat;

Date=exs_rts(:,1);
%% 1. Descriptive Statistics

assets_ds = getDescriptiveStatistics(exs_rts(:,2:end));

%% 2. Skewness

assets_skew = skewness(exs_rts(:,2:end));

%% 3. Kurtosis

assets_kurt = kurtosis(exs_rts(:,2:end));

%% 4. Normality tests

[ntest_efa, p_efa, jbstat_efa, critval_efa]=jbtest(exs_rts(:,2));
[ntest_eem, p_eem, jbstat_eem, critval_eem]=jbtest(exs_rts(:,3));
[ntest_gld, p_gld, jbstat_gld, critval_gld]=jbtest(exs_rts(:,4));
[ntest_tlt, p_tlt, jbstat_tlt, critval_tlt]=jbtest(exs_rts(:,5));
[ntest_iyr, p_iyr, jbstat_iyr, critval_iyr]=jbtest(exs_rts(:,6));

ntest=[ntest_efa,ntest_eem,ntest_gld, ntest_tlt, ntest_iyr];
p_normal=[p_efa,p_eem,p_gld,p_tlt,p_iyr];
jb_stat=[jbstat_efa,jbstat_eem,jbstat_gld,jbstat_tlt,jbstat_iyr];

%% 5. Maximum Drawdown

[MDD_EFA, MDDs_EFA, MDDe_EFA] = mdd(exs_rts(:,2:end));
[MDD_EEM, MDDs_EEM, MDDe_EEM] = mdd(exs_rts(:,3:end));
[MDD_GLD, MDDs_GLD, MDDe_GLD] = mdd(exs_rts(:,4:end));
[MDD_TLT, MDDs_TLT, MDDe_TLT] = mdd(exs_rts(:,5:end));
[MDD_IYR, MDDs_IYR, MDDe_IYR] = mdd(exs_rts(:,6:end));


Drawdown = [MDD_EFA, MDD_EEM, MDD_GLD, MDD_TLT, MDD_IYR];
Drawdown_s = datestr([Date(MDDs_EFA), Date(MDDs_EEM), Date(MDDs_GLD), Date(MDDs_TLT),...
    Date(MDDs_IYR)]);
Drawdown_e = datestr([Date(MDDe_EFA), Date(MDDe_EEM), Date(MDDe_GLD), Date(MDDe_TLT),...
    Date(MDDe_IYR)]);

Drawdown_period= [Drawdown_s, Drawdown_e];

%% 6. Autocorrelation

acf_2=autocorr(exs_rts(:,2));
acf_3=autocorr(exs_rts(:,3));
acf_4=autocorr(exs_rts(:,4));
acf_5=autocorr(exs_rts(:,5));
acf_6=autocorr(exs_rts(:,6));

acf=[acf_2, acf_3, acf_4, acf_5, acf_6];

%% 7. Ljun-Box Q test

R=exs_rts(:,2:end);

mean=mean(R);
res=R-repmat(mean,size(mean,1),1);

[h1,pvalue1,stat1,cvalue1]=lbqtest(res(:,1),'lags',[5,10,15]);
[h2,pvalue2,stat2,cvalue2]=lbqtest(res(:,2),'lags',[5,10,15]);
[h3,pvalue3,stat3,cvalue3]=lbqtest(res(:,3),'lags',[5,10,15]);
[h4,pvalue4,stat4,cvalue4]=lbqtest(res(:,4),'lags',[5,10,15]);
[h5,pvalue5,stat5,cvalue5]=lbqtest(res(:,5),'lags',[5,10,15]);

H=[h1; h2; h3; h4; h5];
pvalue=[pvalue1; pvalue2; pvalue3; pvalue4; pvalue5];
stats=[stat1; stat2; stat3; stat4; stat5];
cvalues=[cvalue1; cvalue2; cvalue3; cvalue4; cvalue5];

%% 8. Engel ARCH test at 1% significance level.

[ha1,pValuea1,stata1,cValuea1] = archtest(res(:,1),'Lags',1,'Alpha',0.01);
[ha2,pValuea2,stata2,cValuea2] = archtest(res(:,2),'Lags',1,'Alpha',0.01);
[ha3,pValuea3,stata3,cValuea3] = archtest(res(:,3),'Lags',1,'Alpha',0.01);
[ha4,pValuea4,stata4,cValuea4] = archtest(res(:,4),'Lags',1,'Alpha',0.01);
[ha5,pValuea5,stata5,cValuea5] = archtest(res(:,5),'Lags',1,'Alpha',0.01);

Ha=[ha1; ha2; ha3; ha4; ha5];
pvaluea=[pValuea1; pValuea2; pValuea3; pValuea4; pValuea5];
statsa=[stata1; stata2; stata3; stata4; stata5];
cvaluesa=[cValuea1; cValuea2; cValuea3; cValuea4; cValuea5];

%% 9. Sample Correlation
[corr,P,corr_lower, corr_upper] =corrcoef(exs_rts(:,2:end));

%% 10. Sample Covariance 

covariance=cov(exs_rts(:,2:end));


%% 11. Higher Moments

moment_4=moment(exs_rts(:,2:end),4);
moment_6=moment(exs_rts(:,2:end),6);
moment_8=moment(exs_rts(:,2:end),8);

%% Violin Plots

fig=figure;
[h,L,MX,bw]=violin(exs_rts(:,2:end),'xlabel',[],...
    'facecolor',['y' ; 'm' ; 'c' ; 'r' ; 'g'],'mc','k',...
'medc',[]);
xticklabels({'EFA','EEM','GLD', 'TLT','IYR'});
xlabel('Ticker');
ylabel('Weekly Excess Returns');
legend off;
grid on;
set(gcf, 'Color', 'w');
orient(fig,'portrait')
print(fig,'1weeklyexcessviolin.eps','-depsc2');

%% Drawdown Function

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

