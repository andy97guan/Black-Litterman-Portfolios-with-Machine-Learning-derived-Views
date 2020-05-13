clc;
clearvars;

load cl2_iyr_features.mat;

n=size(Y2_iyr,1);
split=round(0.8*n);

xtrain=X2_iyr(1:split,:);
xtest=X2_iyr(split+1:end,:);

ytrain=Y2_iyr(1:split,1);
ytest=Y2_iyr(split+1:end,1);

%% Model1: Logistic Regression

mdl1 = fitglm(xtrain,ytrain,'quadratic','distr','binomial');
score_train1 = mdl1.Fitted.Probability; % Probability estimates

[X_train1,Y_train1,T_train1,AUC_train1] = perfcurve(ytrain,score_train1,'1');

[yprobpred1,ypredci1] = predict(mdl1,xtest);

ypred1=zeros(length(yprobpred1),1);

for i=1:length(yprobpred1)
    if yprobpred1(i,1)<=0.5 
        ypred1(i,1)=0;
    else
        ypred1(i,1)=1;
    end
end

ypred1=categorical(ypred1);
confusion1=confusionmat(ytest,ypred1);

%% Model 2: SVM

mdl2 = fitcsvm(xtrain,ytrain);
mdl2 = fitPosterior(mdl2);
[~,score_train2] = resubPredict(mdl2);

[X_train2,Y_train2,T_train2,AUC_train2] = perfcurve(ytrain,score_train2(:,2),'1');

label2 = predict(mdl2,xtest);
confusion2=confusionmat(ytest,label2);

%% Model 3: Naive Bayes Classifier.

mdl3 = fitcnb(xtrain,ytrain);
[~,score_train3] = resubPredict(mdl3);

[X_train3,Y_train3,T_train3,AUC_train3] = perfcurve(ytrain,score_train3(:,2),'1');

label3 = predict(mdl3,xtest);
confusion3=confusionmat(ytest,label3);

%% Model 4: Ensemble Adaboost Classifier


mdl4 = fitensemble(xtrain,ytrain,'AdaBoostM1',100,'Tree');

[~, score_train4] = predict(mdl4,xtrain);

[X_train4,Y_train4,T_train4,AUC_train4] = perfcurve(ytrain, score_train4(:,2),'1');

label4 = predict(mdl4,xtest);
confusion4=confusionmat(ytest,label4);

%% Model 5: Bagging 

mdl5 = fitensemble(xtrain,ytrain,'Bag',12,'Tree','Type','Classification');

[~, score_train5] = predict(mdl5,xtrain);

[X_train5,Y_train5,T_train5,AUC_train5] = perfcurve(ytrain, score_train5(:,2),'1');


label5 = predict(mdl5,xtest);
confusion5=confusionmat(ytest,label5);

figure;
plot(loss(mdl5,xtest,ytest,'mode','cumulative'));
xlabel('Number of trees');
ylabel('Test classification error');

%% Model 6: Random Forests

mdl6 = TreeBagger(100,xtrain,ytrain,'OOBPrediction','On',...
    'Method','classification');

[~, score_train6] = predict(mdl6,xtrain);

[X_train6,Y_train6,T_train6,AUC_train6] = perfcurve(ytrain, score_train5(:,2),'1');


label6 = predict(mdl6,xtest);
label6=categorical(label6);
confusion6=confusionmat(ytest,label6);

%%
fig=figure;
plot(X_train1,Y_train1);
hold on;
grid on;
plot(X_train2,Y_train2);
plot(X_train3,Y_train3);
plot(X_train4,Y_train4);
plot(X_train5,Y_train5);
plot(X_train6,Y_train6);
legend(['AUC=' num2str(AUC_train1) ': Logistic Regression'],...
    ['AUC=' num2str(AUC_train2) ': SVM'],...
    ['AUC=' num2str(AUC_train3) ': Naive Bayes'],...
    ['AUC=' num2str(AUC_train4) ': Adaboost'],...
    ['AUC=' num2str(AUC_train5) ': Bagging'],...
    ['AUC=' num2str(AUC_train6) ': Random Forests'],...
    'Location','Best');
xlabel('False positive rate'); ylabel('True positive rate');
title('ROC Curves for |z-score| of next weeks IYR excess return')
axis tight;
set(gcf, 'Color', 'w');
print(fig,'iyr_c2_train.eps','-depsc2')
hold off

confusion_c2_iyr=[confusion1;confusion2;confusion3;confusion4;confusion5;confusion6];
save('confusion_c2_iyr.mat','confusion_c2_iyr');
