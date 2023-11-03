% �����볤ͨ������˥���ŵ�
% BPSK���ƻ�ͼ
clc,clear,close all
warning off
feature jit off
load('BPSK_BER1.mat')  % �볤1
load('BPSK_BER2.mat')  % �볤2
load('BPSK_BER3.mat')  % �볤3
plot(snrs,BER1,'ro-','linewidth',2)
hold on
plot(snrs,BER2,'go-','linewidth',2)
plot(snrs,BER3,'bo-','linewidth',2)
set(gca,'yscale','log') % y��Ϊlog
set(gca, 'XGrid', 'on'); %����
set(gca, 'YGrid', 'on'); %����
xlabel('SNR');ylabel('BER');title('BPSK����')

load('A.mat')
load('B.mat')
load('C.mat')
legend(['�볤',num2str(A)],['�볤',num2str(B)],['�볤',num2str(C)])








