clc;
clear all;
m=;%码率自己定义rate=m/n
n=;
Eb_N0=[0 0.5 1 1.5];%横轴信噪比仿真范围
sigma_2=1/(2*10^(Eb_N0/10)*R);
for num=1:50
s=round(rand(1,n-m));%随机产生长为(n-m)的信息序列
load G%载入生成矩阵
c=mod(s*G,2);                         %LDPC编码
waveform=bpsk(c);                     %BPSK调制
y=waveform+sqrt(sigma_2)*randn(1,n);  %加性高斯白噪声信道
maxiter=？;                        %设置最大译码迭代次数maxiter
[v]=BP1(y,H,sigma_2,maxiter);      %LDPC译码(概率域(SPA1)和对数域上(SPA2)的和积算法,最小和算法(MSA))