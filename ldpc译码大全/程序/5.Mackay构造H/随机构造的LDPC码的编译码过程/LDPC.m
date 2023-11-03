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
s=round(rand(1,n-m));                 %随机产生长为(n-m)的信息序列

c=mod(s*G,2);                         %LDPC编码

waveform=bpsk(c);                     %BPSK调制           


y=waveform+sqrt(sigma_2)*randn(1,n);  %加性高斯白噪声信道

maxiter=100;                        %设置最大译码迭代次数maxiter
[v]=BP1(y,H,sigma_2,maxiter);      %LDPC译码(概率域(SPA1)和对数域上(SPA2)的和积算法,最小和算法(MSA))

v0=v(m+1:n);
err_max=find(s~=v0);               %寻找错误信息位
num_eer=length(err_max);            %求出错误信息位位数
BER0=num_eer/(n-m)                 %计算比特误码率BER
BER=BER+BER0;
end
BER=BER/10
toc
t=toc

















