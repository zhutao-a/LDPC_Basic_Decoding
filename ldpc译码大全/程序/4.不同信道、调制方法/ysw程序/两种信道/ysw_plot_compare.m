% AWGN高斯信道 -- BPSK调制
% Rayl瑞利信道 -- BPSK调制
% 对比画图
clc,clear,close all
warning off
feature jit off
load('BPSK_AWGN_BER.mat')  % 加载数据
load('BPSK_Rayleigh_BER.mat')  % 加载数据
figure(3),
plot(snrs,BPSK_Rayleigh_BER,'ro-','linewidth',2)
hold on
plot(snrs,BPSK_AWGN_BER,'bo-','linewidth',2)
set(gca,'yscale','log') % y轴为log
set(gca, 'XGrid', 'on'); %网格
set(gca, 'YGrid', 'on'); %网格
xlabel('SNR');ylabel('BER'); title('BPSK调制')
legend('Rayleigh瑞利衰减信道','AWGN高斯信道')




