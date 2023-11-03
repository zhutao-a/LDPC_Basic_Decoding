% AWGN高斯信道 -- BPSK调制
clc,clear,close all
warning off
feature jit off
load('BPSK_AWGN_BER.mat')  % 加载数据
plot(snrs,BPSK_AWGN_BER,'bo-','linewidth',2)
set(gca,'yscale','log') % y轴为log
set(gca, 'XGrid', 'on'); %网格
set(gca, 'YGrid', 'on'); %网格
xlabel('SNR');ylabel('BER'); title('BPSK调制')




