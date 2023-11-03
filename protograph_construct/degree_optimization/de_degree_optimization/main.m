clear;
clear all;
tic;
%%
%protograph的参数
global N;   global M;
global vn_deg_min;  global vn_deg_max;
global cn_deg_min;  global cn_deg_max;
global punc_idx;
M=17;%protograph的行数
N=128;%protograph的列数
vn_deg_min=3;
vn_deg_max=17;
cn_deg_min=13;
cn_deg_max=30;
punc_idx=[];%被puncture的列索引
punc_len=length(punc_idx);
rate=(N-M)/(N-punc_len);
%%
%GA计算迭代阈值的参数
global Pe;          global iter;
global sig_min;     global sig_max;
Pe = 1e-6;%最小错误概率
iter = 8;%设置最大的迭代次数
sig_min=0.4;
sig_max=0.6;
%%
%初始化种群
global NP;      global F;   global CR;
NP=100;
F=1;
CR=0.1;
E=465:5:505;
sigma=zeros(length(E),1);
deg_per_col=zeros(length(E),N);
deg_per_row=zeros(length(E),M);
for i=1:length(E)
    disp(i);
    [sigma(i),deg_per_col(i,:),deg_per_row(i,:)]=E_fixed(E(i));
    disp(sigma(i));
end

toc;








