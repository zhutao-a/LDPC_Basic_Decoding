function encoder_coe_gen(base_matrix, inv_H2, hold_idx, q, P_PRE_CAL_NUM, COL_WEIGHT, rom_coe_path, sim_path , first_flag)

%% 基础矩阵读取及参数

% load('base_matrix_dxy.mat');
% base_matrix = dlmread('base_matrix1_16_144.dat');
% 
% q = 257;
% P_PRE_CAL_NUM = 3;
% COL_WEIGHT = 5;


BLK_SIZE = q - 1;
BLK_SIZE_WIDTH = ceil(log2(BLK_SIZE - 1));
[M_BASE,N_BASE] = size(base_matrix);
K_BASE = N_BASE - M_BASE;
N = N_BASE * BLK_SIZE;
M = M_BASE * BLK_SIZE;
K = K_BASE * BLK_SIZE;

% base_matrix(:,N_BASE) = -1;
% base_matrix(M_BASE,N_BASE - M_BASE +1:N_BASE) = -1;
% base_matrix(M_BASE,N_BASE  ) = 0;

%% 3个ROM的coe文件打印

% 确定逆矩阵被掩掉时的移位值，块大小为256时需要特殊生成
i_all_zero_shift = 2 ;
% if(BLK_SIZE_WIDTH ~= log2(BLK_SIZE))
    % i_all_zero_shift = 2^BLK_SIZE_WIDTH - 1 ;
% else
    % shift_value_valid = zeros(1, M_BASE * N_BASE);
    % for i=1:M_BASE
        % shift_value_valid(1,(i-1)*N_BASE + 1:i*N_BASE) =  base_matrix(i,:);
    % end
    % shift_value_valid = unique(shift_value_valid);
    % sort(shift_value_valid);
    % shift_value_full = -1:1:(BLK_SIZE-1);
    % shift_value_diff = setdiff(shift_value_full, shift_value_valid);
    % i_all_zero_shift = shift_value_diff(1,1);
% end

% % subpcm_rom 按列打印
% fp_s_path = fullfile(rom_coe_path, 'subpcm_rom_value.coe') ;
% fp_s = fopen(fp_s_path,'a');
% if (first_flag)
% 	fprintf(fp_s,'memory_initialization_radix = 2;\n');
% 	fprintf(fp_s,'memory_initialization_vector =');
% end

OFFSET_1 = 0;% 初始值相对于第一列CNU未被掩掉的块编号为1-5的位移值，向下为正
hold_index_cnt = 0;

% for i = 1:N_BASE
%     fprintf(fp_s,'\n');   
    
%     if(hold_index_cnt == size(hold_idx,2))
%         fprintf(fp_s,'0'); 
%     %elseif(i == hold_idx(1,hold_index_cnt+1) - 1) %解码器需要提前预读cblk_mem,所以需要提前一列标注hold_idx
%     elseif(i == hold_idx(1,hold_index_cnt+1))
%         fprintf(fp_s,'1'); 
%     else
%         fprintf(fp_s,'0'); 
%     end
    
%     if(mod(i+OFFSET_1-hold_index_cnt,M_BASE)==0)
%         start_position = M_BASE;
%     else
%         start_position = mod(i+OFFSET_1-hold_index_cnt,M_BASE);
%     end
    
%     for j = start_position:start_position + COL_WEIGHT - 1
%         if(mod(j,M_BASE)==0)
%             CNU_num = M_BASE;
%         else
%             CNU_num = mod(j,M_BASE);
%         end
        
%         if(base_matrix(CNU_num,i)==-1)
%             temp = num2str(dec2bin(i_all_zero_shift, BLK_SIZE_WIDTH));
%         else
%             temp = num2str(dec2bin(base_matrix(CNU_num,i), BLK_SIZE_WIDTH));
%         end

%         fprintf(fp_s,'%s',temp);
%     end
    
%     if((hold_index_cnt ~= size(hold_idx,2)) && (i == hold_idx(1,hold_index_cnt+1))) 
%         hold_index_cnt = hold_index_cnt + 1;
%     end
% end
% %fprintf(fp_s,'\n');
% fclose(fp_s);

i_all_zero_shift = 2 ;

% ROM_H1_shift 按列打印
fp1_path = fullfile(rom_coe_path, 'ROM_H1_shift_value.coe') ;
fp1 = fopen(fp1_path,'a');

if (first_flag)
	fprintf(fp1,'memory_initialization_radix = 2;\n');
	fprintf(fp1,'memory_initialization_vector =');
end

hold_index_cnt = 0;

for i = 1:K_BASE
    fprintf(fp1,'\n');   
    
    if(hold_index_cnt == size(hold_idx,2))
        fprintf(fp1,'0'); 
    elseif(i == hold_idx(1,hold_index_cnt+1))
        fprintf(fp1,'1'); 
    else
        fprintf(fp1,'0'); 
    end
    
    if(mod(i+OFFSET_1-hold_index_cnt,M_BASE)==0)
        start_position = M_BASE;
    else
        start_position = mod(i+OFFSET_1-hold_index_cnt,M_BASE);
    end
    
    for j = start_position:start_position + COL_WEIGHT - 1
        if(mod(j,M_BASE)==0)
            CNU_num = M_BASE;
        else
            CNU_num = mod(j,M_BASE);
        end
        
        if(base_matrix(CNU_num,i)==-1)
            temp = num2str(dec2bin(i_all_zero_shift, BLK_SIZE_WIDTH));
        else
            temp = num2str(dec2bin(base_matrix(CNU_num,i), BLK_SIZE_WIDTH));
        end

        fprintf(fp1,'%s',temp);
    end
    
    if((hold_index_cnt ~= size(hold_idx,2)) && (i == hold_idx(1,hold_index_cnt+1))) 
        hold_index_cnt = hold_index_cnt + 1;
    end
end
%fprintf(fp1,'\n');
fclose(fp1);

% ROM_H2_shift 按行打印
fp2_path = fullfile(rom_coe_path, 'ROM_H2_shift_value.coe') ;
fp2 = fopen(fp2_path,'a');

if (first_flag)
	fprintf(fp2,'memory_initialization_radix = 2;\n');
	fprintf(fp2,'memory_initialization_vector =');
end

OFFSET_2 = OFFSET_1 - COL_WEIGHT + 1 ;% 初始值相对于第一行CNU未被掩掉的块编号为1-5的位移值，向右为正
for i = 1:M_BASE-P_PRE_CAL_NUM
    fprintf(fp2,'\n');
    if(mod(i+OFFSET_2,M_BASE)==0)
        start_position = M_BASE;
    else
        start_position = mod(i+OFFSET_2,M_BASE);
    end
    
    for j = start_position:start_position + COL_WEIGHT - 1
        if(mod(j,M_BASE)==0)
            CNU_num = M_BASE;
        else
            CNU_num = mod(j,M_BASE);
        end
        
        if(base_matrix(i,CNU_num+N_BASE-M_BASE)==-1)
            temp = num2str(dec2bin(i_all_zero_shift, BLK_SIZE_WIDTH));
        else
            temp = num2str(dec2bin(base_matrix(i,CNU_num+N_BASE-M_BASE), BLK_SIZE_WIDTH));
        end

        fprintf(fp2,'%s',temp);
    end
end
%fprintf(fp2,'\n');
fclose(fp2);

% ROM_H2_inv 打印inv_H2最后三行每个矩阵块的第一列
fp3_path = fullfile(rom_coe_path, 'ROM_H2_inv_value.coe') ;
fp3 = fopen(fp3_path,'a');

if (first_flag)
	fprintf(fp3,'memory_initialization_radix = 2;\n');
	fprintf(fp3,'memory_initialization_vector =');
end
for i = 0:M_BASE-1
    fprintf(fp3,'\n');
    for j = (M_BASE-P_PRE_CAL_NUM) * BLK_SIZE+ 1 : M_BASE * BLK_SIZE % print the first column line of H2 inv matrix,
        fprintf(fp3,'%s',num2str(inv_H2(j,i*BLK_SIZE+1)));
    end
    
end
%fprintf(fp3,'\n');
fclose(fp3);
