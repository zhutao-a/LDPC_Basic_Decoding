% AWGN��˹�ŵ� -- BPSK����
clc,clear,close all
warning off
feature jit off
load('BPSK_AWGN_BER.mat')  % ��������
plot(snrs,BPSK_AWGN_BER,'bo-','linewidth',2)
set(gca,'yscale','log') % y��Ϊlog
set(gca, 'XGrid', 'on'); %����
set(gca, 'YGrid', 'on'); %����
xlabel('SNR');ylabel('BER'); title('BPSK����')




