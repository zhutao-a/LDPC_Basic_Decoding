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
        s=round(rand(1,n-m));               %���������Ϊ(n-m)����Ϣ����
                                 % RAND(M,N) and RAND([M,N]) are M-by-N matrices 
                                      %with random
                                      %entries.�������һ���ڡ�0��1��֮���m��nά�������
        %save s;
        %load G
        %G=getG(m,n);
       

        c=mod((s*G),2);                         %LDPC����??Ϊʲô�д�:Matrix dimensions must agree.
   
        waveform=bpsk(c);                     %BPSK����           
    

        y=waveform+sqrt(sigma_2)*randn(1,n);  %���Ը�˹�������ŵ�
        
        maxiter=50;                        %������������������maxiter
       [v]=BP1(y,H,sigma_2,maxiter)     %LDPC����(������(SPA1)�Ͷ�������(SPA2)�ĺͻ��㷨,��С���㷨(MSA))

        v0=v(m+1:n);
        
        %[number,BER]=biterr(s,v0);
        
        err_max=find(s~=v0);               %Ѱ�Ҵ�����Ϣλ
        num_eer=length(err_max);            %���������Ϣλλ��
        BER(i)=num_eer/(n-m);                 %�������������BER
        BER0(i)=BER(i)+BER0(i);
        end%for num
     BER(i)=BER(i) /50;
     %i=i++;
end %for i
semilogy(Eb_N0,BER,'o-');
grid on;
hold off;
%toc  %����ִ��ʱ��  
%t=toc

















