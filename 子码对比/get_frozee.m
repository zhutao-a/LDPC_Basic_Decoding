function p = get_frozee(SNR_dB,K,N)
%SNR_dB=1.6;  %dB change with demonded SNR
SNR_dec=10^(SNR_dB/10);  %decimal form
sigma2=1/SNR_dec;    %The variance of Gauss noise
%sigma=sqrt(sigma2);
%sigma=0.97865;
m=2/(sigma2);
%n=10;      % code length coefficient 
%N=2^n;
n = log2(N);
%R=0.5;      %change with demanded rate
Mean=zeros(n+1,N);
Mean(1,1:N)=m;
 for k=2:n+1
    for i=1:2:2^(k-1)
        for j=1:N/(2^(k-1))
            Mean(k,(i-1)*N/(2^(k-1))+j)=Phi(Mean(k-1,(i-1)/2*N/(2^(k-2))+2*j-1),Mean(k-1,(i-1)/2*N/(2^(k-2))+2*j));
            Mean(k,i*N/(2^(k-1))+j)=Mean(k-1,(i-1)/2*N/(2^(k-2))+2*j-1)+Mean(k-1,(i-1)/2*N/(2^(k-2))+2*j);
         end
    end
 end

Mean_information_sequence=Mean(n+1,:);
Xk=1:N;
Bk=Mean_information_sequence;

[Bk,id] = sort(Bk,'descend');
Xk = Xk(id);
K_kflag=Xk(1:K);
for z =1:K
    um(K_kflag(z))=1; 
end
p =um;
end