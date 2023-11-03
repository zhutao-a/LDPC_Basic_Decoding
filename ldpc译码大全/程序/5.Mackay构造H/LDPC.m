%tic
clc;
clear all;
m=252;n=504;
%BER=0;
R=(n-m)/n;
%sigma_2=1/(2*10^(Eb_N0/10)*R);
Eb_N0= 0:1:4;
%H=getH(m,n);
load H;
for i=1:length(Eb_N0)
    sigma_2=1/(2*(10^(Eb_N0(i)/10))*R);%%%%????
    BER0(i)=0;
    for num=1:10
        num
        load G;
        s=round(rand(1,n-m));               %随机产生长为(n-m)的信息序列
                                 % RAND(M,N) and RAND([M,N]) are M-by-N matrices 
                                      %with random
                                      %entries.随机生成一个在【0，1】之间的m，n维随机矩阵。
        %save s;
        %load G
        %G=getG(m,n);
       

        c=mod((s*G),2);                         %LDPC编码??为什么有错:Matrix dimensions must agree.
   
        waveform=bpsk(c);                     %BPSK调制           
    

        y=waveform+sqrt(sigma_2)*randn(1,n);  %加性高斯白噪声信道
        
        maxiter=50;                        %设置最大译码迭代次数maxiter
       [v]=BP1(y,H,sigma_2,maxiter)     %LDPC译码(概率域(SPA1)和对数域上(SPA2)的和积算法,最小和算法(MSA))

        v0=v(m+1:n);
        
        %[number,BER]=biterr(s,v0);
        
        err_max=find(s~=v0);               %寻找错误信息位
        num_eer=length(err_max);            %求出错误信息位位数
        BER(i)=num_eer/(n-m);                 %计算比特误码率BER
        BER0(i)=BER(i)+BER0(i);
        end%for num
     BER(i)=BER(i) /50;
     %i=i++;
end %for i
semilogy(Eb_N0,BER,'o-');
grid on;
hold off;
%toc  %程序执行时间  
%t=toc

















