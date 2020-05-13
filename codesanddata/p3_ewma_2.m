clc;
clearvars;

%% Load Excess Returns Data 

load excess_returns.mat;
load excess_benchmark_returns.mat;
%% Find lambda which minimizes rmse, mae
w=0:0.01:1;
B1 = arrayfun(@rmse,w);
B2 = arrayfun(@mae,w);
B3 = arrayfun(@hrmse,w);
B4 = arrayfun(@hmae,w);

fun1 = @rmse;
fun2 = @mae;
fun3 = @hrmse;
fun4 = @hmae;

x1 = 0;
x2 = 1;

min_rmse= fminbnd(fun1,x1,x2);
min_mae= fminbnd(fun2,x1,x2);
min_hrmse= fminbnd(fun3,x1,x2);
min_hmae= fminbnd(fun4,x1,x2);

%% Plot rmse and mae as a function of lambda

fig=figure;
hax=axes;
plot(w,B1);
indexmin = find(min(B1) == B1); 
xmin = w(indexmin); 
ymin1 = B1(indexmin);
strmin = ['Minimum = ',num2str(ymin1)];
text(xmin,ymin1,strmin,'HorizontalAlignment','right');
hold on
line([min_rmse min_rmse], get(hax,'YLim'),'Color',[1 0 0]);
grid on;

xlabel('\lambda')
ylabel('RMSE')
title('RMSE as a function of \lambda')
axis tight;
set(gcf, 'Color', 'w');
print(fig,'1RMSE_1.eps','-depsc2')
hold off

 
fig = figure;
hax=axes;
plot(w,B2);
indexmin = find(min(B2) == B2); 
xmin = w(indexmin); 
ymin2 = B2(indexmin);
strmin = ['Minimum = ',num2str(ymin2)];
text(xmin,ymin2,strmin,'HorizontalAlignment','right');
hold on
line([min_mae min_mae], get(hax,'YLim'),'Color',[1 0 0]);
grid on;

xlabel('\lambda')
ylabel('MAE')
title('MAE as a function of \lambda')
axis tight;
set(gcf, 'Color', 'w');
print(fig,'1MAE_1.eps','-depsc2')

% fig=figure;
% hax=axes;
% plot(w,B3);
% indexmin = find(min(B3) == B3); 
% xmin = w(indexmin); 
% ymin = B3(indexmin);
% strmin = ['Minimum = ',num2str(ymin)];
% text(xmin,ymin,strmin,'HorizontalAlignment','right');
% hold on
% line([min_hrmse min_hrmse], get(hax,'YLim'),'Color',[1 0 0]);
% grid on;
% grid minor;
% xlabel('\lambda')
% ylabel('HRMSE')
% title('HRMSE as a function of \lambda')
% axis tight;
% set(gcf, 'Color', 'w');
% print(fig,'1HRMSE_1.eps','-depsc2')
% hold off
% 
% fig = figure;
% hax=axes;
% plot(w,B4);
% indexmin = find(min(B4) == B4); 
% xmin = w(indexmin); 
% ymin = B4(indexmin);
% strmin = ['Minimum = ',num2str(ymin)];
% text(xmin,ymin,strmin,'HorizontalAlignment','right');
% hold on
% line([min_hmae min_hmae], get(hax,'YLim'),'Color',[1 0 0]);
% grid on;
% grid minor;
% xlabel('\lambda')
% ylabel('HMAE')
% title('HMAE as a function of \lambda')
% axis tight;
% set(gcf, 'Color', 'w');
% print(fig,'1HMAE_1.eps','-depsc2')


%% helping functions


function RMSE= rmse(lambda)
load excess_returns.mat;
eem = exs_rts(:,2);
x=eem;
x2=x.^2;
[n,p]=size(x2);
var=zeros(n,p);
var(2,1)=x2(1,1);
for i=2:n-1
    var(i+1,1)=lambda*var(i,1)+(1-lambda)*x2(i,1);
end
e=(x2-var);
RMSE=norm(e)/sqrt(n);
end


function MAE= mae(lambda)
load excess_returns.mat;
eem = exs_rts(:,2);
x=eem;
x2=x.^2;
[n,p]=size(x2);
var=zeros(n,p);
var(2,1)=x2(1,1);
for i=2:n-1
    var(i+1,1)=lambda*var(i,1)+(1-lambda)*x2(i,1);
end
e=(x2-var);
MAE=sum(abs(e))/n;
end

function HRMSE= hrmse(lambda)
load excess_returns.mat;
eem = exs_rts(:,2);
x=eem;
x2=x.^2;
[n,p]=size(x2);
var=zeros(n,p);
var(2,1)=x2(1,1);
for i=2:n-1
    var(i+1,1)=lambda*var(i,1)+(1-lambda)*x2(i,1);
end
e=(var-x2)./x2;
HRMSE=norm(e)/sqrt(n);
end

function HMAE= hmae(lambda)
load excess_returns.mat;
eem = exs_rts(:,2);
x=eem;
x2=x.^2;
[n,p]=size(x2);
var=zeros(n,p);
var(2,1)=x2(1,1);
for i=2:n-1
    var(i+1,1)=lambda*var(i,1)+(1-lambda)*x2(i,1);
end
size(var)
size(x2)
e=(var-x2)./x2;
HMAE=sum(abs(e))/n;
end

