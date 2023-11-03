clear;
clc;
load Matrix(2016,1008)Block56.mat;
k = 1008;
n = 2016;
R = 1/2;
EbN0_All = [-6:6];
EbN0_All_num = 10.^(EbN0_All/10); %��������ȵ���ֵ
snrAll_num = EbN0_All_num * R; %��������ȣ���Ҫ�ڱ�������Ȼ����ϳ�������
Es = 1;  %�źŹ���
iteration = [10:20:90]; % ����������
numBlock = 10; % set block number here
numInfoBits = k;
blockSize = 56;
%% generate source bit here
[H_col H_row H H_col_full H_row_full] = preProcess(H_block,blockSize);%Ԥ�����������ڷֿ�У�����Ĺ���

biterrorsWBF=zeros(length(iteration),length(EbN0_All));

for iii=1:length(iteration)
    
for ii = 1:length(snrAll_num)
    snr = snrAll_num(ii);  %��ǰ�������ֵ
    segma = sqrt(Es/snr/2);  %��ǰ������µ���������
    for jj = 1:numBlock
        info = randi([0,1],1,numInfoBits);
        S_encoded = encoderLDPC(info,H_block,blockSize);%���ñ��뺯�������ڵõ���������Ϣ����
        modSym = 2*S_encoded-1;   % BPSK ����
        modSymNoise = modSym + segma*randn(1,length(modSym));

        
       %% WBF
        [synWBF,y_reWBF] = ldpc_wbf(H,modSymNoise,iii);
        biterrorsWBF(iii,ii) = biterrorsWBF(iii,ii) + sum(info ~= y_reWBF(end-length(info)+1:end));
        %% IWBF
       
%         alp=0.7;            % Ȩ�ز���������
%         [synIWBF,y_reIWBF] = ldpc_iwbf(H,modSymNoise,alp,iii);
%         biterrorsIWBF(ii) = biterrorsIWBF(ii) + sum(info ~= y_reIWBF(end-length(info)+1:end));
%         %% IRRWBF
%         [synIRRWBF,hard] = ldpc_irrwbf(H,modSymNoise,iii);
%         biterrorsIRRWBF(iii,ii) = biterrorsIRRWBF(iii,ii) + sum(info ~= hard(end-length(info)+1:end));
        
        
    end
end
berWBF= biterrorsWBF/(numBlock*numInfoBits)

end

figure;
semilogy(EbN0_All,berWBF(1,:),'-o');
hold on
semilogy(EbN0_All,berWBF(2,:),'-*');
hold on
semilogy(EbN0_All,berWBF(3,:),'-s');
hold on
semilogy(EbN0_All,berWBF(4,:),'-x');
hold on
semilogy(EbN0_All,berWBF(5,:),'->');
grid on
legend('��������Ϊ10','��������Ϊ30','��������Ϊ50','��������Ϊ70','��������Ϊ90');
title('Ber of LDPC');
xlabel('EbN0/dB');
ylabel('Ber');