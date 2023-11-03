clear;
clear all;
tic;
H=load('base_matrix.txt');
H(H>=0)=1;
H(H==-1)=0;%��������-1��Ϊ0�����Ϊ1
E=sum(sum(H));%�ܱ���
vn_degree=[3,14,15,16,17,18];%�����ڵ�Ķ�d
vn_degree_num=[352,2,3,5,4,2];%�����ڵ��Ϊd��Ӧ�ı����ڵ����Ŀ
vn_edge_portion=vn_degree_num.*vn_degree/E;%��Ϊd�ı����ڵ�ı�ռ�ܱ����ı���

cn_degree=[12,13,14,15,16,17,18,19,20];%У��ڵ�Ķ�d
cn_degree_num=[1,2,3,15,18,22,16,2,1];%У��ڵ��Ϊd��Ӧ��У��ڵ����Ŀ
cn_edge_portion=cn_degree_num.*cn_degree/E;%��Ϊd��У��ڵ�ı�ռ�ܱ����ı���
Rate=calculate_Rate(vn_degree,vn_edge_portion,cn_degree,cn_edge_portion);%���öȷֲ���������

sigma = 0.40;%������С�ŵ��������豣֤������ֵҪ���ڸò���
sigma_inc = 1e-5;%�ŵ������ı���ݶȲ�
max_iter = 50;%�������ĵ�������
Pe = 1e-20;%��С�������
%�����ȷֲ��Ͳ������ø�˹���Ƽ��������ֵ
[sigma,EBN0]=calculate_threshold_GA(sigma,sigma_inc,max_iter,Pe,Rate,vn_degree,vn_edge_portion,cn_degree,cn_edge_portion);


toc;


