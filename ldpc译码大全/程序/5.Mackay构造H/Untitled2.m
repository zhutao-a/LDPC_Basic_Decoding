clc;
clear all;
m=252;n=504;
R=(n-m)/n;
Eb_N0=0:1:4;
%H=getH(m,n);
load H;
%H
frame=50;
%G=getG(m,n);
load G;
%G

for i=1:length(Eb_N0)
    sigma_2=1/(2*(10^(Eb_N0(i)/10))*R)
    ber0(i)=0;
    %i
    %sigma_2
    for num=1:frame  
        num
        x = (sign(randn(1,size(G,1)))+1)/2 % random bits
        y = mod(x*G,2);                     % coding 
        z = 2*y-1;                         % BPSK modulation
        z=z + sigma_2*randn(1,size(G,2));     % AWGN transmission
        f1=1./(1+exp(-2*z/sigma_2));        % likelihoods
        f0=1-f1;
        [z_hat, success, k] = ldpc_decode(z,f0,f1,H);
        x_hat = z_hat(size(G,2)+1-size(G,1):size(G,2));
        x_hat = x_hat'
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
semilogy(Eb_N0,ber0,'o-');
grid on;
hold off;
        
        
        
        
        
        
        
        