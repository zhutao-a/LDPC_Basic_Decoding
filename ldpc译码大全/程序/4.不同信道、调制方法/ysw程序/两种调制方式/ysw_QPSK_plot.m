% QPSK���Ʒ�ʽ
clc,clear,close all
warning off
feature jit off
load('QPSK_BER.mat')  % ��������
plot(snrs,QPSK_BER,'bo-','linewidth',2)
set(gca,'yscale','log') % y��Ϊlog
set(gca, 'XGrid', 'on'); %����
set(gca, 'YGrid', 'on'); %����
xlabel('SNR');ylabel('BER'); title('QPSK����')




