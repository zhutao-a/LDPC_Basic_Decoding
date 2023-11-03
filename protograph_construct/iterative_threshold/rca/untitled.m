clear;
clear all;
tic;
%%
%给出protograph，华为的矩阵（368，80），puncture掉8列
H=load('base_matrix.txt');
H(H>=0)=1;
H(H==-1)=0;%将矩阵中-1变为0其余变为1
%%
%矩阵的基本参数
[C,V] = size(H);
punc_idx=[42,88,134,180,226,272,318,364];
punc_len=length(punc_idx);%Number of Punctured Nodes 
rate=(V-C)/(V-punc_len); %Rate of code only for EB_No_result
%%
%设置RCA算法计算迭代阈值的参数
load('LUT.mat');
iter=8;%iterations numbers
snr_dB_min=0;
snr_dB_max=10;
%%
%利用RCA计算不同迭代次数的迭代阈值
snr_dB_out = RCA_threshold(H,snr_dB_min,snr_dB_max,punc_idx,R,snr_R,iter);%二分法计算迭代阈值
M=2; % Modulation 2 bpsk, 4 qpsk
EBN0= snr_dB_out-10*log10(log2(M)*rate);%将结果转换为EBN0
disp(EBN0);
N0 = (1/rate)*(1./exp(EBN0*(log(10)/10))); 
sigma=sqrt(N0/2);
r_ber = normcdf(0, 1, sigma);
disp(r_ber);
toc;






