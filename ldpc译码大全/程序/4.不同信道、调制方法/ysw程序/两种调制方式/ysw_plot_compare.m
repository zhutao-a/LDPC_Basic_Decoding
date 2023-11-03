% 两种调制方式 -- 对比画图
clc,clear,close all
warning off
feature jit off
load('BPSK_BER.mat')  % 加载数据
load('QPSK_BER.mat')  % 加载数据
figure(3),
plot(snrs,BPSK_BER,'ro-','linewidth',2);
hold on
plot(snrs,QPSK_BER,'bo-','linewidth',2)
set(gca,'yscale','log') % y轴为log
set(gca, 'XGrid', 'on'); %网格
set(gca, 'YGrid', 'on'); %网格
xlabel('SNR');ylabel('BER'); 
legend('BPSK调制','QPSK调制')




