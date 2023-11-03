clear;
clear all;
tic;
%%
filename='tc_iter2EBN0';
%����protograph����Ϊ�ľ���368��80��,��puncture
H=load('base_matrix.txt');
H(H>=0)=1;
H(H==-1)=0;%��������-1��Ϊ0�����Ϊ1
%%
%����Ļ�������
[C,V] = size(H);
punc_idx=[];
punc_len=length(punc_idx);%Number of Punctured Nodes 
rate=(V-C)/(V-punc_len); %Rate of code only for EB_No_result
%%
%����RCA�㷨���������ֵ�Ĳ���
load('LUT.mat');
iter=[8,10,15,20,30,40,50,100,150,200,250];%iterations numbers
snr_dB_min=0;
snr_dB_max=10;
EBN0=zeros(1,length(iter));
%%
%����RCA���㲻ͬ���������ĵ�����ֵ
for i=1:length(iter)
    disp(i);
    %��������snr������ֵ����ת��ΪEBN0
    snr_dB_out = RCA_threshold(H,snr_dB_min,snr_dB_max,punc_idx,R,snr_R,iter(i));%���ַ����������ֵ
    M=2; % Modulation 2 bpsk, 4 qpsk
    EBN0(i)= snr_dB_out-10*log10(log2(M)*rate);%�����ת��ΪEBN0
end
%%
%��ͼ
plot(iter,EBN0,'-ro','LineWidth',1.5,'MarkerSize',5);
hold on;
text(iter,EBN0,num2str(EBN0.'),'color','b');
%ͼ�����
set(gcf,'Position',[500,100,1000,1000]);%����ͼ���С
xlabel('iter');
ylabel('EBN0');
title(['rate=',num2str(rate)]);
grid on;
grid minor;
%��������
saveas(gcf,filename,'bmp');
save(filename,'iter','EBN0');

toc;






