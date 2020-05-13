clc;
clearvars;

load cl1_iyr_features.mat

pred_iyr1=NaN(141,1);
pred_iyr1=categorical(pred_iyr1);

for i=1:141

X=X1_iyr(1:561+i,:);
Y=Y1_iyr(1:561+i,:);

X_train=X(1:end-1,:);
Y_train=Y(1:end-1,:);

X_test=X(end,:);
Y_test=Y(end,:);

mdl = TreeBagger(100,X_train,Y_train,'OOBPrediction','On',...
    'Method','classification');
label = predict(mdl,X_test);

label=categorical(label);

result=label==Y_test;

switch(result)
    case 0
        stat = ['No match. Predicted =',label,' and Actual = ', Y_test];
       disp(stat);
    case 1
        stat = ['Match.    Predicted =',label,' and Actual = ', Y_test];
       disp(stat);
end

pred_iyr1(i,1)=label;
end

save('cl1_iyr_pred.mat','pred_iyr1');
