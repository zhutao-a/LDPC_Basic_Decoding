clear;
clear all;
tic;
%%
%GA计算迭代阈值的参数
R=0.8;
sigma_min = 0.2;%最小噪声
sigma_max = 0.7;%最大噪声
Pe = 1e-20;%最小错误概率
iter = 8;%最大迭代次数
%%
%度分布相关参数
number=1000;
vn_deg=linspace(2,9,number);
vn_edge_prop=1;
cn_deg=zeros(1,number);
cn_edge_prop=1;
%%
sigma_out=zeros(1,number);
%利用高斯近似计算迭代阈值
for i=1:number
    cn_deg(i)=vn_deg(i)/(1-R);%在给定平均变量节点度分布后求出平均校验节点度分布
    [sigma_out(i),~]=GA_threshold(sigma_min,sigma_max,iter,Pe,vn_deg(i),vn_edge_prop,cn_deg(i),cn_edge_prop);%二分法计算迭代阈值
end
plot(vn_deg,sigma_out);%画出sigma与av_vn_deg曲线

[sigma_best,index]=max(sigma_out);%找出当前码率下最优的sigma
vn_deg_best=vn_deg(index);%最优sigma对应的平均度的值
cn_deg_best=cn_deg(index);
ebn0=1/(2*R*sigma_best^2);%将噪声转换为信噪比EBN0
EBN0=10*log10(ebn0);
%打印信息
disp(['sigma_best=',num2str(sigma_best)]);
disp(['vn_deg_best=',num2str(vn_deg_best)]);
disp(['cn_deg_best=',num2str(cn_deg_best)]);
disp(['EBN0=',num2str(EBN0)]);

%%
%图像后处理
legend(num2str(R),'Location','SouthEast');%标明码率
text(vn_deg_best,sigma_best,['vn\_deg=',num2str(vn_deg_best),',','sig=',num2str(sigma_best),',','EBN0=',num2str(EBN0)]);%在极值点添加极值点信息
set(gcf,'Position',[500,100,1000,1000]);%设置图像大小
grid on;
grid minor;
xlabel('average variable degree');
ylabel('sigma/EBN0');

toc;








