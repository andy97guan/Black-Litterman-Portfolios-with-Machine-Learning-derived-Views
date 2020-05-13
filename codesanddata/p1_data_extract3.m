clc;
clearvars;

start_date='01122004';
end_date='08062018';

tb_10 =hist_stock_data(start_date,end_date,'^tnx','frequency','wk');

[n,p]=size(tb_10.AdjClose);

AdjClose=tb_10.AdjClose/5200;
Close=tb_10.Close/5200;
Open=tb_10.Open/5200;
High=tb_10.High/5200;
Low=tb_10.Low/5200;

tb_10.AdjClose=AdjClose;
tb_10.Close=Close;
tb_10.Open=Open;
tb_10.High=High;
tb_10.Low=Low;

save('tb_10.mat','tb_10','end_date','start_date');

plot(tb_10.AdjClose);
%plot(price2ret(tb_10.AdjClose));