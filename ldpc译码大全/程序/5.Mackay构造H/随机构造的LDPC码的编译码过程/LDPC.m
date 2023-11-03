tic
m=252;n=504;Eb_N0=1.5;
BER=0;
R=(n-m)/n;
sigma_2=1/(2*10^(Eb_N0/10)*R);
load H;
load G;
%H=getH(m,n);
%G=getG(m,n);
for num=1:10
    num
s=round(rand(1,n-m));                 %���������Ϊ(n-m)����Ϣ����

c=mod(s*G,2);                         %LDPC����

waveform=bpsk(c);                     %BPSK����           


y=waveform+sqrt(sigma_2)*randn(1,n);  %���Ը�˹�������ŵ�

maxiter=100;                        %������������������maxiter
[v]=BP1(y,H,sigma_2,maxiter);      %LDPC����(������(SPA1)�Ͷ�������(SPA2)�ĺͻ��㷨,��С���㷨(MSA))

v0=v(m+1:n);
err_max=find(s~=v0);               %Ѱ�Ҵ�����Ϣλ
num_eer=length(err_max);            %���������Ϣλλ��
BER0=num_eer/(n-m)                 %�������������BER
BER=BER+BER0;
end
BER=BER/10
toc
t=toc

















