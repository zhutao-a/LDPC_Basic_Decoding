clear;
clear all;
%׼������
block_size=52;
base_matrix=load('base_matrix.txt');
[M,N]=size(base_matrix);%����M������N
H1_mat = base_matrix(:,1:N-M);%base_matrix��ǰK=N-M��
H2_mat = base_matrix(:,N-M+1:N);%base_matrix�ĺ�M��
H1= h_full_generate(H1_mat, block_size);%��base_matrixչ��ȫ����Ϊ0��1����
H2= h_full_generate(H2_mat, block_size);%��base_matrixչ��ȫ����Ϊ0��1����
[~ ,H2_T_inv] = func_inv2 (H2') ;%��˹��Ԫ���棬�����Ʊ�ʾ
%���б���
u_data=round(rand(1,(N-M)*block_size));
c_data = encoder(u_data,H1,H2_T_inv);


















