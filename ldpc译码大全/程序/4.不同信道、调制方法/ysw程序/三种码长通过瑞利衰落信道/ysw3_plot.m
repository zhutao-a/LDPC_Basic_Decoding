% �볤 3 ��ͼ
% BPSK���ƻ�ͼ
clc,clear,close all
warning off
feature jit off
load('BPSK_BER3.mat')
plot(snrs,BER3,'bo-','linewidth',2)
set(gca,'yscale','log') % y��Ϊlog
set(gca, 'XGrid', 'on'); %����
set(gca, 'YGrid', 'on'); %����
xlabel('SNR');ylabel('BER');title('BPSK����')



