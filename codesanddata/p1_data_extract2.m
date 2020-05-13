clc;
clearvars;

%%
start_date='01122004'; % start date of sample
end_date='08062018'; % end date of sample

%% 
rf =hist_stock_data(start_date,end_date,'^irx','frequency','wk');

[n,p]=size(rf.AdjClose);

AdjClose=rf.AdjClose/5200; % since the price is 100 times percentage divide it by 100 and to convert to weekly divide by 52
Close=rf.Close/5200;
Open=rf.Open/5200;
High=rf.High/5200;
Low=rf.Low/5200;

rf.AdjClose=AdjClose;
rf.Close=Close;
rf.Open=Open;
rf.High=High;
rf.Low=Low;

save('rf.mat','rf','end_date','start_date');

plot(rf.AdjClose);
%plot(price2ret(rf.AdjClose));