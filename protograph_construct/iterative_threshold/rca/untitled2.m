clear;
clear all;
tic;
%%
filename='tc_hw_comp_iter2EBN0';
punc=load('tc_punc_iter2EBN0.mat');
no_punc=load('tc_iter2EBN0.mat');
%%
%画图
plot(punc.iter,punc.EBN0,'-ro','LineWidth',1.5,'MarkerSize',5);
hold on;
text(punc.iter,punc.EBN0,num2str(punc.EBN0.','%.4f'),'color','b','FontSize',8);%相应位置显示数值


plot(no_punc.iter,no_punc.EBN0,'-o','LineWidth',1.5,'MarkerSize',5);
text(no_punc.iter,no_punc.EBN0,num2str(no_punc.EBN0.','%.4f'),'color','k','FontSize',8);%相应位置显示数值
%图像后处理
legend('RCA-rate=288/(368-8)','RCA-rate=288/368');%标明码率
set(gcf,'Position',[500,100,1000,1000]);%设置图像大小
xlabel('iter');
ylabel('rber');
grid on;
grid minor;
%保存数据
saveas(gcf,filename,'bmp');




toc;