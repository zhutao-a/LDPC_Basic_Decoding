% �볤 2 ��ͼ
% �����ƻ�ͼ
clc,clear,close all
warning off
feature jit off
load('BPSK_BER2_1.mat')
plot(snrs,BER2_1,'bo-','linewidth',2)
set(gca,'yscale','log') % y��Ϊlog
set(gca, 'XGrid', 'on'); %����
set(gca, 'YGrid', 'on'); %����
xlabel('SNR');ylabel('BER');title('�޵��ƽ��')



