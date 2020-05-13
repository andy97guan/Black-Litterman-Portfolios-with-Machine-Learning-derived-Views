clc;
clearvars;

load features1_efa.mat
load features1_efa_tech.mat

load features2_eem.mat
load features2_eem_tech.mat

load features3_gld.mat
load features3_gld_tech.mat

load features4_tlt.mat
load features4_tlt_tech.mat

load features5_iyr.mat
load features5_iyr_tech.mat

load features6_rf_tech.mat
load features7_spy_tech.mat
load features8_vix_tech.mat
load features9_tb_10_tech.mat

other_tech_data=[rf_tech_data,spy_tech_data,vix_tech_data,tb_10_tech_data];

features1_efa_final=[efa_data(:,1),efa_tech_data,other_tech_data,efa_data(:,2:end)];
features2_eem_final=[eem_data(:,1),eem_tech_data,other_tech_data,eem_data(:,2:end)];
features3_gld_final=[gld_data(:,1),gld_tech_data,other_tech_data,gld_data(:,2:end)];
features4_tlt_final=[tlt_data(:,1),tlt_tech_data,other_tech_data,tlt_data(:,2:end)];
features5_iyr_final=[iyr_data(:,1),iyr_tech_data,other_tech_data,iyr_data(:,2:end)];

save('features1_efa_final.mat','features1_efa_final');
save('features2_eem_final.mat','features2_eem_final');
save('features3_gld_final.mat','features3_gld_final');
save('features4_tlt_final.mat','features4_tlt_final');
save('features5_iyr_final.mat','features5_iyr_final');
