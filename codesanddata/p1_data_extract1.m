clc;
clearvars;

start_date='01122004';
end_date='08062018';

 
pf =hist_stock_data(start_date,end_date,'efa','eem','gld','tlt','iyr','frequency','wk');
rf =hist_stock_data(start_date,end_date,'^irx','frequency','wk');
bm =hist_stock_data(start_date,end_date,'iwb','frequency','wk');







