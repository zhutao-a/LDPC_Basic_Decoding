clear;
clear all;
tic;
%%
global  N;              global  M;                
global  E0;
global  vn_deg_min;     global  vn_deg_max;
global  cn_deg_min;     global  cn_deg_max;
N=128;                  M=17;
E0=485;
vn_deg_min=3;           vn_deg_max=17;
cn_deg_min=13;          cn_deg_max=30;
rate=1-M/N;
%%
snr_dB_min=2;
snr_dB_max=5;
puncture_idx=[];
iter=8;
load('LUT.mat');
%%
[deg_per_col,~]=initial_degree();
H = PEG(N, M, deg_per_col, 1);
snr_dB_out = RCA_threshold(H,snr_dB_min,snr_dB_max,puncture_idx,R,snr_R,iter);%二分法计算迭代阈值




Modulate=2; % Modulation 2 bpsk, 4 qpsk
EBN0= snr_dB_out-10*log10(log2(Modulate)*rate);%将结果转换为EBN0
N0 = (1/rate)*(1./exp(EBN0*(log(10)/10))); 
sigma=sqrt(N0/2);
r_ber = normcdf(0, 1, sigma);




toc;