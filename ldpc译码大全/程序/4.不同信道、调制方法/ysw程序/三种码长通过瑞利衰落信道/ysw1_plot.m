% �볤 1 ��ͼ
% BPSK���ƻ�ͼ
clc,clear,close all
warning off
feature jit off
load('BPSK_BER1.mat')
plot(snrs,BER1,'bo-','linewidth',2)
set(gca,'yscale','log') % y��Ϊlog
set(gca, 'XGrid', 'on'); %����
set(gca, 'YGrid', 'on'); %����
xlabel('SNR');ylabel('BER');title('BPSK����')








