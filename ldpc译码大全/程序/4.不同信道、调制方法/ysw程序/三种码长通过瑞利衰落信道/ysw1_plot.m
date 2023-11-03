% 码长 1 画图
% BPSK调制画图
clc,clear,close all
warning off
feature jit off
load('BPSK_BER1.mat')
plot(snrs,BER1,'bo-','linewidth',2)
set(gca,'yscale','log') % y轴为log
set(gca, 'XGrid', 'on'); %网格
set(gca, 'YGrid', 'on'); %网格
xlabel('SNR');ylabel('BER');title('BPSK调制')








