clear all;
close all;
clc;

rows=256;
cols=512;
rate=(cols-rows)/cols;
tic
cycle=100;
amp=1;
H=genH(rows,cols);
someSNR=[0:0.3:2.1];
ave_BER=zeros(1,length(someSNR));
ave_BER1=zeros(1,length(someSNR));
count=1;

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
        tx_code=bpsk(code,amp);                                %编码后的码字     
        re_waveform=tx_code+randn(1,cols)*sigma;               %加噪声后的码字
        re_code=awgn(tx_code,SNR);
        
  %-------------LLR_BP译码--------------
       [de_code]=LLRBPdecoder(re_code,H,rate,EbNo);        %采用LLR BP译码
       de_mes = extract_mesg(de_code,rearranged_cols);
       errors=find(s~=de_mes);
       total_num=total_num+length(errors);                     %译码后错误总数
        
  %-----------最小和译码-------------
       [de_code1]=Min_decoding(re_waveform,EbNo,H,rows,cols);
       de_mes1= extract_mesg(de_code1,rearranged_cols);
       errors1=find(s~=de_mes1);
       total_num1=total_num1+length(errors1);     
    end
    count=count*1.9;
    ave_BER(S_num)=total_num/(count*cycle*(cols-rows));  
    ave_BER1(S_num)=total_num1/(count*cycle*(cols-rows));    
end
toc
figure
plot(someSNR,ave_BER,'g-*');
hold on;
plot(someSNR,ave_BER1,'r-+');
set(gca,'Yscale','log');
grid on;
ylabel('BER');
xlabel('SNR');
title('不同译码算法对比');
legend('概率BP译码','最小和译码');