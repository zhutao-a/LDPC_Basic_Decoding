% 码长 2 画图
% 不调制画图
clc,clear,close all
warning off
feature jit off
load('BPSK_BER2_1.mat')
plot(snrs,BER2_1,'bo-','linewidth',2)
set(gca,'yscale','log') % y轴为log
set(gca, 'XGrid', 'on'); %网格
set(gca, 'YGrid', 'on'); %网格
xlabel('SNR');ylabel('BER');title('无调制解调')



