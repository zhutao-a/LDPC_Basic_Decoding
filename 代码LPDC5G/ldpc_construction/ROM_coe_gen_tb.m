% 文件输入为 码构造算法直接输出的 hold_idx 和 矩阵文件
% 功能：给原矩阵文件 挑选合适的 mask_value, 该mask_value 不能是 H2矩阵对角线上存在的值；
%    ：通过掩膜使H2矩阵可逆；
%    ：给 hold_idx 从小到大排序；
% 输出：mask_value 被替换成 -1 ， H2矩阵可逆 的矩阵文件，和 对应的 hold_idx ；

clear;
clc;
block_size = 256 ;
q = block_size + 1;

COL_WEIGHT = 5 ;
file_name = 'am_8_138_256_1' ;
file_folder_path = 'am_base_matrix1' ;

temp_file_folder_path = ['.\', file_folder_path,'\',file_name];
base_matrix_file_name  = ['\',file_name,'.dat'] ; 
new_base_matrix_file_name   = ['\',file_name,'_m','.dat'] ;
hold_idx_file_name   = ['\hold_idx_',file_name,'.dat'] ; 
new_hold_idx_file_name   = ['\hold_idx_',file_name,'_m','.dat'] ; 
matrix_message_file_name   = ['\matrix_message_',file_name,'_m','.dat'] ;

% file_folder_path = '.\base_matrix_cw6_mts\qc_m6_38_296_6_444' ;
% base_matrix_file_name   = '\qc_m6_38_296_6_444.dat' ;
% new_base_matrix_file_name   = '\qc_m6_38_296_6_444_m.dat' ;
% hold_idx_file_name   = '\hold_idx_qc_m6_38_296_6_444.dat' ;
% new_hold_idx_file_name   = '\hold_idx_qc_m6_38_296_6_444_m.dat' ;

base_matrix = dlmread([temp_file_folder_path,base_matrix_file_name]); % readmatrix dlmread
hold_idx    = dlmread([temp_file_folder_path,hold_idx_file_name]);

[hold_idx,I] = sort(hold_idx);
[M_BASE,N_BASE] = size(base_matrix);
H2_mat = base_matrix(1:M_BASE , N_BASE-M_BASE+1:N_BASE);
%{
o_mask_value = 1;
for mask_value = 2:block_size-1
    o_mask_value = mask_value ;
    miss_flag = 0 ;
    for i = 1:M_BASE
        if(H2_mat(i,i) == mask_value)
            miss_flag = 1 ;
        end
    end
    if(miss_flag == 0)
        break ;
    end
end
%}

BLK_SIZE_WIDTH = ceil(log2(block_size));
if(BLK_SIZE_WIDTH ~= log2(block_size))
    i_all_zero_shift = 2^BLK_SIZE_WIDTH - 1 ;
    shift_value_gen  = 1;
else
    shift_value_valid = zeros(1, M_BASE * N_BASE);
    for i=1:M_BASE
        shift_value_valid(1,(i-1)*N_BASE + 1:i*N_BASE) =  base_matrix(i,:);
    end
    shift_value_valid = unique(shift_value_valid); % 获取矩阵中的唯一值
    sort(shift_value_valid);
    shift_value_full = -1:1:(block_size-1);
    shift_value_diff = setdiff(shift_value_full, shift_value_valid); % 获取矩阵中的唯一值之外的值
    if isempty(shift_value_diff)
        shift_value_gen = 0;
    else
        i_all_zero_shift = shift_value_diff(1,1);
        o_mask_value = i_all_zero_shift ;
        shift_value_gen = 1;
    end
end

if shift_value_gen == 0
    for i = 1:M_BASE
        t_diag(1,i) = H2_mat(i,i);
    end
    t_diag = unique(t_diag);
    t_diag = sort(t_diag);
    value_i = 0 ;
    for value = 0:block_size-1 % 遍历所有移位值
        flag_aban =  0 ;
        if ismember(value,t_diag)  %如果当前移位值为 H2矩阵 对角线上的值，直接抛弃；
            continue;
        end
        for col_i = 1:N_BASE
            if length(find(base_matrix(:,col_i)==value)) > 1
                flag_aban = 1 ;
                break;
            end
        end
        if flag_aban % 如果当前移位值在某一列上的数量大于1个，则抛弃；
            continue;
        end
        value_i = value_i + 1 ;
        shift_value_set(1,value_i) = value ; % 将排除之后的移位值保存
    end
    for i = 1:length(shift_value_set) 
        shift_value_cnt(1,i) =  length(find(base_matrix==shift_value_set(1,i))); % 统计符合要求的移位值元素的数量
    end
    shift_value_cnt_min = min(shift_value_cnt);
    min_idx = find(shift_value_cnt == shift_value_cnt_min);
    o_mask_value = shift_value_set(1,min_idx(1,1)); % 挑选 元素数量最小的那个移位值作为最终的掩膜值
    shift_value_gen = 1;

end
mask_idx = find(base_matrix==o_mask_value) ; 
base_matrix(mask_idx) = -1 ;


[base_matrix_opt, valid, inv_H2] = func_full_rank_check(base_matrix, N_BASE, M_BASE, q, COL_WEIGHT);

matrix_minus_one_numb = sum(base_matrix_opt(:) == -1);
mask_num = N_BASE * COL_WEIGHT - (N_BASE*M_BASE - matrix_minus_one_numb) ;

dlmwrite([temp_file_folder_path,new_base_matrix_file_name], base_matrix_opt, 'delimiter','\t');
dlmwrite([temp_file_folder_path,new_hold_idx_file_name], hold_idx, 'delimiter','\t');

dlmwrite([temp_file_folder_path,matrix_message_file_name], 'mask_num = ', 'delimiter','');
dlmwrite([temp_file_folder_path,matrix_message_file_name], mask_num, '-append', 'delimiter','\t');
dlmwrite([temp_file_folder_path,matrix_message_file_name], 'o_mask_value = ', '-append', 'delimiter','');
dlmwrite([temp_file_folder_path,matrix_message_file_name], o_mask_value, '-append', 'delimiter','\t');

% 生成coe文件
% subpcm_rom 使用 的 coe文件 第一个码率有效后几个码率填充全0数据 ；
P_PRE_CAL_NUM = 3 ;
MASK_VALUE = o_mask_value ;

% file_name = 'qc_m6_38_296_6_356' ;
% file_folder_path = 'base_matrix_cw6_mts' ;

coe_file_folder_path = ['.\',file_folder_path,'\',file_name];
coe_base_matrix_file_name = ['\',file_name,'_m','.dat'] ;
coe_hold_idx_file_name   = ['\hold_idx_',file_name,'_m','.dat'] ; ;

% file_folder_path = '.\base_matrix_cw6_mts\qc_m6_38_296_6_444' ;
% base_matrix_file_name   = '\qc_m6_38_296_6_444_m.dat' ;
% hold_idx_file_name   = '\hold_idx_qc_m6_38_296_6_444_m.dat' ;

rom_coe_path = coe_file_folder_path ; % coe_20210805_28_286 coe_20210804

inv_H2 = 0 ;

%生成encoder的三个ROM.coe文件，需要加载以下三项：1、基础矩阵 2、hold_idx 3、H2逆矩阵   
first_flag = 1;
coe_base_matrix = dlmread([coe_file_folder_path, coe_base_matrix_file_name]);
coe_hold_idx = dlmread([coe_file_folder_path, coe_hold_idx_file_name]); % readmatrix dlmread

[M_BASE,N_BASE] = size(coe_base_matrix);
subpcm_dec = zeros(COL_WEIGHT,N_BASE);
subpcm_dec = subpcm_rom_coe_gen(coe_base_matrix, inv_H2, coe_hold_idx, q, P_PRE_CAL_NUM, COL_WEIGHT, rom_coe_path , first_flag ,MASK_VALUE);


