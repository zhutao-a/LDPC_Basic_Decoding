clear;
clear all;
tic;
%%
%����protograph����Ϊ�ľ���368��80����puncture��8��
H=load('base_matrix.txt');
H(H>=0)=1;
H(H==-1)=0;%��������-1��Ϊ0�����Ϊ1
%%
%����Ļ�������
[C,V] = size(H);
punc_idx=[42,88,134,180,226,272,318,364];
punc_len=length(punc_idx);%Number of Punctured Nodes 
rate=(V-C)/(V-punc_len); %Rate of code only for EB_No_result
%%
%����RCA�㷨���������ֵ�Ĳ���
load('LUT.mat');
iter=8;%iterations numbers
snr_dB_min=0;
snr_dB_max=10;
%%
%����RCA���㲻ͬ���������ĵ�����ֵ
snr_dB_out = RCA_threshold(H,snr_dB_min,snr_dB_max,punc_idx,R,snr_R,iter);%���ַ����������ֵ
M=2; % Modulation 2 bpsk, 4 qpsk
EBN0= snr_dB_out-10*log10(log2(M)*rate);%�����ת��ΪEBN0
disp(EBN0);
N0 = (1/rate)*(1./exp(EBN0*(log(10)/10))); 
sigma=sqrt(N0/2);
r_ber = normcdf(0, 1, sigma);
disp(r_ber);
toc;






