function [base_matrix, hold_idx] = Step_3_base_matrix_gen(q, M_BASE, N_BASE, P_PRE_CAL_NUM)
%% ????
% ???????????

% BLK_SIZE = q - 1 ;

%% ????????????

% ??????????
base_size = [M_BASE, N_BASE] ;

idx_perm = randperm(q - 1) - 1;
idx_row = idx_perm(1:base_size(1));
idx_col = idx_perm(base_size(1)+1:base_size(1)+base_size(2));

% ??? 
base_matrix = func_gen_latin_prime(q, idx_row, idx_col);
[mask, hold_idx] = func_gen_mask_hold_new(size(base_matrix));
% mask = dlmread('./base_matrix_protograph/16_144_256_protograph_mask.dat');
mask = logical(mask);
% dlmwrite('mask.dat', mask, 'delimiter','\t');

hold_idx = sort(hold_idx);
% hold_idx = 0;
base_matrix(mask) = -1;
base_matrix(1,N_BASE - P_PRE_CAL_NUM) = -1; 
% base_matrix(base_matrix==q-2)=-1;

% 
% dlmwrite('base_matrix.dat', base_matrix, 'delimiter','\t');
% dlmwrite('hold_idx.dat', hold_idx, 'delimiter','\t');

%base_matrix=util_mask(base_matrix);
%dlmwrite('base_matrix.dat', base_matrix, 'delimiter','\t');

fprintf("base_matrix is generated.\n");

end