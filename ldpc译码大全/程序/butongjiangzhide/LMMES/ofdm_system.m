clear all; close all; clc;
format long g%将数据显示为长整型科学计数
%本次仿真载频为2GHz，带宽1MHz，子载波数128个，cp为16
%子载波间隔为7.8125kHz
%一个ofdm符号长度为128us，cp长度为16us
%采用16QAM调制方式
%最大doppler频率为132Hz
%多径信道为5径，功率延迟谱服从负指数分布~exp(-t/trms),trms=(1/4)*cp时长，各径延迟取为delay=[0 2e-6 4e-6 8e-6 12e-6]
fprintf( '\n OFDM仿真\n \n') ; 

pilot_inter=10;%默认导频符号间隔为10,可以调整，看不同导频间隔下的BER情况，和理论公式比较
pilot_symbol_bit=[0 0 0 1];%导频为常数，对应星座点1+3*j
cp_length=16;%默认cp长度为16
ofdm_symbol_num=100;

loop_num=1;%默认为10次仿真
xindao_num=128;%默认为128个
SNR_dB=[0 2 4 6 8 10 12 14 16 18 20 22];
lr_lmmse_err_ber=zeros(1,length(SNR_dB));
rank=[5 16 20];
for j=1:length(rank)
    RANK=rank(j)
for i=1:length(SNR_dB)%每个SNR点上仿真若干次一共是12个信噪比
    ls_error_bit=0;
    lmmse_error_bit=0;
    lr_lmmse_error_bit=0;
    total_bit_num=0;
 
for l=1:loop_num
    %每次仿真产生100个ofdm符号,则每次仿真共有100×128个星座映射符号；16QAM调制下，1个星座映射符号包含4个bit
    bit_per_carrier=4;%使用16QAM必须每个符号含有四个BIT二进制
    bit_source=input_b(xindao_num,ofdm_symbol_num,bit_per_carrier);%为每次仿真产生100个ofdm符号的比特个数，128为每个ofdm符号的子载波个数
    [nbit,mbit]=size(bit_source);%这里的nbit为512  mbit为100
    total_bit_num=total_bit_num+nbit*mbit;%生成的所有比特数 每次生成512*100个二进制数 也就是0 1  如果仿真10次的话应该是512000
    
    map_out=map_16qam(bit_source);%对一次仿真符号块进行16QAM映射    
    [insert_pilot_out,pilot_num,pilot_sequence]=insert_pilot(pilot_inter,pilot_symbol_bit,map_out);%按块状导频结构，对映射后的结果插入导频序列
    
    ofdm_modulation_out=ifft(insert_pilot_out,128);%作128点逆FFT运算，完成ofdm调制把频域变成时域
    ofdm_cp_out=insert_cp(ofdm_modulation_out,cp_length);%插入循环前缀
         
    %********************** 以下过程为ofdm符号通过频率选择性多径信道 *************************
    num=5;%5径信道
         %假设功率延迟谱服从负指数分布~exp(-t/trms),trms=(1/4)*cp时长；
          %t在0~cp时长上均匀分布
          %若cp时长为16e-6s，可以取5径延迟如下
    delay=[0 2e-6 4e-6 8e-6 12e-6];%delay各径延时,单位s；
    trms=0.25e-6*cp_length;;%trms为多经信道的平均延时
    var_pow=10*log10(exp(-delay/trms));%var_pow各径相对主径的平均功率,单位dB；var_pow= 0 -0.542868102379064 -1.0857362047581 -2.17147240951626 -3.25720861427439
    fd=132;%最大doppler频率为132Hz
    t_interval=1e-6;%采样间隔为1us    %t_interval为离散信道抽样时间间隔，等于OFDM符号长度/(子载波个数+cp长度lp)；
    counter=200000;%各径信道的采样点间隔，应该大于信道采样点数。由以上条件现在信道采样点数
    count_begin=(l-1)*(5*counter);%每次仿真信道采样的开始位置
    trms_1=trms/t_interval;
    t_max=16e-6/t_interval;
    %信道采样点数，每个调制符号采一个点
    passchan_ofdm_symbol=multipath_chann(ofdm_cp_out,num,var_pow,delay,fd,t_interval,counter,count_begin);
    
    %********************** 以上过程为ofdm符号通过频率选择性多径信道 *************************    
    %********************** 以下过程为ofdm符号加高斯白噪声 *************************
    snr=10^(SNR_dB(i)/10);%这个得到的是信号的功比上噪声的功率
    [nnl,mml]=size(passchan_ofdm_symbol);%这里为148*110
    spow=0;
    for k=1:nnl
      for b=1:mml
        spow=spow+real(passchan_ofdm_symbol(k,b))^2+imag(passchan_ofdm_symbol(k,b))^2;
      end
    end%到这里把所有数的实部平方 虚部平方求和
    spow1=spow/(nnl*mml);     %这里求的是每个符号的功率也就是功率谱密度   
    sgma=sqrt(spow1/(2*snr));%sgma如何计算，与当前SNR和信号平均能量有关系 SGMA是高斯白噪声的方差 高斯白噪声的功率谱密度与方差的关系sigma^2=N0/2
    receive_ofdm_symbol=add_noise(sgma,passchan_ofdm_symbol);%加入随机高斯白噪声，receive_ofdm_symbol为最终接收机收到的ofdm符号块
    
    %********************** 以上过程为ofdm符号加高斯白噪声 *************************
    cutcp_ofdm_symbol=cut_cp(receive_ofdm_symbol,cp_length);%去除循环前缀    
    ofdm_demodulation_out=fft(cutcp_ofdm_symbol,128);%作128点FFT运算，完成ofdm解调
    
    %********************** 以下就是对接收ofdm信号进行信道估计和信号检测的过程************************
    
    low_rank_lmmse_sig=lr_lmmse_estimation(ofdm_demodulation_out,pilot_inter,pilot_sequence,pilot_num,trms_1,t_max,snr,RANK);%采用低秩LMMSE估计算法及迫零检测得到的接收信号
    %********************** 以下就是对接收ofdm信号进行信道估计和信号检测的过程************************
    
   
    lr_lmmse_receive_bit_sig=de_map(low_rank_lmmse_sig);
    
    %以下过程统计各种估计算法得到的接收信号中的错误比特数
    
 
    lr_lmmse_err_num=error_count(bit_source,lr_lmmse_receive_bit_sig);
    
   
    lr_lmmse_error_bit=lr_lmmse_error_bit+lr_lmmse_err_num;
end
%计算各种估计算法的误比特率


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
title('不同降秩LMMSE算法的比较')
xlabel('SNR(dB)')
ylabel('BER(dB)')
