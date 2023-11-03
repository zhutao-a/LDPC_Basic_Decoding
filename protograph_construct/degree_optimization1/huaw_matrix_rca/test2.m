clear;
clear all;
tic;
load('LUT.mat');
Protograph=[
2	1	0	0	0	0	1	0	1	0	1	1	0	1	0	0
2	1	1	0	0	0	0	0	1	1	0	0	1	0	1	1
1	0	1	1	0	0	0	0	1	0	1	0	1	0	1	0
1	0	0	1	1	0	0	1	0	1	0	1	0	0	1	1
2	0	0	0	1	1	0	1	0	0	1	1	0	1	0	1
2	0	0	0	0	1	1	1	0	1	0	0	1	1	0	0
]; % example of Octopus MET QC-LDPC Codes R=2/3, 0.1 dB gain compare AR4JA codes

[C,V] = size(Protograph);
iter=8;%iterations numbers
snr_dB_start=2;% starting search point snr value,最大值为16.98
puncture_idx=[];
Punctured_VN=length(puncture_idx);%Number of Punctured Nodes 
Rate=(V-C)/(V-Punctured_VN); %Rate of code only for EB_No_result
M=2; % Modulation 2 bpsk, 4 qpsk
snr_dB_out = RCA_threshold(Protograph,snr_dB_start,puncture_idx,R,snr_R,iter);
EB_No_result= snr_dB_out-10*log10(log2(M)*Rate);

disp(Rate);
disp(EB_No_result);



toc;