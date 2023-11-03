clear;
clear all;
% tic;
%%
%GA���������ֵ�Ĳ���
Pe = 1e-20;%��С�������
iter = 8;%�������ĵ�������
sigma_min=0.4;
sigma_max=0.6;

M=30;%protograph������
N=180;%protograph������
load('punc7_30_180_dv_3.9.mat');
punc_idx=[1,2,3,4,5,6,7];%��1�б�puncture
punc_len=length(punc_idx);
rate=(N-M)/(N-punc_len);


%ͨ��ÿ��ÿ�еĶȼ�����ȷֲ�,ͬʱ����puncture���Ķ��Լ�����
[vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop]=deg_distr(deg_per_col_best,deg_per_row_best,punc_idx);
%���ַ����������ֵ
[sigma_best,Pe]=GA_threshold_punc(sigma_min,sigma_max,iter,Pe,vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop);
ebn0=1/(2*rate*sigma_best^2);
EBN0=10*log10(ebn0);
disp(EBN0);



