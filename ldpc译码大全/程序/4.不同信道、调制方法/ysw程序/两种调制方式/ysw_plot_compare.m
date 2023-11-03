% ���ֵ��Ʒ�ʽ -- �ԱȻ�ͼ
clc,clear,close all
warning off
feature jit off
load('BPSK_BER.mat')  % ��������
load('QPSK_BER.mat')  % ��������
figure(3),
plot(snrs,BPSK_BER,'ro-','linewidth',2);
hold on
plot(snrs,QPSK_BER,'bo-','linewidth',2)
set(gca,'yscale','log') % y��Ϊlog
set(gca, 'XGrid', 'on'); %����
set(gca, 'YGrid', 'on'); %����
xlabel('SNR');ylabel('BER'); 
legend('BPSK����','QPSK����')




