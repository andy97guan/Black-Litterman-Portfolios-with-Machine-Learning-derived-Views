clc;
clearvars;

%% Load Data 


load iyr.mat;


load rf.mat

load spy.mat
load vix.mat
load tb_10.mat

%% Create Date index in number format

Date=datenum(iyr.Date);


%% Create matrix of adjusted close prices

AdjClose=[Date, iyr.AdjClose, spy.AdjClose, vix.AdjClose, tb_10.AdjClose];


%% Create matrix of 1 week returns

[n,p]=size(AdjClose);
rts_1=zeros(n-1,p);
rts_1(:,1)=Date(2:end);

for i=2:p
     rts_1(:,i)= log(AdjClose(2:end,i)./AdjClose(1:end-1,i));
end

N=NaN(1,p-1);
rts1=[N;rts_1(:,2:end)];
week1_rts= [Date,rts1];

%% Create matrix of 2 week returns

rts_2=zeros(n-2,p);
rts_2(:,1)=Date(3:end);
for i=2:p
     rts_2(:,i)= log(AdjClose(3:end,i)./AdjClose(1:end-2,i));
end

rts2=[N;N;rts_2(:,2:end)];
week2_rts= [Date,rts2];

%% Create matrix of 3 week returns

rts_3=zeros(n-3,p);
rts_3(:,1)=Date(4:end);
for i=2:p
     rts_3(:,i)= log(AdjClose(4:end,i)./AdjClose(1:end-3,i));
end

rts3=[N;N;N;rts_3(:,2:end)];
week3_rts= [Date,rts3];

%% Create matrix of 4 week returns

rts_4=zeros(n-4,p);
rts_4(:,1)=Date(5:end);
for i=2:p
     rts_4(:,i)= log(AdjClose(5:end,i)./AdjClose(1:end-4,i));
end

rts4=[N;N;N;N;rts_4(:,2:end)];
week4_rts= [Date,rts4];

%% Combine all the return data

rts_data=[week1_rts,week2_rts(:,2:end),week3_rts(:,2:end),week4_rts(:,2:end)];


%% Create matrix of 1 week excess returns

exs_rts1=NaN(n,5);
exs_rts1(:,1)=Date;

for j=1:4
    for i=1:n
     exs_rts1(i,j+1)=week1_rts(i,j+1)-rf.AdjClose(i,1);
    end
end

%% Create matrix of 2 week excess returns

exs_rts2=NaN(n,5);
exs_rts2(:,1)=Date;

for j=1:4
    for i=3:n
     exs_rts2(i,j+1)=exs_rts1(i,j+1)+exs_rts1(i-1,j+1);
    end
end

%% Create matrix of 3 week excess returns

exs_rts3=NaN(n,5);
exs_rts3(:,1)=Date;

for j=1:4
    for i=4:n
     exs_rts3(i,j+1)=exs_rts1(i,j+1)+exs_rts1(i-1,j+1)+exs_rts1(i-2,j+1);
    end
end

%% Create matrix of 4 week excess returns

exs_rts4=NaN(n,5);
exs_rts4(:,1)=Date;

for j=1:4
    for i=5:n
     exs_rts4(i,j+1)=exs_rts1(i,j+1)+exs_rts1(i-1,j+1)+exs_rts1(i-2,j+1)+exs_rts1(i-3,j+1);
    end
end

%% Create excess returns data
exs_rts_data=[exs_rts1,exs_rts2(:,2:end),exs_rts3(:,2:end),exs_rts4(:,2:end)];

%% Create matrix of Volume rate for iyr

volume=[Date, iyr.Volume];
vol_rate1=NaN(n-1,1);
vol_rate2=NaN(n-2,1);
vol_rate3=NaN(n-3,1);
vol_rate4=NaN(n-4,1);

vol_rate1(:,1)= (volume(2:end,2)./volume(1:end-1,2))-1;
vol_rate2(:,1)= (volume(3:end,2)./volume(1:end-2,2))-1;
vol_rate3(:,1)= (volume(4:end,2)./volume(1:end-3,2))-1;
vol_rate4(:,1)= (volume(5:end,2)./volume(1:end-4,2))-1;

v_rate1=[NaN;vol_rate1];
v_rate2=[NaN;NaN;vol_rate2];
v_rate3=[NaN;NaN;NaN;vol_rate3];
v_rate4=[NaN;NaN;NaN;NaN;vol_rate4];

vol_rate_data=[volume,v_rate1,v_rate2,v_rate3,v_rate4];

%% Target variables

status1=sign(exs_rts1(:,2));
status_target=lagmatrix(status1,-1);

zscore1=NaN(n,1);
zscore=NaN(n,1);
for i=3:n
 zscore1(i,1)=(exs_rts1(i,2)-mean(exs_rts1(i-2:i,2)))/std(exs_rts1(i-2:i,2));
end

for i=4:n
if abs(zscore1(i,1))<1 
    zscore(i,1)=1;
else
    zscore(i,1)=2;
end
end

zscore_target=lagmatrix(zscore,-1);

class=zscore_target.*status_target;


iyr=[exs_rts_data,rts_data(:,2:end), vol_rate_data(:,3:end)];
iyr_lag=lagmatrix(iyr(:,2:end),[0 1 2 3 4 5]) ;
iyr_data=[Date,iyr_lag,status_target,zscore_target, class];

save('features5_iyr.mat','iyr_data');



