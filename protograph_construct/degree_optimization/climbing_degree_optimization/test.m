clear;
clear all;
% tic;
%%
%GA计算迭代阈值的参数
Pe = 1e-20;%最小错误概率
iter = 8;%设置最大的迭代次数
sigma_min=0.4;
sigma_max=0.6;

M=30;%protograph的行数
N=180;%protograph的列数
load('punc7_30_180_dv_3.9.mat');
punc_idx=[1,2,3,4,5,6,7];%第1列被puncture
punc_len=length(punc_idx);
rate=(N-M)/(N-punc_len);


%通过每行每列的度计算出度分布,同时给出puncture掉的度以及比例
[vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop]=deg_distr(deg_per_col_best,deg_per_row_best,punc_idx);
%二分法计算迭代阈值
[sigma_best,Pe]=GA_threshold_punc(sigma_min,sigma_max,iter,Pe,vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop);
ebn0=1/(2*rate*sigma_best^2);
EBN0=10*log10(ebn0);
disp(EBN0);



