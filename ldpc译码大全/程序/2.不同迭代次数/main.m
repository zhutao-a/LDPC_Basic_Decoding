clear all;
close all;
clc;

rows=252;
cols=504;
rate=(cols-rows)/cols;
tic
cycle=5;
amp=1;
H=genH(rows,cols);
someSNR=[0:0.3:3];
ave_BER1=zeros(1,length(someSNR));
ave_BER5=zeros(1,length(someSNR));
ave_BER10=zeros(1,length(someSNR));
ave_BER50=zeros(1,length(someSNR));
ave_BER100=zeros(1,length(someSNR));
count=1;

for S_num=1:length(someSNR) 
    total_num1=0;
    total_num5=0;
    total_num10=0;
    total_num50=0;  
    total_num100=0;    
    SNR=someSNR(S_num);
    EbNo=10.^(SNR/10);
    sigma=1/sqrt(2*rate*EbNo);
    for i=1:cycle
        s=round(rand(1, cols-rows));      
        %use s and H to encode 
        [code,P,rearranged_cols]=ldpc_encode(s,H);    
        tx_code=bpsk(code,amp);                                %编码后的码字     
        re_waveform=tx_code+randn(1,cols)*sigma;               %加噪声后的码字      
       
        %LDPC Decoding 译码后输出的码字
        [vhat1]=bp_decoder1(re_waveform,H,rate,EbNo);          %采用BP译码
        de_mes1= extract_mesg(vhat1,rearranged_cols);
        errors1=find(s~=de_mes1);
        total_num1=total_num1+length(errors1);                 %译码后错误总数    
        
        %LDPC Decoding 译码后输出的码字
        [vhat5]=bp_decoder5(re_waveform,H,rate,EbNo);          %采用BP译码
        de_mes5= extract_mesg(vhat5,rearranged_cols);
        errors5=find(s~=de_mes5);
        total_num5=total_num5+length(errors5);                 %译码后错误总数        
       
        %LDPC Decoding 译码后输出的码字
        %[de_code]=LLRBPdecoder(re_waveform,H,rate,EbNo);      %采用LLR BP译码
        [vhat10]=bp_decoder10(re_waveform,H,rate,EbNo);        %采用BP译码
        de_mes10= extract_mesg(vhat10,rearranged_cols);
        errors10=find(s~=de_mes10);
        total_num10=total_num10+length(errors10);              %译码后错误总数      
        
        %LDPC Decoding 译码后输出的码字
        [vhat50]=bp_decoder50(re_waveform,H,rate,EbNo);        %采用BP译码
        de_mes50= extract_mesg(vhat50,rearranged_cols);
        errors50=find(s~=de_mes50);
        total_num50=total_num50+length(errors50);              %译码后错误总数        
       
        %LDPC Decoding 译码后输出的码字
        [vhat100]=bp_decoder100(re_waveform,H,rate,EbNo);      %采用BP译码
        de_mes100= extract_mesg(vhat100,rearranged_cols);
        errors100=find(s~=de_mes100);
        total_num100=total_num100+length(errors100);           %译码后错误总数
    end
    count=count*1.5;
    ave_BER1(S_num)=total_num1/(count*cycle*(cols-rows));
    ave_BER5(S_num)=total_num5/(count*cycle*(cols-rows));    
    ave_BER10(S_num)=total_num10/(count*cycle*(cols-rows));
    ave_BER50(S_num)=total_num50/(count*cycle*(cols-rows));
    ave_BER100(S_num)=total_num100/(count*cycle*(cols-rows));  
end
toc
figure
plot(someSNR,ave_BER1,'g-*');
hold on;
plot(someSNR,ave_BER5,'r-+');
hold on;
plot(someSNR,ave_BER10,'k-o');
hold on;
plot(someSNR,ave_BER50,'b-.');
hold on;
plot(someSNR,ave_BER100,'y--');
set(gca,'Yscale','log');
ylabel('BER');
xlabel('SNR');
grid on;
title('不同迭代次数对比');
legend('1次','5次','10','50次','100次');