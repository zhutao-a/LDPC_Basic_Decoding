clear;
clear all;
tic;
%%
filename='tc_hw_comp_iter2EBN0';
punc=load('tc_punc_iter2EBN0.mat');
no_punc=load('tc_iter2EBN0.mat');
%%
%��ͼ
plot(punc.iter,punc.EBN0,'-ro','LineWidth',1.5,'MarkerSize',5);
hold on;
text(punc.iter,punc.EBN0,num2str(punc.EBN0.','%.4f'),'color','b','FontSize',8);%��Ӧλ����ʾ��ֵ


plot(no_punc.iter,no_punc.EBN0,'-o','LineWidth',1.5,'MarkerSize',5);
text(no_punc.iter,no_punc.EBN0,num2str(no_punc.EBN0.','%.4f'),'color','k','FontSize',8);%��Ӧλ����ʾ��ֵ
%ͼ�����
legend('RCA-rate=288/(368-8)','RCA-rate=288/368');%��������
set(gcf,'Position',[500,100,1000,1000]);%����ͼ���С
xlabel('iter');
ylabel('rber');
grid on;
grid minor;
%��������
saveas(gcf,filename,'bmp');




toc;