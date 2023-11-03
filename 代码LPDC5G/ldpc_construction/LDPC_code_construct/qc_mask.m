mat=importdata('qc_pcoa_28_286_5.txt');
[base_matrix_opt, mask_add, no_trapping_set_flag] = func_trapping_set_c1c2(mat, 128, 201, 3);
