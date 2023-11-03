% QPSK调制方式
clc,clear,close all
warning off
feature jit off
load('QPSK_BER.mat')  % 加载数据
plot(snrs,QPSK_BER,'bo-','linewidth',2)
set(gca,'yscale','log') % y轴为log
set(gca, 'XGrid', 'on'); %网格
set(gca, 'YGrid', 'on'); %网格
xlabel('SNR');ylabel('BER'); title('QPSK调制')




