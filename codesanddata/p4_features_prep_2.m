clc;
clearvars;

load tb_10.mat

Date=datenum(tb_10.Date);

%% Create matrix of adjusted close prices

op=tb_10.Open;
hi=tb_10.High;
lo=tb_10.Low;
cl=tb_10.AdjClose;
vo=tb_10.Volume;

ohlcv=[Date, op, hi, lo, cl, vo];

%% 1. CCI
cci1                  = indicators([hi,lo,cl]      ,'cci'    ,3,2,0.015);
cci2                  = indicators([hi,lo,cl]      ,'cci'    ,3,3,0.015);
cci3                  = indicators([hi,lo,cl]      ,'cci'    ,3,4,0.015);
cci4                  = indicators([hi,lo,cl]      ,'cci'    ,4,2,0.015);
cci5                  = indicators([hi,lo,cl]      ,'cci'    ,4,3,0.015);
cci6                  = indicators([hi,lo,cl]      ,'cci'    ,4,4,0.015);
cci7                  = indicators([hi,lo,cl]      ,'cci'    ,5,2,0.015);
cci8                  = indicators([hi,lo,cl]      ,'cci'    ,5,3,0.015);
cci9                  = indicators([hi,lo,cl]      ,'cci'    ,5,4,0.015);

CCI=[cci1,cci2,cci3,cci4,cci5,cci6,cci7,cci8,cci9];

%% 2. RSI

rsi1                  = indicators(op           ,'rsi'    ,2);
rsi2                  = indicators(op          ,'rsi'    ,3);
rsi3                  = indicators(op          ,'rsi'    ,4);
rsi4                  = indicators(op           ,'rsi'    ,5);
rsi5                  = indicators(hi           ,'rsi'    ,2);
rsi6                  = indicators(hi           ,'rsi'    ,3);
rsi7                  = indicators(hi           ,'rsi'    ,4);
rsi8                  = indicators(hi           ,'rsi'    ,5);
rsi9                  = indicators(lo           ,'rsi'    ,2);
rsi10                  = indicators(lo           ,'rsi'    ,3);
rsi11                 = indicators(lo           ,'rsi'    ,4);
rsi12                 = indicators(lo           ,'rsi'    ,5);
rsi13                 = indicators(cl           ,'rsi'    ,2);
rsi14                  = indicators(cl           ,'rsi'    ,3);
rsi15                  = indicators(cl           ,'rsi'    ,4);
rsi16                 = indicators(cl           ,'rsi'    ,5);

RSI=[rsi1,rsi2, rsi3, rsi4, rsi5, rsi6, rsi7, rsi8, rsi9, rsi10,rsi11,rsi12,rsi13,rsi14,rsi15, rsi16];

%% 3. roc

roc1                  = indicators(op           ,'roc'    ,2);
roc2                  = indicators(op          ,'roc'    ,3);
roc3                  = indicators(op          ,'roc'    ,4);
roc4                  = indicators(op           ,'roc'    ,5);
roc5                  = indicators(hi           ,'roc'    ,2);
roc6                  = indicators(hi           ,'roc'    ,3);
roc7                  = indicators(hi           ,'roc'    ,4);
roc8                  = indicators(hi           ,'roc'    ,5);
roc9                  = indicators(lo           ,'roc'    ,2);
roc10                  = indicators(lo           ,'roc'    ,3);
roc11                 = indicators(lo           ,'roc'    ,4);
roc12                 = indicators(lo           ,'roc'    ,5);
roc13                 = indicators(cl           ,'roc'    ,2);
roc14                  = indicators(cl           ,'roc'    ,3);
roc15                  = indicators(cl           ,'roc'    ,4);
roc16                 = indicators(cl           ,'roc'    ,5);

ROC=[roc1,roc2, roc3, roc4, roc5, roc6, roc7, roc8, roc9, roc10,roc11,roc12,roc13,roc14,roc15, roc16];


%% 4. Slow Stochastic Oscillator

spctk1        = indicators([hi,lo,cl]      ,'ssto'   ,3,3);
spctk2        = indicators([hi,lo,cl]      ,'ssto'   ,3,4);
spctk3        = indicators([hi,lo,cl]      ,'ssto'   ,3,5);
spctk4        = indicators([hi,lo,cl]      ,'ssto'   ,4,3);
spctk5        = indicators([hi,lo,cl]      ,'ssto'   ,4,4);
spctk6        = indicators([hi,lo,cl]      ,'ssto'   ,4,5);
spctk7        = indicators([hi,lo,cl]      ,'ssto'   ,5,3);
spctk8        = indicators([hi,lo,cl]      ,'ssto'   ,5,4);
spctk9        = indicators([hi,lo,cl]      ,'ssto'   ,5,5);

SSO=[spctk1,spctk2, spctk3, spctk4,spctk5, spctk6, spctk7, spctk8, spctk9];

%% 5. Fast Stochastic Oscillator

fpctk1        = indicators([hi,lo,cl]      ,'fsto'   ,3,3);
fpctk2        = indicators([hi,lo,cl]      ,'fsto'   ,3,4);
fpctk3        = indicators([hi,lo,cl]      ,'fsto'   ,3,5);
fpctk4        = indicators([hi,lo,cl]      ,'fsto'   ,4,3);
fpctk5        = indicators([hi,lo,cl]      ,'fsto'   ,4,4);
fpctk6        = indicators([hi,lo,cl]      ,'fsto'   ,4,5);
fpctk7        = indicators([hi,lo,cl]      ,'fsto'   ,5,3);
fpctk8        = indicators([hi,lo,cl]      ,'fsto'   ,5,4);
fpctk9        = indicators([hi,lo,cl]      ,'fsto'   ,5,5);

FSO=[fpctk1,fpctk2, fpctk3, fpctk4,fpctk5, fpctk6, fpctk7, fpctk8, fpctk9];

%% 6. William

willr1                = indicators([hi,lo,cl]      ,'william',3);
willr2                = indicators([hi,lo,cl]      ,'william',4);
willr3                = indicators([hi,lo,cl]      ,'william',5);
willr4                = indicators([hi,lo,cl]      ,'william',6);

WI=[willr1,willr2,willr3,willr3, willr4];

%% 7. Aroon

aroon1           = indicators([hi,lo]         ,'aroon'  ,3);
aroon2           = indicators([hi,lo]         ,'aroon'  ,4);
aroon3           = indicators([hi,lo]         ,'aroon'  ,5);
aroon4           = indicators([hi,lo]         ,'aroon'  ,6);

AROON = [aroon1, aroon2, aroon3, aroon4];

%% 8. True Strength Index

tsi1                  = indicators(cl              ,'tsi'    ,3,2);
tsi2                  = indicators(cl              ,'tsi'    ,4,2);
tsi3                  = indicators(cl              ,'tsi'    ,5,2);
tsi4                  = indicators(cl              ,'tsi'    ,4,3);
tsi5                  = indicators(cl              ,'tsi'    ,5,3);
tsi6                  = indicators(cl              ,'tsi'    ,5,4);

TSI=[tsi1,tsi2,tsi3, tsi4, tsi5,tsi6];


%% 9. EMA

ema1                  = indicators(cl           ,'ema'    ,2);
ema2                  = indicators(cl           ,'ema'    ,2);
ema3                  = indicators(cl           ,'ema'    ,2);
ema4                  = indicators(cl           ,'ema'    ,2);
ema5                  = indicators(cl           ,'ema'    ,2);
ema6                  = indicators(cl           ,'ema'    ,2);

EMA=[ema1,ema2,ema3, ema4, ema5, ema6];

%% 10. SMA

sma1                  = indicators(cl           ,'sma'    ,2);
sma2                  = indicators(cl           ,'sma'    ,2);
sma3                  = indicators(cl           ,'sma'    ,2);
sma4                  = indicators(cl           ,'sma'    ,2);
sma5                  = indicators(cl           ,'sma'    ,2);
sma6                  = indicators(cl           ,'sma'    ,2);

SMA=[sma1,sma2,sma3, sma4, sma5, sma6];

%% 11. MACD

macd1  = indicators(cl              ,'macd'   ,2,3,1);
macd2  = indicators(cl              ,'macd'   ,3,4,1);
macd3  = indicators(cl              ,'macd'   ,4,5,1);
macd4  = indicators(cl              ,'macd'   ,5,6,1);

MACD=[macd1, macd2, macd3, macd4];

%% 12. ADX

adx1       = indicators([hi,lo,cl]      ,'adx'    ,2);
adx2       = indicators([hi,lo,cl]      ,'adx'    ,3);
adx3       = indicators([hi,lo,cl]      ,'adx'    ,4);
adx4       = indicators([hi,lo,cl]      ,'adx'    ,5);
adx5       = indicators([hi,lo,cl]      ,'adx'    ,6);

ADX=[adx1, adx2, adx3, adx4, adx5];

%% 13. T3

t31                   = indicators(cl          ,'t3'     ,2,0.7);
t32                   = indicators(cl          ,'t3'     ,3,0.7);
t33                   = indicators(cl          ,'t3'     ,4,0.7);
t34                   = indicators(cl          ,'t3'     ,5,0.7);
t35                   = indicators(cl          ,'t3'     ,6,0.7);

T3=[t31,t32,t33, t34, t35];


%% 14. OBV

 OBV                  = indicators([cl,vo]         ,'obv');

%% 15. mfi

mfi1                  = indicators([hi,lo,cl,vo]   ,'mfi'    ,2);
mfi2                  = indicators([hi,lo,cl,vo]   ,'mfi'    ,3);
mfi3                  = indicators([hi,lo,cl,vo]   ,'mfi'    ,4);
mfi4                  = indicators([hi,lo,cl,vo]   ,'mfi'    ,5);
mfi5                  = indicators([hi,lo,cl,vo]   ,'mfi'    ,6);

MFI=[mfi1,mfi2, mfi3,mfi4, mfi5];

%% 16. CMF

cmf1                  = indicators([hi,lo,cl,vo]   ,'cmf'    ,2);
cmf2                  = indicators([hi,lo,cl,vo]   ,'cmf'    ,3);
cmf3                  = indicators([hi,lo,cl,vo]   ,'cmf'    ,4);
cmf4                  = indicators([hi,lo,cl,vo]   ,'cmf'    ,5);
cmf5                  = indicators([hi,lo,cl,vo]   ,'cmf'    ,6);

CMF=[cmf1,cmf2, cmf3,cmf4, cmf5];

%% 17. Force

force1                = indicators([cl,vo]         ,'force'  ,2);
force2                = indicators([cl,vo]         ,'force'  ,3);
force3                = indicators([cl,vo]         ,'force'  ,4);
force4                = indicators([cl,vo]         ,'force'  ,5);
force5                = indicators([cl,vo]         ,'force'  ,6);

FORCE=[force1, force2, force3, force4, force5];

%% 18. Bollinger Bands

boll1 = indicators(cl           ,'boll'   ,3,0,1);
boll2 = indicators(cl           ,'boll'   ,4,0,1);
boll3 = indicators(cl           ,'boll'   ,5,0,1);
boll4 = indicators(cl           ,'boll'   ,6,0,1);
boll5 = indicators(cl           ,'boll'   ,3,0,2);
boll6 = indicators(cl           ,'boll'   ,4,0,2);
boll7 = indicators(cl           ,'boll'   ,5,0,2);
boll8 = indicators(cl           ,'boll'   ,6,0,2);

BOL=[boll1,boll2,boll3,boll4, boll5, boll6, boll7, boll8];

%% 19. ATR

atr1                  = indicators([hi,lo,cl]      ,'atr'    ,3);
atr2                  = indicators([hi,lo,cl]      ,'atr'    ,4);
atr3                  = indicators([hi,lo,cl]      ,'atr'    ,5);
atr4                  = indicators([hi,lo,cl]      ,'atr'    ,6);

ATR=[atr1, atr2, atr3, atr4];

%% 20. VR

vr1                  = indicators([hi,lo,cl]      ,'vr'    ,3);
vr2                  = indicators([hi,lo,cl]      ,'vr'    ,4);
vr3                  = indicators([hi,lo,cl]      ,'vr'    ,5);
vr4                  = indicators([hi,lo,cl]      ,'vr'    ,6);

VR=[vr1, vr2, vr3, vr4];

%% 21. Hhll

hhll1                 = indicators([hi,lo]         ,'hhll'   ,3);
hhll2                 = indicators([hi,lo]         ,'hhll'   ,4);
hhll3                 = indicators([hi,lo]         ,'hhll'   ,5);
hhll4                 = indicators([hi,lo]         ,'hhll'   ,6);

HHLL=[hhll1,hhll2,hhll3,hhll4];


%% Collate all 

momentum=[CCI,RSI,ROC,SSO,FSO,WI,AROON,TSI];
trend=[EMA,SMA,MACD,ADX,T3];
volume=[OBV,MFI,CMF,FORCE];
volatility=[BOL,ATR,VR,HHLL];

tb_10_tech1=[momentum,trend,volume,volatility];
tb_10_tech_data=lagmatrix(tb_10_tech1,[0 1 2 3 4 5]);

save('features9_tb_10_tech.mat','tb_10_tech_data');













