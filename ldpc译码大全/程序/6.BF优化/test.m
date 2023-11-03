clear;
clc;
load Matrix(2016,1008)Block56.mat;
k = 1008;
n = 2016;
R = 1/2;
EbN0_All = [0:6];
EbN0_All_num = 10.^(EbN0_All/10); %��������ȵ���ֵ
snrAll_num = EbN0_All_num * R; %��������ȣ���Ҫ�ڱ�������Ȼ����ϳ�������
Es = 1;  %�źŹ���
iteration = 30; % ����������
numBlock = 10; % set block number here
numInfoBits = k;
blockSize = 56;
%% generate source bit here
[H_col H_row H H_col_full H_row_full] = preProcess(H_block,blockSize);%Ԥ�����������ڷֿ�У�����Ĺ���

%biterrorsBP=zeros(1,length(EbN0_All));
biterrorsBF=zeros(1,length(EbN0_All));                      % ���� BER ����
%biterrorsWBF=zeros(1,length(EbN0_All));
biterrorsIWBF=zeros(1,length(EbN0_All));
biterrorsIRRWBF = zeros(1,length(EbN0_All));
for ii = 1:length(snrAll_num)
    snr = snrAll_num(ii);  %��ǰ�������ֵ
    segma = sqrt(Es/snr/2);  %��ǰ������µ���������
    for jj = 1:numBlock
        info = randi([0,1],1,numInfoBits);
        S_encoded = encoderLDPC(info,H_block,blockSize);%���ñ��뺯�������ڵõ���������Ϣ����
        modSym = 2*S_encoded-1;   % BPSK ����
        modSymNoise = modSym + segma*randn(1,length(modSym));
        %% BF
        [syn ,u]=ldpc_bf(H,modSymNoise,iteration);
        biterrorsBF(ii) = biterrorsBF(ii) + sum(info ~= u(end-length(info)+1:end));
        %% BP
      %  soft = 4*modSymNoise*snr;  %�ŵ�����Ϣ�����������о�
      %  method = 0; %0ΪSPA��1ΪMinSum
      %  alpha = 1;
      %  beta = 0;
      %  S_decoded = decoderLDPC_fullH(H,H_col_full,H_row_full,-soft,method,iteration,alpha,beta);  
      %  biterrorsBP(ii) = biterrorsBP(ii) + sum(info ~= S_decoded(end-length(info)+1:end));
        
        %% WBF
     %   [synWBF,y_reWBF] = ldpc_wbf(H,modSymNoise,iteration);
     %   biterrorsWBF(ii) = biterrorsWBF(ii) + sum(info ~= y_reWBF(end-length(info)+1:end));
        %% IWBF
       
        alp=0.7;            % Ȩ�ز���������
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
title('���ط�ת�����㷨�ĸĽ�');
xlabel('EbN0/dB');
ylabel('Ber');