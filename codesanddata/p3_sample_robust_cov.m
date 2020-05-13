clc;
clearvars;

%% Load Excess Returns Data 

load excess_returns.mat;
load excess_benchmark_returns.mat;

%%

u=exs_rts(:,2:end);

[Sfmcd, Mfmcd, dfmcd, Outfmcd] = robustcov(u);


d_classical = pdist2(u, mean(u),'mahal');
p = size(u,2);
chi2quantile = sqrt(chi2inv(0.975,p));

fig=figure;
plot(d_classical, dfmcd, 'o')
line([chi2quantile, chi2quantile], [0, 30], 'color', 'r')
line([0, 9], [chi2quantile, chi2quantile], 'color', 'r')
hold on
plot(d_classical(Outfmcd), dfmcd(Outfmcd), 'r+')
xlabel('Mahalanobis Distance')
ylabel('Robust Distance')
title('DD Plot, FMCD method')
axis tight;
set(gcf, 'Color', 'w');
grid on;
%set(gcf,'units','normalized','outerposition',[0 0 1 1])
%orient(fig,'portrait')
print(fig,'1ddplotfmcd.eps','-depsc2')
hold off

fig=figure;
plot(d_classical,dfmcd, 'o')
line([0 9], [0, 9])
xlabel('Mahalanobis Distance')
ylabel('Robust Distance')
title('DD Plot')
grid on ;
axis tight;
set(gcf, 'Color', 'w');
%set(gcf,'units','normalized','outerposition',[0 0 1 1])
%orient(fig,'portrait')
print(fig,'1ddplotlog.eps','-depsc2')
hold off


d_weighted = dfmcd(dfmcd < sqrt(chi2inv(0.975,3)));
d_classical_weighted = d_classical(dfmcd < sqrt(chi2inv(0.975,3)));

% Weighted DD plot

fig=figure;
plot(d_classical_weighted, d_weighted, 'o')
line([0 3.5], [0, 3.5])
xlabel('Mahalanobis Distance')
ylabel('Robust Distance')
title('Weighted DD Plot')
grid on;
axis tight;
set(gcf, 'Color', 'w');
%set(gcf,'units','normalized','outerposition',[0 0 1 1])
%orient(fig,'portrait')
print(fig,'1weightddplot.eps','-depsc2')


fig= figure;
subplot(1,2,1);
plot(d_classical, dfmcd, 'o')
line([chi2quantile, chi2quantile], [0, 30], 'color', 'r')
line([0, 9], [chi2quantile, chi2quantile], 'color', 'r')
hold on
plot(d_classical(Outfmcd), dfmcd(Outfmcd), 'r+')
xlabel('Mahalanobis Distance')
ylabel('Robust Distance')
title('DD Plot, FMCD method')
axis tight;
set(gcf, 'Color', 'w');
grid on;
hold on 
subplot(1,2,2);
plot(d_classical,dfmcd, 'o')
line([0 9], [0, 9])
xlabel('Mahalanobis Distance')
ylabel('Robust Distance')
title('DD Plot')
grid on ;
axis tight;
set(gcf,'units','normalized','outerposition',[0 0 1 1])
orient(fig,'portrait')
print(fig,'combinedfastmcd.eps','-depsc2')
