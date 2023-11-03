%
% 生成coe文件
% subpcm_rom 使用的coe文件第一个码率有效后几个码率填充全0数据；
clear;
clc;
q = 257 ;
P_PRE_CAL_NUM = 3 ;
COL_WEIGHT = 5 ;

file_name = 'am_15_145_256_1' ;
file_folder_path = 'am_base_matrix1' ;

temp_file_folder_path = ['.\', file_folder_path,'\',file_name];
base_matrix_file_name  = ['\',file_name,'.dat'] ; 
new_base_matrix_file_name   = ['\',file_name,'_m','.dat'] ;
hold_idx_file_name   = ['\hold_idx_',file_name,'.dat'] ; 
new_hold_idx_file_name   = ['\hold_idx_',file_name,'_m','.dat'] ;

rom_coe_path = temp_file_folder_path ; %
sim_path     = temp_file_folder_path; % 

%生成encoder的三个ROM.coe文件，需要加载以下三项：1、基础矩阵 2、hold_idx 3、H2逆矩阵
first_flag = 1;  % 仅用于控制是否输出第一行的coe标识句；
base_matrix = dlmread([temp_file_folder_path,new_base_matrix_file_name]);
hold_idx    = dlmread([temp_file_folder_path,new_hold_idx_file_name]); % dlmread readmatrix

[M_BASE,N_BASE] = size(base_matrix);

H2_mat = base_matrix(1:M_BASE , N_BASE-M_BASE+1:N_BASE);
H2_mat_exp = func_gen_h(H2_mat,q-1);	  % H2 扩展为元素为0/1的完整矩阵
[flag1 , inv_H2] = func_inv2 (H2_mat_exp) ;%若第一次生成 H2逆矩阵，需解除注释；

if flag1 == 0
    fprintf('encode error, h2 is not invable');
end

% dlmwrite('.\am_base_matrix\am_16_146_256_75\base_matrix_0_inv_H2.dat', inv_H2, 'delimiter','\t');
% inv_H2 =  dlmread('.\am_base_matrix\am_16_146_256_75\base_matrix_0_inv_H2.dat');

encoder_coe_gen(base_matrix, inv_H2, hold_idx, q, P_PRE_CAL_NUM, COL_WEIGHT, rom_coe_path, sim_path , first_flag);
