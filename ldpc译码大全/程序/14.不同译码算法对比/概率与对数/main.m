clear all;
close all;
clc;

rows=252;
cols=504;
rate=(cols-rows)/cols;
tic
cycle=50;
amp=1;
H=genH(rows,cols);
someSNR=[0:0.3:2];
ave_BER=zeros(1,length(someSNR));
ave_BER1=zeros(1,length(someSNR));
count=0;

for S_num=1:length(someSNR) 
    total_num=0;
    total_num1=0;
    SNR=someSNR(S_num);
    EbNo=10.^(SNR/10);
    sigma=1/sqrt(2*rate*EbNo);
    for i=1:cycle
        s=round(rand(1, cols-rows));      
        %use s and H to encode 
        [code,P,rearranged_cols]=ldpc_encode(s,H);    
        tx_code=bpsk(code,amp);                                %����������     
        re_waveform=tx_code+randn(1,cols)*sigma;               %�������������
        re_code=awgn(tx_code,SNR);
        
  %-------------LLR_BP����--------------
       [de_code]=LLRBPdecoder(re_code,H,rate,EbNo);       %����LLR BP����
       de_mes=extract_mesg(de_code,rearranged_cols);
       errors1=find(s~=de_mes);
       total_num1=total_num1+length(errors1);                    %������������
        
 %-------------BP����--------------
        [vhat]=bp_decoder(re_waveform,H,rate,EbNo);         %����BP����
        de_mes = extract_mesg(vhat,rearranged_cols);
        errors=find(s~=de_mes);
        total_num=total_num+length(errors);                    %������������
    end
    count=count*1.5+1;
    ave_BER1(S_num)=total_num1/(count*cycle*(cols-rows));
    ave_BER(S_num)=total_num/(count*cycle*(cols-rows));    
end
toc
figure
plot(someSNR,ave_BER1,'g-*');
hold on;
plot(someSNR,ave_BER,'r-o');
set(gca,'Yscale','log');
grid on;
ylabel('BER');
xlabel('SNR');
title('����BP�����BP�����㷨�Ա�');
legend('����BP����','����BP����');