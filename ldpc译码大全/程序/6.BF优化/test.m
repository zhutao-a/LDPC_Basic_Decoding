clear;
clc;
load Matrix(2016,1008)Block56.mat;
k = 1008;
n = 2016;
R = 1/2;
EbN0_All = [0:6];
EbN0_All_num = 10.^(EbN0_All/10); %比特信噪比的数值
snrAll_num = EbN0_All_num * R; %符号信噪比，需要在比特信噪比基础上乘以码率
Es = 1;  %信号功率
iteration = 30; % 最大迭代次数
numBlock = 10; % set block number here
numInfoBits = k;
blockSize = 56;
%% generate source bit here
[H_col H_row H H_col_full H_row_full] = preProcess(H_block,blockSize);%预处理函数，用于分块校验矩阵的构造

%biterrorsBP=zeros(1,length(EbN0_All));
biterrorsBF=zeros(1,length(EbN0_All));                      % 用于 BER 计算
%biterrorsWBF=zeros(1,length(EbN0_All));
biterrorsIWBF=zeros(1,length(EbN0_All));
biterrorsIRRWBF = zeros(1,length(EbN0_All));
for ii = 1:length(snrAll_num)
    snr = snrAll_num(ii);  %当前信噪比数值
    segma = sqrt(Es/snr/2);  %当前信噪比下的噪声幅度
    for jj = 1:numBlock
        info = randi([0,1],1,numInfoBits);
        S_encoded = encoderLDPC(info,H_block,blockSize);%调用编码函数，用于得到编码后的信息序列
        modSym = 2*S_encoded-1;   % BPSK 调制
        modSymNoise = modSym + segma*randn(1,length(modSym));
        %% BF
        [syn ,u]=ldpc_bf(H,modSymNoise,iteration);
        biterrorsBF(ii) = biterrorsBF(ii) + sum(info ~= u(end-length(info)+1:end));
        %% BP
      %  soft = 4*modSymNoise*snr;  %信道软信息，用于译码判决
      %  method = 0; %0为SPA，1为MinSum
      %  alpha = 1;
      %  beta = 0;
      %  S_decoded = decoderLDPC_fullH(H,H_col_full,H_row_full,-soft,method,iteration,alpha,beta);  
      %  biterrorsBP(ii) = biterrorsBP(ii) + sum(info ~= S_decoded(end-length(info)+1:end));
        
        %% WBF
     %   [synWBF,y_reWBF] = ldpc_wbf(H,modSymNoise,iteration);
     %   biterrorsWBF(ii) = biterrorsWBF(ii) + sum(info ~= y_reWBF(end-length(info)+1:end));
        %% IWBF
       
        alp=0.7;            % 权重参数的设置
        [synIWBF,y_reIWBF] = ldpc_iwbf(H,modSymNoise,alp,iteration);
        biterrorsIWBF(ii) = biterrorsIWBF(ii) + sum(info ~= y_reIWBF(end-length(info)+1:end));
        %% IRRWBF
        [synIRRWBF,hard] = ldpc_irrwbf(H,modSymNoise,iteration);
        biterrorsIRRWBF(ii) = biterrorsIRRWBF(ii) + sum(info ~= hard(end-length(info)+1:end));
        
    end
end
berBF = biterrorsBF/(numBlock*numInfoBits);
%berBP = biterrorsBP/(numBlock*numInfoBits);
%berWBF = biterrorsWBF/(numBlock*numInfoBits);
berIWBF = biterrorsIWBF/(numBlock*numInfoBits);
berIRRBF = biterrorsIRRWBF/(numBlock*numInfoBits);

semilogy(EbN0_All,berBF,'k-o');
hold on
%semilogy(EbN0_All,berBP,'k-*');
%hold on
%semilogy(EbN0_All,berWBF,'k-s');
%hold on
semilogy(EbN0_All,berIWBF,'k-+');
hold on
semilogy(EbN0_All,berIRRBF,'k-d');
grid on;
legend('BF','IMWBF','RRWBF');
title('比特翻转译码算法的改进');
xlabel('EbN0/dB');
ylabel('Ber');