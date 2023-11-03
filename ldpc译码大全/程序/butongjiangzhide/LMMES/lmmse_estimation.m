function output=lmmse_estimation(input,pilot_inter,pilot_sequence,pilot_num,trms,t_max,snr);
%trms为多经信道的平均延时，t_max为最大延时,此处所有的时间都是已经对采样间隔做了归一化后的结果
%对于16QAM调制为17／9
beta=17/9;
[N,NL]=size(input);%这里的N为128 NL为110
Rhh=zeros(N,N);%产生一个RHH矩阵 是信道H的自相关阵
for k=1:N
    for l=1:N
        Rhh(k,l)=(1-exp((-1)*t_max*((1/trms)+j*2*pi*(k-l)/N)))./(trms*(1-exp((-1)*t_max/trms))*((1/trms)+j*2*pi*(k-l)/N));
    end
end
output=zeros(N,NL-pilot_num);%产生输出矩阵
i=1;
count=0;
while i<=NL
    Hi=input(:,i)./pilot_sequence;%LS算法估到的信道值
    Hlmmse=Rhh*inv(Rhh+(beta/snr)*eye(N))*Hi;%LMMSE算法的常用公式 INV为逆矩阵
    count=count+1;
    if  count*pilot_inter<=(NL-pilot_num)%后面这些跟LS算法就相同了
        for p=((count-1)*pilot_inter+1):count*pilot_inter
            output(:,p)=input(:,(i+p-(count-1)*pilot_inter))./Hlmmse;
        end
    else
        for p=((count-1)*pilot_inter+1):(NL-pilot_num)
            output(:,p)=input(:,(i+p-(count-1)*pilot_inter))./Hlmmse;
        end
    end
    i=i+pilot_inter+1;
  end