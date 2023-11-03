% 码长 1 画图
% 不调制画图  - BPSK调制画图
clc,clear,close all
warning off
feature jit off
load('BPSK_BER1_1.mat')
load('BPSK_BER1.mat')
plot(snrs,BER1,'ro-','linewidth',2)
hold on
plot(snrs,BER1_1,'bo-','linewidth',2)
set(gca,'yscale','log') % y轴为log
set(gca, 'XGrid', 'on'); %网格
set(gca, 'YGrid', 'on'); %网格
xlabel('SNR');ylabel('BER');
legend('BPSK调制解调','无调制解调')






