                                %需要自己改信噪比EBN0
clc; 
clear all;
M = 256;            %定义校验矩阵H大小为M*N
N = 512;
EbN0 =3.5;         %信噪比DB
iter = 20;           %迭代次数
frame = 1000;        %帧数
ber=0;              %初始化误比特率
ser=0;              %初始化误帧率
averageiter=0;        %初始化平均迭代次数
sum=0;
dSource = round(rand(M, frame));                %产生5000串消息码字m*5000
c=zeros(M,frame);                               %产生n-m*1的校验码字frame个
load L1;                %用同一个校验矩阵
load U1;
load newH;
for j=1:frame
    z = mod(newH(:, (N - M) + 1:end)*dSource(:,j), 2);
    c(:,j) = mod(U1\(L1\z), 2);                   %生成校验位n-m*1共frame个
    if mod(j,500)==0
        fprintf('EbN0 : %d\n', EbN0);
    end
end
tic;
for j = 1:frame                                 %挑选出5000列消息码字中的一列进行运算，即m*1
    fprintf('Frame : %d\n', j);
     u = [c(:,j); dSource(:, j)];                                    %得到实际的发送码字n*1
     bpskMod = 2*u - 1;                                         %bpsk编码
     N0 = 2/(exp(EbN0*log(10)/10));                             %获取平均噪声功率
     tx = bpskMod + sqrt(N0/2)*randn(size(bpskMod));            %得到实际接收到的码字n*1
     [realiter,vhat]=decodeLogDomain(tx, newH,N0, iter);             %获得估计码字1*n
     [num, rat] = biterr(vhat', u);                             %比较发送码字和估计码字错误率
     averageiter=averageiter+realiter;
     ber= (ber + rat);                                          %误比特率求和
     if num~=0
         ser=ser+1;
     end
     sum=sum+num;
end 
ber = ber/frame;                                                %求平均值
ser = ser/frame; 
averageiter=averageiter/frame;
fprintf('信噪比：');
disp(EbN0);
fprintf('误比特率：');
disp(ber);
fprintf('误码率：');
disp(ser);
fprintf('总错误比特数：');
disp(sum);
fprintf('平均迭代次数：');
disp(averageiter);
toc;