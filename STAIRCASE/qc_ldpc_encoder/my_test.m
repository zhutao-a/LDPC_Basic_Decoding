clear;
clear all;
%准备工作
block_size=52;
base_matrix=load('base_matrix.txt');
[M,N]=size(base_matrix);%行数M，列数N
H1_mat = base_matrix(:,1:N-M);%base_matrix的前K=N-M列
H2_mat = base_matrix(:,N-M+1:N);%base_matrix的后M列
H1= h_full_generate(H1_mat, block_size);%将base_matrix展开全，变为0，1矩阵
H2= h_full_generate(H2_mat, block_size);%将base_matrix展开全，变为0，1矩阵
[~ ,H2_T_inv] = func_inv2 (H2') ;%高斯消元求逆，二进制表示
%进行编码
u_data=round(rand(1,(N-M)*block_size));
c_data = encoder(u_data,H1,H2_T_inv);


















