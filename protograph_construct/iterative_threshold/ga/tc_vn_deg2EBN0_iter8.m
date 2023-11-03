clear;
clear all;
tic;
%%
%GA计算迭代阈值的参数
R=linspace(0.8,111/128,10);
sigma_min = 0.2;%最小噪声
sigma_max = 0.7;%最大噪声
Pe = 1e-20;%最小错误概率
iter = 8;%最大迭代次数
%%
%度分布相关参数
number=1000;
vn_deg=linspace(2.5,7,number);
vn_edge_prop=1;
cn_deg=zeros(1,number);
cn_edge_prop=1;
%%
sigma_best=zeros(1,length(R));
vn_deg_best=zeros(1,length(R));
EBN0_best=zeros(1,length(R));
%画出不同码率在规则度分布下，随变量节点度大小变化而变化
for j=1:length(R)
    disp(j);
    sigma_out=zeros(1,number);
    %利用高斯近似计算迭代阈值
    for i=1:number
        cn_deg(i)=vn_deg(i)/(1-R(j));%在给定平均变量节点度分布后求出平均校验节点度分布
        [sigma_out(i),~]=GA_threshold(sigma_min,sigma_max,iter,Pe,vn_deg(i),vn_edge_prop,cn_deg(i),cn_edge_prop);%二分法计算迭代阈值
    end
    
    [sigma_best(j),index]=max(sigma_out);%找出当前码率下最优的sigma
    vn_deg_best(j)=vn_deg(index);%最优sigma对应的平均度的值
    ebn0=1/(2*R(j)*sigma_best(j)^2);%将噪声转换为信噪比EBN0
    EBN0_best(j)=10*log10(ebn0);

    
    ebn0=1./(2*R(j)*sigma_out.^2);%将噪声转换为信噪比EBN0
    
    EBN0=10*log10(ebn0);
    plot(vn_deg,EBN0);%画出sigma与av_vn_deg曲线
    
    text(vn_deg_best(j),EBN0_best(j),['vn\_deg=',num2str(vn_deg_best(j)),',','EBN0=',num2str(EBN0_best(j))]);%在极值点添加极值点信息
    
    hold on;
end
%%
legend(num2str(R.'),'Location','NorthEast');%标明码率
set(gcf,'Position',[500,100,1000,1000]);%设置图像大小
grid on;
grid minor;

toc;








