clear all;
close all;
clc;

rows=128    ;
cols=256;
rate=(cols-rows)/cols;
tic
%ѭ���������Լ�������Ҫ��
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
        tx_code=bpsk(code,amp);                                %����������     
        re_waveform=tx_code+randn(1,cols)*sigma;               %�������������
        %re_code=awgn(tx_waveform,SNR);
        
        %���������룬ֱ��Ӳ�о�����
        hard_code1=sign(re_waveform);
        hard_code=(1-hard_code1)./2;
        hard_mes= extract_mesg(hard_code,rearranged_cols);
        hard_errors=find(hard_mes~=s);
        hard_total_num=hard_total_num+length(hard_errors);     %Ӳ�о���������
        
        %LDPC Decoding ��������������
        %[de_code]=LLRBPdecoder(re_waveform,H,rate,EbNo);       %����LLR BP����
        [vhat]=bp_decoder(re_waveform,H,rate,EbNo);         %����BP����
        de_mes = extract_mesg(vhat,rearranged_cols);
        errors=find(s~=de_mes);
        total_num=total_num+length(errors);                    %������������
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
%title('BP��PF�����㷨�Ա�');
legend('BP����');