% 三种码长通过瑞利衰落信道
% 无调制画图
clc,clear,close all
warning off
feature jit off
load('BPSK_BER1_1.mat')  % 码长1
load('BPSK_BER2_1.mat')  % 码长2
load('BPSK_BER3_1.mat')  % 码长3
plot(snrs,BER1_1,'ro-','linewidth',2)
hold on
plot(snrs,BER2_1,'go-','linewidth',2)
plot(snrs,BER3_1,'bo-','linewidth',2)
set(gca,'yscale','log') % y轴为log
set(gca, 'XGrid', 'on'); %网格
set(gca, 'YGrid', 'on'); %网格
xlabel('SNR');ylabel('BER');title('无调制解调')

load('A.mat')
load('B.mat')
load('C.mat')
legend(['码长',num2str(A)],['码长',num2str(B)],['码长',num2str(C)])








