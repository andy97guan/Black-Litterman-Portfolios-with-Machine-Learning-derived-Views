clc;
clearvars;

load rawfeatures_1.mat

features5_iyr_final(:,[end-2,end])=[]; % keep only columns required for 1st classification
u=features5_iyr_final;
u = u(:,any(diff(u,1))); % remove constant columns
u1=isnan(u);
u2=sum(u1);
u3=find(u2>5); % remove columns with more than 5 NaN
u(:,u3)=[];

% Impute Data using knn

u=knnimpute(u);

z= u(:,2:end); % remove index

%% Prepare X and Y 

X=z(:,1:end-1);

Y1=z(:,end);
n=size(Y1,1);
Y=zeros(n,1);
for i=1:n
    if Y1(i,1)==1 
        Y(i,1)=0;
    else 
        Y(i,1)=1;
    end
end

Y=categorical(Y);


%% Find Significance of variables 

Sig = indep_features(X,Y);
fig=figure;
bar(Sig)
xlabel 'Feature Number'
ylabel 'significance level'
title('Weiss/Indurkhya independent features significance testing method')
axis tight;
set(gcf, 'Color', 'w');
print(fig,'significance_testing1.eps','-depsc2')

I1 = find(Sig>1.5);
X=X(:,I1);

b = TreeBagger(100,X,Y,'Method','R','OOBVarImp','On','Method','Classification');

fig=figure;
bar(b.OOBPermutedVarDeltaError)
xlabel 'Feature Number'
ylabel 'Out-of-Bag Feature Importance'
title('Curvature test')
axis tight;
set(gcf, 'Color', 'w');
print(fig,'curvature_test1.eps','-depsc2')
[~,sortIndex1] = sort(b.OOBPermutedVarDeltaError,'descend');  
I2 = sortIndex1(1:10);
X=X(:,I2);


X2_iyr=X;
Y2_iyr=Y;

save('cl2_iyr_features.mat','X2_iyr','Y2_iyr');

save('exs_rts_cleaned.mat','exs_rts');

