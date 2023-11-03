clear;
clear all;
tic;
%%
%华为矩阵基本参数
M=80;
N=368;
E=1313;%总边数
vn_deg=[3,14,15,16,17,18];%变量节点的度d
vn_deg_num=[352,2,3,5,4,2];%变量节点度为d对应的变量节点的数目
vn_edge_prop=vn_deg_num.*vn_deg/E;%度为d的变量节点的变占总边数的比例
cn_deg=[12,13,14,15,16,17,18,19,20];%校验节点的度d
cn_deg_num=[1,2,3,15,18,22,16,2,1];%校验节点度为d对应的校验节点的数目
cn_edge_prop=cn_deg_num.*cn_deg/E;%度为d的校验节点的变占总边数的比例
punc_deg=[16,17,18];
punc_prop=[3/5,3/4,2/2];
punc_len=7;
rate=(N-M)/(N-punc_len);
%%
%GA计算迭代阈值的参数
sigma_min = 0.3;%最小噪声
sigma_max = 0.8;%最大噪声
Pe = 1e-6;%最小错误概率
iter=8;%iterations numbers
%%
%利用GA计算不同迭代次数的迭代阈值
    %二分法计算迭代阈值
[sigma_out,~]=GA_threshold_punc(sigma_min,sigma_max,iter,Pe,vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop);
r_ber = normcdf(0, 1, sigma_out);
disp(r_ber);
ebn0=1/(2*rate*sigma_out^2);
EBN0=10*log10(ebn0);
disp(EBN0);


toc;








