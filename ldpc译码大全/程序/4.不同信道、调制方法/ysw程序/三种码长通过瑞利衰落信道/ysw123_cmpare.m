% �����볤ͨ������˥���ŵ�
% �޵��ƻ�ͼ
clc,clear,close all
warning off
feature jit off
load('BPSK_BER1_1.mat')  % �볤1���޵��ƽ��
load('BPSK_BER2_1.mat')  % �볤2���޵��ƽ��
load('BPSK_BER3_1.mat')  % �볤3���޵��ƽ��
load('BPSK_BER1.mat')  % �볤1��BPSK���ƽ��
load('BPSK_BER2.mat')  % �볤2��BPSK���ƽ��
load('BPSK_BER3.mat')  % �볤3��BPSK���ƽ��
plot(snrs,BER1,'r.-','linewidth',2)
hold on
plot(snrs,BER2,'g.-','linewidth',2)
plot(snrs,BER3,'b.-','linewidth',2)

plot(snrs,BER1_1,'ro-','linewidth',2)
plot(snrs,BER2_1,'go-','linewidth',2)
plot(snrs,BER3_1,'bo-','linewidth',2)

set(gca,'yscale','log') % y��Ϊlog
set(gca, 'XGrid', 'on'); %����
set(gca, 'YGrid', 'on'); %����
xlabel('SNR');ylabel('BER');

load('A.mat')
load('B.mat')
load('C.mat')
legend(['BPSK','�볤',num2str(A)],['BPSK','�볤',num2str(B)],['BPSK','�볤',num2str(C)],...
    ['�޵���','�볤',num2str(A)],['�޵���','�볤',num2str(B)],['�޵���','�볤',num2str(C)])

