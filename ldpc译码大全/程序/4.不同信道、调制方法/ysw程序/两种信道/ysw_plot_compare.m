% AWGN��˹�ŵ� -- BPSK����
% Rayl�����ŵ� -- BPSK����
% �ԱȻ�ͼ
clc,clear,close all
warning off
feature jit off
load('BPSK_AWGN_BER.mat')  % ��������
load('BPSK_Rayleigh_BER.mat')  % ��������
figure(3),
plot(snrs,BPSK_Rayleigh_BER,'ro-','linewidth',2)
hold on
plot(snrs,BPSK_AWGN_BER,'bo-','linewidth',2)
set(gca,'yscale','log') % y��Ϊlog
set(gca, 'XGrid', 'on'); %����
set(gca, 'YGrid', 'on'); %����
xlabel('SNR');ylabel('BER'); title('BPSK����')
legend('Rayleigh����˥���ŵ�','AWGN��˹�ŵ�')




