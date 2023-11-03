clear;
clear all;
tic;
H=load('base_matrix.txt');
H(H>=0)=1;
H(H==-1)=0;%将矩阵中-1变为0其余变为1
E=sum(sum(H));%总边数
vn_degree=[3,14,15,16,17,18];%变量节点的度d
vn_degree_num=[352,2,3,5,4,2];%变量节点度为d对应的变量节点的数目
vn_edge_portion=vn_degree_num.*vn_degree/E;%度为d的变量节点的变占总边数的比例

cn_degree=[12,13,14,15,16,17,18,19,20];%校验节点的度d
cn_degree_num=[1,2,3,15,18,22,16,2,1];%校验节点度为d对应的校验节点的数目
cn_edge_portion=cn_degree_num.*cn_degree/E;%度为d的校验节点的变占总边数的比例
Rate=calculate_Rate(vn_degree,vn_edge_portion,cn_degree,cn_edge_portion);%利用度分布计算码率

sigma = 0.40;%设置最小信道参数，需保证迭代阈值要大于该参数
sigma_inc = 1e-5;%信道参数改变的梯度差
max_iter = 50;%设置最大的迭代次数
Pe = 1e-20;%最小错误概率
%给定度分布和参数利用高斯近似计算迭代阈值
[sigma,EBN0]=calculate_threshold_GA(sigma,sigma_inc,max_iter,Pe,Rate,vn_degree,vn_edge_portion,cn_degree,cn_edge_portion);


toc;


