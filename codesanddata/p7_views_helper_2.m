clc;
clearvars;

load cl2_iyr_features.mat

pred_iyr2=zeros(141,1);
pred_iyr2=categorical(pred_iyr2);

for i=1:141

X=X2_iyr(1:561+i,:);
Y=Y2_iyr(1:561+i,:);

X_train=X(1:end-1,:);
Y_train=Y(1:end-1,:);

X_test=X(end,:);
Y_test=Y(end,:);

mdl = TreeBagger(100,X_train,Y_train,'OOBPrediction','On',...
    'Method','classification');
label = predict(mdl,X_test);

result=label==Y_test;

switch(result)
    case 0
        stat = ['No match. Predicted =',label,' and Actual = ', Y_test];
       disp(stat);
    case 1
       stat = ['Match. Predicted =',label,' and Actual = ', Y_test];
       disp(stat);
end

pred_iyr2(i,1)=label;
end

save('cl2_iyr_pred.mat','pred_iyr2');