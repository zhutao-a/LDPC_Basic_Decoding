clear;
clear all;
tic;
%%
filename='tc_hwmatrix_comp_iter2EBN0';
punc=load('tc_punc_iter2EBN0.mat');
no_punc=load('tc_iter2EBN0.mat');
%%
%画图
punc_R=(368-80)/(368-8);
punc_N0=(1/punc_R)*(1./exp(punc.EBN0*(log(10)/10))); 
punc_sigma=sqrt(punc_N0/2);
punc_rber = normcdf(0, 1, punc_sigma);
plot(punc.iter,punc_rber,'-ro','LineWidth',1.5,'MarkerSize',5);
hold on;
text(punc.iter,punc_rber,num2str(punc_rber.','%.4f'),'color','b','FontSize',8);%相应位置显示数值


no_punc_R=(368-80)/(368);
no_punc_N0=(1/no_punc_R)*(1./exp(no_punc.EBN0*(log(10)/10))); 
no_punc_sigma=sqrt(no_punc_N0/2);
no_punc_rber = normcdf(0, 1, no_punc_sigma);

plot(no_punc.iter,no_punc_rber,'-o','LineWidth',1.5,'MarkerSize',5);
text(no_punc.iter,no_punc_rber,num2str(no_punc_rber.','%.4f'),'color','k','FontSize',8);%相应位置显示数值


iter8=8;
rber_iter4=0.0277;
plot(iter8,rber_iter4,'gx','Markersize',10);
text(iter8,rber_iter4,num2str(rber_iter4),'color','g','FontSize',8);
iter20=40;
rber_iter20=0.0454;
plot(iter20,rber_iter20,'gx','Markersize',10);
text(iter20,rber_iter20,num2str(rber_iter20),'color','g','FontSize',8);

%图像后处理
legend('rate=288/(368-8)','rate=288/368');%标明码率
set(gcf,'Position',[500,100,1000,1000]);%设置图像大小
xlabel('iter');
ylabel('rber');
grid on;
grid minor;
%保存数据
saveas(gcf,filename,'bmp');




toc;