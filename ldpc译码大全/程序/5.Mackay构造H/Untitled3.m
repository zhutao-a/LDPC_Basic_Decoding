clc;
clear all;
m=;%�����Լ�����rate=m/n
n=;
Eb_N0=[0 0.5 1 1.5];%��������ȷ��淶Χ
sigma_2=1/(2*10^(Eb_N0/10)*R);
for num=1:50
s=round(rand(1,n-m));%���������Ϊ(n-m)����Ϣ����
load G%�������ɾ���
c=mod(s*G,2);                         %LDPC����
waveform=bpsk(c);                     %BPSK����
y=waveform+sqrt(sigma_2)*randn(1,n);  %���Ը�˹�������ŵ�
maxiter=��;                        %������������������maxiter
[v]=BP1(y,H,sigma_2,maxiter);      %LDPC����(������(SPA1)�Ͷ�������(SPA2)�ĺͻ��㷨,��С���㷨(MSA))