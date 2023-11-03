clear;
clear all;
tic;
%%
filename='tc_iter2EBN0';
%给出protograph，华为的矩阵（368，80）,不puncture
H=load('base_matrix.txt');
H(H>=0)=1;
H(H==-1)=0;%将矩阵中-1变为0其余变为1
%%
%矩阵的基本参数
[C,V] = size(H);
punc_idx=[];
punc_len=length(punc_idx);%Number of Punctured Nodes 
rate=(V-C)/(V-punc_len); %Rate of code only for EB_No_result
%%
%设置RCA算法计算迭代阈值的参数
load('LUT.mat');
iter=[8,10,15,20,30,40,50,100,150,200,250];%iterations numbers
snr_dB_min=0;
snr_dB_max=10;
EBN0=zeros(1,length(iter));
%%
%利用RCA计算不同迭代次数的迭代阈值
for i=1:length(iter)
    disp(i);
    %求得信噪比snr迭代阈值，并转换为EBN0
    snr_dB_out = RCA_threshold(H,snr_dB_min,snr_dB_max,punc_idx,R,snr_R,iter(i));%二分法计算迭代阈值
    M=2; % Modulation 2 bpsk, 4 qpsk
    EBN0(i)= snr_dB_out-10*log10(log2(M)*rate);%将结果转换为EBN0
end
%%
%画图
plot(iter,EBN0,'-ro','LineWidth',1.5,'MarkerSize',5);
hold on;
text(iter,EBN0,num2str(EBN0.'),'color','b');
%图像后处理
set(gcf,'Position',[500,100,1000,1000]);%设置图像大小
xlabel('iter');
ylabel('EBN0');
title(['rate=',num2str(rate)]);
grid on;
grid minor;
%保存数据
saveas(gcf,filename,'bmp');
save(filename,'iter','EBN0');

toc;






