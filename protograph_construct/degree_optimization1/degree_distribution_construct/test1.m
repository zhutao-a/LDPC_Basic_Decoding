clear;
clear all;
%%
%GA计算迭代阈值的参数
sigma_min = 0.5;%设置最小信道参数，需保证迭代阈值要大于该参数
sigma_max = 0.7;%信道参数改变的梯度差
Pe = 1e-16;%最小错误概率
max_iter = 50;%设置最大的迭代次数
Rate=111/128;
M=17;
N=round(M/(1-Rate));
R=1-M/N;
R=1-80/368;
number=1000;


vn_degree=linspace(2,7,number);
cn_degree=zeros(1,number);
sigma=zeros(1,number);
vn_edge_portion=1;
cn_edge_portion=1;
for i=1:number
    cn_degree(i)=vn_degree(i)/(1-R);
    %给定度分布和参数利用高斯近似计算迭代阈值(二分法)
    [sigma(i),current_Pe]=calculate_threshold_GA(sigma_min,sigma_max,max_iter,Pe,vn_degree(i),vn_edge_portion,cn_degree(i),cn_edge_portion);
end



plot(vn_degree,sigma);
[sigma_best,index]=max(sigma);
disp(['sigma_best = ' num2str(sigma_best)]);
disp(['vn_degree = ' num2str(vn_degree(index))]);
disp(['cn_degree = ' num2str(cn_degree(index))]);

ebn0=1/(2*R*sigma_best^2);
EBN0=10*log10(ebn0);
disp(['EBN0 = ' num2str(EBN0)]);

text(vn_degree(index)+0.1,sigma_best-0.004,['vn\_degree=',num2str(vn_degree(index))],'FontSize',10);
text(vn_degree(index)+0.1,sigma_best-0.010,['cn\_degree=',num2str(cn_degree(index))],'FontSize',10);
text(vn_degree(index)+0.1,sigma_best-0.016,['sigma\_best=',num2str(sigma_best)],'FontSize',10);
text(vn_degree(index)+0.1,sigma_best-0.022,['EBN0=',num2str(EBN0)],'FontSize',10);

hold on;
x=vn_degree(index)*ones(1,100);
y=linspace(sigma_min,sigma_best,100);
plot(x,y,'-.r');





xlabel('average variable degree');
ylabel('sigma');
% title('R=288/368,max\_iter=50,Pe=1e-16');

grid on;
grid minor;


% R=111/128;
% sigma_best=0.4903;
% ebn0=1/(2*R*sigma_best^2);
% EBN0=10*log10(ebn0);
% disp(['EBN0 = ' num2str(EBN0)]);



