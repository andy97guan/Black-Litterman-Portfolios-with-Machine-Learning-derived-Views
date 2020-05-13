clc;
clearvars;

load excess_returns.mat
load features1_efa_final.mat
load features2_eem_final.mat
load features3_gld_final.mat
load features4_tlt_final.mat
load features5_iyr_final.mat

exs_rts(1,:)=[];
features1_efa_final(1:2,:)=[];
features2_eem_final(1:2,:)=[];
features3_gld_final(1:2,:)=[];
features4_tlt_final(1:2,:)=[];
features5_iyr_final(1:2,:)=[];




exs_rts(end,:)=[];
features1_efa_final(end,:)=[];
features2_eem_final(end,:)=[];
features3_gld_final(end,:)=[];
features4_tlt_final(end,:)=[];
features5_iyr_final(end,:)=[];


save('rawfeatures_1.mat');

load excess_benchmark_returns.mat
exs_bm_rts(1,:)=[];
exs_bm_rts(end,:)=[];
save('exs_bm_rts_cleaned.mat','exs_bm_rts');





