clear;
clc;
load Matrix(2016,1008)Block56.mat;
k = 1008;
n = 2016;
R = 1/2;
EbN0_All = [-6:6];
EbN0_All_num = 10.^(EbN0_All/10); %比特信噪比的数值
snrAll_num = EbN0_All_num * R; %符号信噪比，需要在比特信噪比基础上乘以码率
Es = 1;  %信号功率
iteration = [10:20:90]; % 最大迭代次数
numBlock = 10; % set block number here
numInfoBits = k;
blockSize = 56;
%% generate source bit here
[H_col H_row H H_col_full H_row_full] = preProcess(H_block,blockSize);%预处理函数，用于分块校验矩阵的构造

biterrorsBF=zeros(length(iteration),length(EbN0_All));
for iii=1:length(iteration)
    
for ii = 1:length(snrAll_num)
    snr = snrAll_num(ii);  %当前信噪比数值
    segma = sqrt(Es/snr/2);  %当前信噪比下的噪声幅度
    for jj = 1:numBlock
        info = randi([0,1],1,numInfoBits);
        S_encoded = encoderLDPC(info,H_block,blockSize);%调用编码函数，用于得到编码后的信息序列
        modSym = 2*S_encoded-1;   % BPSK 调制
        modSymNoise = modSym + segma*randn(1,length(modSym));
        %% BF
        [syn ,u]=ldpc_bf(H,modSymNoise,iii);
        biterrorsBF(iii,ii) = biterrorsBF(iii,ii) + sum(info ~= u(end-length(info)+1:end));
        
    end
end
berBF= biterrorsBF/(numBlock*numInfoBits)

end

figure;
semilogy(EbN0_All,berBF(1,:),'-o');
hold on
semilogy(EbN0_All,berBF(2,:),'-*');
hold on
semilogy(EbN0_All,berBF(3,:),'-s');
hold on
semilogy(EbN0_All,berBF(4,:),'-x');
hold on
semilogy(EbN0_All,berBF(5,:),'-<');
grid on
legend('迭代次数为10','迭代次数为30','迭代次数为50','迭代次数为70','迭代次数为90');
title('Ber of LDPC');
xlabel('EbN0/dB');
ylabel('Ber');