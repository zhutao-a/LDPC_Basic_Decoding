function output_sig=multipath_chann(input_sig,num,var_pow,delay,fd,t_interval,counter,count_begin)
%input_sig输入信号矩阵,加了cp后的信号，大小为NL×(子载波个数+cp长度lp)；
%num多径数;
%var_pow各径相对主径的平均功率,单位dB；var_pow=10*log10(exp(-delay/trms));
%delay各径延时,单位s；delay=[0 2e-6 4e-6 8e-6 12e-6]/4
%fd最大dopple频率；
%t_interval为离散信道抽样时间间隔，等于OFDM符号长度/(子载波个数+cp长度lp)； t_interval=1e-6;
%output_sig为经过多径信道的输出信号矢量
%counter各径间隔记录
%count_begin本次产生信道开始记录的初始位置

t_shift=floor(delay/t_interval);%归一化各径延时 floor函数是向下取整得到的t_shift为[0 0 1 2 3]
%theta_shift=2*pi*fc*delay;
[nl,l]=size(input_sig);%这里的nl为144  l为110
output_sig=zeros(size(input_sig));%144*110

chann_l=nl*l;%信道采样点数，若一个调制符号采样一个信道点，则信道采样点数等于输入信号中的调制符号个数
selec_ray_chan=zeros(num,chann_l);%初始化频率选择性信道，径数＝num  产生了一个5行 144*110列的矩阵
pow_per_channel=10.^(var_pow/10);%各径功率线性化，从dB转变成线性1   0.882496902584595   0.778800783071405  0.606530659712633   0.472366552741015
total_pow_allchan=sum(pow_per_channel);%各径功率之和 3.74019489810965
%以下for循环产生相互独立的num条rayleigh信道
for k=1:num
    atts=sqrt(pow_per_channel(k));%一条信道功率的平方根
    selec_ray_chan(k,:)=atts*rayleighnew(chann_l,t_interval,fd,count_begin+k*counter)/sqrt(total_pow_allchan);%t_interval=1e-6
end
for k=1:l
    input_sig_serial(((k-1)*nl+1):k*nl)=input_sig(:,k).';%输入信号矩阵转变成串行序列 这里把矩阵变成了串行的数据流是一个一行 144*110列符号
end
delay_sig=zeros(num,chann_l);%初始化延时后的送入各径的信号，每径所含符号数为chann_l 144*110
%以下for循环为各径的输入信号做延迟处理
for f=1:num
    if t_shift(f)~=0  %t_shift=floor(delay/t_interval);%归一化各径延时floor函数是向下取整得到的t_shift为[0 0 1 2 3]
        delay_sig(f,1:t_shift(f))=zeros(1,t_shift(f));%这里是补零运算t_shift的第一个信道和第二个信道不延迟 第三个延迟一个 第四个延迟两个 第五个延迟三个
    end
    delay_sig(f,(t_shift(f)+1):chann_l)= input_sig_serial(1:(chann_l-t_shift(f)));%把多出来的数删除最后一行多出来三个删去不要
end
output_sig_serial=zeros(1,chann_l);%初始化输出信号串行序列
%得到各径叠加后的输出信号序列
for f=1:num
        output_sig_serial= output_sig_serial+selec_ray_chan(f,:).*delay_sig(f,:);%每个信道的符号与信道相乘其中 delay_sig为补零延迟后的序列selec_ray_chan为瑞利信道 然后求和
end
for k=1:l
    output_sig(:,k)=output_sig_serial(((k-1)*nl+1):k*nl).';%输出信号串行序列转变成与输入信号相同的矩阵形式，做为本函数输出
end
%注意，在本函数中没有为信号叠加白噪声