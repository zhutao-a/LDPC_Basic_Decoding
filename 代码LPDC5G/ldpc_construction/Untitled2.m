%������������
clear ;
clc ;
M_BASE = 8;
N_BASE = 138;
M = M_BASE;
P_PRE_CAL_NUM = 3;
q = 257;

[base_matrix, hold_idx] = Step_3_base_matrix_gen(q, M_BASE, N_BASE, P_PRE_CAL_NUM);

matrix_minus_one_numb = sum(base_matrix(:) == -1);

mask_num = N_BASE * 5 - (N_BASE*M_BASE - matrix_minus_one_numb) ;
display(mask_num)
mkdir('./am_base_matrix1/am_8_138_256_');
dlmwrite('./am_base_matrix1/am_8_138_256_/am_8_138_256_.dat', base_matrix, 'delimiter','\t');
dlmwrite('./am_base_matrix1/am_8_138_256_/hold_idx_am_8_138_256_.dat', hold_idx, 'delimiter','\t');
