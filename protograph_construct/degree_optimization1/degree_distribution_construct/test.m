clear;
clear all;
%%
%GA���������ֵ�Ĳ���
sigma_min = 0.3;%������С�ŵ��������豣֤������ֵҪ���ڸò���
sigma_max = 0.6;%�ŵ������ı���ݶȲ�
Pe = 1e-6;%��С�������
max_iter = 8;%�������ĵ�������
%%
%GA�ļ����еõ��Ķȷֲ�
% vn_degree=[2,3,4,5,16,20];
% vn_edge_portion=[4.0000e-04,0.2464,0.3155,0.4313,0.0050,0.0014];
% cn_degree=[30,31];
% cn_edge_portion=[0.6135,0.3865];
%50�ε���Լ��
% vn_degree= [3,9,10];
% vn_edge_portion=[0.7059,0.2406,0.0535];
% cn_degree=[27,28,29];
% cn_edge_portion=[0.0963,0.7487,0.1551];
%8�ε���Լ��
vn_degree= [4,6];
vn_edge_portion=[0.9900,0.0100];
cn_degree=[30,31];
cn_edge_portion=[0.8970,0.1030];


%%
%�����ȷֲ��Ͳ������ø�˹���Ƽ��������ֵ(���ַ�)
[sigma,current_Pe]=calculate_threshold_GA(sigma_min,sigma_max,max_iter,Pe,vn_degree,vn_edge_portion,cn_degree,cn_edge_portion);
Rate=calculate_Rate(vn_degree,vn_edge_portion,cn_degree,cn_edge_portion);
disp(Rate);disp(sigma);

ebn0=1/(2*Rate*sigma^2);
EBN0=10*log10(ebn0);
disp(['The threshold EBN0 = ' num2str(EBN0)]);
