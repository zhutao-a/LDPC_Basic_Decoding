% 三种码长通过瑞利衰落信道
% 无调制画图
clc,clear,close all
warning off
feature jit off
load('BPSK_BER1_1.mat')  % 码长1，无调制解调
load('BPSK_BER2_1.mat')  % 码长2，无调制解调
load('BPSK_BER3_1.mat')  % 码长3，无调制解调
load('BPSK_BER1.mat')  % 码长1，BPSK调制解调
load('BPSK_BER2.mat')  % 码长2，BPSK调制解调
load('BPSK_BER3.mat')  % 码长3，BPSK调制解调
plot(snrs,BER1,'r.-','linewidth',2)
hold on
plot(snrs,BER2,'g.-','linewidth',2)
plot(snrs,BER3,'b.-','linewidth',2)

plot(snrs,BER1_1,'ro-','linewidth',2)
plot(snrs,BER2_1,'go-','linewidth',2)
plot(snrs,BER3_1,'bo-','linewidth',2)

set(gca,'yscale','log') % y轴为log
set(gca, 'XGrid', 'on'); %网格
set(gca, 'YGrid', 'on'); %网格
xlabel('SNR');ylabel('BER');

load('A.mat')
load('B.mat')
load('C.mat')
legend(['BPSK','码长',num2str(A)],['BPSK','码长',num2str(B)],['BPSK','码长',num2str(C)],...
    ['无调制','码长',num2str(A)],['无调制','码长',num2str(B)],['无调制','码长',num2str(C)])

