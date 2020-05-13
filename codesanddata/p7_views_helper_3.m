clc;
clearvars;

load cl1_efa_pred.mat
load cl2_efa_pred.mat

load cl1_eem_pred.mat
load cl2_eem_pred.mat

load cl1_gld_pred.mat
load cl2_gld_pred.mat

load cl1_tlt_pred.mat
load cl2_tlt_pred.mat

load cl1_iyr_pred.mat
load cl2_iyr_pred.mat

pmatrix_1=[pred_efa1,pred_eem1,pred_gld1, pred_tlt1,pred_iyr1];
pmatrix_2=[pred_efa2,pred_eem2,pred_gld2, pred_tlt2,pred_iyr2];

pmatrix=zeros(141,5);

for  j=1:5
for i=1:141
    if pmatrix_1(i,j)=='0' && pmatrix_2(i,j)=='0' 
        pmatrix(i,j)=-1;
    elseif pmatrix_1(i,j)=='0' && pmatrix_2(i,j)=='1' 
        pmatrix(i,j)=-2;
    elseif pmatrix_1(i,j)=='1' && pmatrix_2(i,j)=='0' 
         pmatrix(i,j)=1;
    else 
         pmatrix(i,j)=2;
    end
end
end

load p_helper.mat;

C=p_helper==pmatrix;
correct=sum(sum(C));
accuracy=(correct*100)/(141*5);
pmatrix_helper=pmatrix;

save('pmatrix_helper.mat','pmatrix_helper');

