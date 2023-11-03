clear;
clear all;

load('LUT.mat');
H=load('base_matrix.txt');
H(H>=0)=1;
H(H==-1)=0;%将矩阵中-1变为0其余变为1

[C,V] = size(H);
iter=50;%iterations numbers
snr_dB_start=3;% starting search point snr value,最大值为16.98
% puncture_idx=[42,88,134,180,226,272,318,364];
puncture_idx=[42,88,134,180,226,272,318,364];
Punctured_VN=length(puncture_idx);%Number of Punctured Nodes 
Rate=(V-C)/(V-Punctured_VN); %Rate of code only for EB_No_result
M=2; % Modulation 2 bpsk, 4 qpsk
tic;
snr_dB_out = RCA_threshold(H,snr_dB_start,puncture_idx,R,snr_R,iter);
toc;
EB_No_result= snr_dB_out-10*log10(log2(M)*Rate);

disp(Rate);
disp(EB_No_result);



