clear all;
close all;
clc;

rows=128    ;
cols=256;
rate=(cols-rows)/cols;
tic
%循环次数，自己根据需要改
cycle=500;
amp=1;
H=genH(rows,cols);
someSNR=[0:0.5:4];
hard_ave_BER=zeros(1,length(someSNR));
ave_BER=zeros(1,length(someSNR));
count=1;

for S_num=1:length(someSNR) 
    total_num=0;
    hard_total_num=0;
    SNR=someSNR(S_num);
    EbNo=10.^(SNR/10);
    sigma=1/sqrt(2*rate*EbNo);
    for i=1:cycle
        s=round(rand(1, cols-rows));      
        %use s and H to encode 
        [code,P,rearranged_cols]=ldpc_encode(s,H);    
        tx_code=bpsk(code,amp);                                %编码后的码字     
        re_waveform=tx_code+randn(1,cols)*sigma;               %加噪声后的码字
        %re_code=awgn(tx_waveform,SNR);
        
        %不进行译码，直接硬判决译码
        hard_code1=sign(re_waveform);
        hard_code=(1-hard_code1)./2;
        hard_mes= extract_mesg(hard_code,rearranged_cols);
        hard_errors=find(hard_mes~=s);
        hard_total_num=hard_total_num+length(hard_errors);     %硬判决错误总数
        
        %LDPC Decoding 译码后输出的码字
        %[de_code]=LLRBPdecoder(re_waveform,H,rate,EbNo);       %采用LLR BP译码
        [vhat]=bp_decoder(re_waveform,H,rate,EbNo);         %采用BP译码
        de_mes = extract_mesg(vhat,rearranged_cols);
        errors=find(s~=de_mes);
        total_num=total_num+length(errors);                    %译码后错误总数
    end
    count=count*1.5;
    hard_ave_BER(S_num)=hard_total_num/(count*cycle*(cols-rows));
    ave_BER(S_num)=total_num/(count*cycle*(cols-rows));    
end
toc
disp(ave_BER);
figure
%plot(someSNR,hard_ave_BER,'g-*');
hold on;
plot(someSNR,ave_BER,'k-+');
set(gca,'Yscale','log');
grid on;
ylabel('BER');
xlabel('SNR');
%title('BP与PF译码算法对比');
legend('BP译码');