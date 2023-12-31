clc;
clear all;
m=128;n=256;
R=(n-m)/n
Eb_N0=0:0.5:3;
H=genH(rows,cols);
%H=getH(m,n)
%load H;
frame=5;
G=getG(m,n);
%load G;


    for i=1:length(Eb_N0)
    %sigma_2=1/(2*(10^(Eb_N0(i)/10))*R) 
    sigma=sqrt(1./(2*10^(Eb_N0(i)/10)*R));
    %N0 = 1/(exp(Eb_N0(i)*log(10)/10))
    ber0(i)=0;
    %sigma_2
    %i
    for num=1:frame  
        num
        %x=round(rand(1,n-m));
        x = (sign(randn(1,size(G,1)))+1)/2; % random bits
        y = mod(x*G,2);                     % coding 
        bpskmod = 2*y-1;                          %BPSK modulation
       
        %z = bpskmod + sqrt(sigma_2)*randn(size(bpskmod));%经高斯噪声后的信息序列，也是准备译码的序列
        z=bpskmod + sigma*randn(1,size(G,2));   % AWGN transmission
        f1=1./(1+exp(-2*z/(sigma^2)));         % likelihoods
        f0=1-f1;
        [z_hat, success, k] = ldpc_decode(z,f0,f1,H);
        x_hat = z_hat(size(G,2)+1-size(G,1):size(G,2));
        x_hat = x_hat';
        err_max=find(x~=x_hat);             %寻找错误信息位
        num_eer=length(err_max)           %求出错误信息位位数
        ber(i)=num_eer/(n-m);               %计算比特误码率BER
        ber0(i)=ber(i)+ber0(i);
        %ber(i);
        %ber0(i);
        %k;
        
    end %for num
    ber0(i)=ber0(i)/frame
    
end %for i
semilogy(Eb_N0,ber0,'s--k');
xlabel('信噪比','fontweight','bold');
ylabel('平均误码率','fontweight','bold');
title('ldpc在awgn下性能仿真','fontsize',12,'fontweight','bold','fontname','黑体')
%legend('r=1/2,L=512'，'r=1/2,L=256'，'r=1/2,L=192');
hold on;
grid on;
%hold off;
        
        
        
        
        
        
        
        