clear all; close all; clc;
format long g%��������ʾΪ�����Ϳ�ѧ����
%���η�����ƵΪ2GHz������1MHz�����ز���128����cpΪ16
%���ز����Ϊ7.8125kHz
%һ��ofdm���ų���Ϊ128us��cp����Ϊ16us
%����16QAM���Ʒ�ʽ
%���dopplerƵ��Ϊ132Hz
%�ྶ�ŵ�Ϊ5���������ӳ��׷��Ӹ�ָ���ֲ�~exp(-t/trms),trms=(1/4)*cpʱ���������ӳ�ȡΪdelay=[0 2e-6 4e-6 8e-6 12e-6]
fprintf( '\n OFDM����\n \n') ; 

pilot_inter=10;%Ĭ�ϵ�Ƶ���ż��Ϊ10,���Ե���������ͬ��Ƶ����µ�BER����������۹�ʽ�Ƚ�
pilot_symbol_bit=[0 0 0 1];%��ƵΪ��������Ӧ������1+3*j
cp_length=16;%Ĭ��cp����Ϊ16
ofdm_symbol_num=100;

loop_num=1;%Ĭ��Ϊ10�η���
xindao_num=128;%Ĭ��Ϊ128��
SNR_dB=[0 2 4 6 8 10 12 14 16 18 20 22];
lr_lmmse_err_ber=zeros(1,length(SNR_dB));
rank=[5 16 20];
for j=1:length(rank)
    RANK=rank(j)
for i=1:length(SNR_dB)%ÿ��SNR���Ϸ������ɴ�һ����12�������
    ls_error_bit=0;
    lmmse_error_bit=0;
    lr_lmmse_error_bit=0;
    total_bit_num=0;
 
for l=1:loop_num
    %ÿ�η������100��ofdm����,��ÿ�η��湲��100��128������ӳ����ţ�16QAM�����£�1������ӳ����Ű���4��bit
    bit_per_carrier=4;%ʹ��16QAM����ÿ�����ź����ĸ�BIT������
    bit_source=input_b(xindao_num,ofdm_symbol_num,bit_per_carrier);%Ϊÿ�η������100��ofdm���ŵı��ظ�����128Ϊÿ��ofdm���ŵ����ز�����
    [nbit,mbit]=size(bit_source);%�����nbitΪ512  mbitΪ100
    total_bit_num=total_bit_num+nbit*mbit;%���ɵ����б����� ÿ������512*100���������� Ҳ����0 1  �������10�εĻ�Ӧ����512000
    
    map_out=map_16qam(bit_source);%��һ�η�����ſ����16QAMӳ��    
    [insert_pilot_out,pilot_num,pilot_sequence]=insert_pilot(pilot_inter,pilot_symbol_bit,map_out);%����״��Ƶ�ṹ����ӳ���Ľ�����뵼Ƶ����
    
    ofdm_modulation_out=ifft(insert_pilot_out,128);%��128����FFT���㣬���ofdm���ư�Ƶ����ʱ��
    ofdm_cp_out=insert_cp(ofdm_modulation_out,cp_length);%����ѭ��ǰ׺
         
    %********************** ���¹���Ϊofdm����ͨ��Ƶ��ѡ���Զྶ�ŵ� *************************
    num=5;%5���ŵ�
         %���蹦���ӳ��׷��Ӹ�ָ���ֲ�~exp(-t/trms),trms=(1/4)*cpʱ����
          %t��0~cpʱ���Ͼ��ȷֲ�
          %��cpʱ��Ϊ16e-6s������ȡ5���ӳ�����
    delay=[0 2e-6 4e-6 8e-6 12e-6];%delay������ʱ,��λs��
    trms=0.25e-6*cp_length;;%trmsΪ�ྭ�ŵ���ƽ����ʱ
    var_pow=10*log10(exp(-delay/trms));%var_pow�������������ƽ������,��λdB��var_pow= 0 -0.542868102379064 -1.0857362047581 -2.17147240951626 -3.25720861427439
    fd=132;%���dopplerƵ��Ϊ132Hz
    t_interval=1e-6;%�������Ϊ1us    %t_intervalΪ��ɢ�ŵ�����ʱ����������OFDM���ų���/(���ز�����+cp����lp)��
    counter=200000;%�����ŵ��Ĳ���������Ӧ�ô����ŵ��������������������������ŵ���������
    count_begin=(l-1)*(5*counter);%ÿ�η����ŵ������Ŀ�ʼλ��
    trms_1=trms/t_interval;
    t_max=16e-6/t_interval;
    %�ŵ�����������ÿ�����Ʒ��Ų�һ����
    passchan_ofdm_symbol=multipath_chann(ofdm_cp_out,num,var_pow,delay,fd,t_interval,counter,count_begin);
    
    %********************** ���Ϲ���Ϊofdm����ͨ��Ƶ��ѡ���Զྶ�ŵ� *************************    
    %********************** ���¹���Ϊofdm���żӸ�˹������ *************************
    snr=10^(SNR_dB(i)/10);%����õ������źŵĹ����������Ĺ���
    [nnl,mml]=size(passchan_ofdm_symbol);%����Ϊ148*110
    spow=0;
    for k=1:nnl
      for b=1:mml
        spow=spow+real(passchan_ofdm_symbol(k,b))^2+imag(passchan_ofdm_symbol(k,b))^2;
      end
    end%���������������ʵ��ƽ�� �鲿ƽ�����
    spow1=spow/(nnl*mml);     %���������ÿ�����ŵĹ���Ҳ���ǹ������ܶ�   
    sgma=sqrt(spow1/(2*snr));%sgma��μ��㣬�뵱ǰSNR���ź�ƽ�������й�ϵ SGMA�Ǹ�˹�������ķ��� ��˹�������Ĺ������ܶ��뷽��Ĺ�ϵsigma^2=N0/2
    receive_ofdm_symbol=add_noise(sgma,passchan_ofdm_symbol);%���������˹��������receive_ofdm_symbolΪ���ս��ջ��յ���ofdm���ſ�
    
    %********************** ���Ϲ���Ϊofdm���żӸ�˹������ *************************
    cutcp_ofdm_symbol=cut_cp(receive_ofdm_symbol,cp_length);%ȥ��ѭ��ǰ׺    
    ofdm_demodulation_out=fft(cutcp_ofdm_symbol,128);%��128��FFT���㣬���ofdm���
    
    %********************** ���¾��ǶԽ���ofdm�źŽ����ŵ����ƺ��źż��Ĺ���************************
    
    low_rank_lmmse_sig=lr_lmmse_estimation(ofdm_demodulation_out,pilot_inter,pilot_sequence,pilot_num,trms_1,t_max,snr,RANK);%���õ���LMMSE�����㷨��������õ��Ľ����ź�
    %********************** ���¾��ǶԽ���ofdm�źŽ����ŵ����ƺ��źż��Ĺ���************************
    
   
    lr_lmmse_receive_bit_sig=de_map(low_rank_lmmse_sig);
    
    %���¹���ͳ�Ƹ��ֹ����㷨�õ��Ľ����ź��еĴ��������
    
 
    lr_lmmse_err_num=error_count(bit_source,lr_lmmse_receive_bit_sig);
    
   
    lr_lmmse_error_bit=lr_lmmse_error_bit+lr_lmmse_err_num;
end
%������ֹ����㷨���������


lr_lmmse_err_ber(i)=lr_lmmse_error_bit/total_bit_num;

end
le_rank_ber(j,:)=lr_lmmse_err_ber;

end

figure

semilogy(SNR_dB,le_rank_ber(1,:),'b-o','markerfacecolor','b')
hold on
semilogy(SNR_dB,le_rank_ber(2,:),'r-s','markerfacecolor','r')
semilogy(SNR_dB,le_rank_ber(3,:),'g-d','markerfacecolor','g')

grid on
legend('RANK=5','RANK=16','RANK=20');
title('��ͬ����LMMSE�㷨�ıȽ�')
xlabel('SNR(dB)')
ylabel('BER(dB)')
