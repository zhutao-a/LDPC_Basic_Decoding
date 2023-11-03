
%i_rate_mode = 5 ; %�1�7څ�1�7�1�7�1�7�1�7�0�0�0�4
BLOCK_SIZE 	= 256 ;
u_data_path = './u_data_001.txt';
fid=fopen(u_data_path);
tline = fgetl(fid);
fclose(fid);
u_data = str2num(tline(:)) ;
% 校验矩阵需满足 H2（校验矩阵后M列）可逆。
for i_rate_mode = 0 : 6
	if i_rate_mode == 0
		base_matrix_path 	= './4KV1_BASE_matrix/base_matrix_0.dat' ;
		hold_idx_path 		= './4KV1_BASE_matrix/hold_idx_0.dat';
        output_path         = './4KV1_BASE_matrix/o_code_data_0.txt';
		m_output_path       = './4KV1_BASE_matrix/m_o_code_data_0.txt';
        PCM_MASK = 2 ;
		N_BASE = 146;
		M_BASE = 16 ;%�1�7�1�7�1�7���1�7�1�7�˄1�7�1�7�1�7�1�7
	elseif i_rate_mode == 1
		base_matrix_path 	= './4KV1_BASE_matrix/base_matrix_1.dat' ;
		hold_idx_path 		= './4KV1_BASE_matrix/hold_idx_1.dat';
        output_path         = './4KV1_BASE_matrix/o_code_data_1.txt';
		m_output_path       = './4KV1_BASE_matrix/m_o_code_data_1.txt';
        PCM_MASK = 2 ;
		N_BASE = 145 ;
		M_BASE = 15 ;%�1�7�1�7�1�7���1�7�1�7�˄1�7�1�7�1�7�1�7
	elseif i_rate_mode == 2
		base_matrix_path 	= './4KV1_BASE_matrix/base_matrix_2.dat' ;
		hold_idx_path 		= './4KV1_BASE_matrix/hold_idx_2.dat';
        output_path         = './4KV1_BASE_matrix/o_code_data_2.txt';
		m_output_path       = './4KV1_BASE_matrix/m_o_code_data_2.txt';
        PCM_MASK = 36 ;
		N_BASE = 144 ;
		M_BASE = 14 ;%�1�7�1�7�1�7���1�7�1�7�˄1�7�1�7�1�7�1�7
	elseif i_rate_mode == 3
		base_matrix_path 	= './4KV1_BASE_matrix/base_matrix_3.dat' ;
		hold_idx_path 		= './4KV1_BASE_matrix/hold_idx_3.dat';
        output_path         = './4KV1_BASE_matrix/o_code_data_3.txt';
		m_output_path       = './4KV1_BASE_matrix/m_o_code_data_3.txt';
        PCM_MASK = 32 ;
		N_BASE = 143 ;
		M_BASE = 13 ;%�1�7�1�7�1�7���1�7�1�7�˄1�7�1�7�1�7�1�7
	elseif i_rate_mode == 4
		base_matrix_path 	= './4KV1_BASE_matrix/base_matrix_4.dat' ;
		hold_idx_path 		= './4KV1_BASE_matrix/hold_idx_4.dat';
        output_path         = './4KV1_BASE_matrix/o_code_data_4.txt';
		m_output_path       = './4KV1_BASE_matrix/m_o_code_data_4.txt';
        PCM_MASK = 13 ;
		N_BASE = 141 ;
		M_BASE = 11 ;%�1�7�1�7�1�7���1�7�1�7�˄1�7�1�7�1�7�1�7
	elseif i_rate_mode == 5
		base_matrix_path 	= './4KV1_BASE_matrix/hold_idx_5.dat' ;
		hold_idx_path 		= './4KV1_BASE_matrix/hold_idx_5.dat';
        output_path         = './4KV1_BASE_matrix/o_code_data_5.txt';
		m_output_path       = './4KV1_BASE_matrix/m_o_code_data_5.txt';
        PCM_MASK = 2 ;
		N_BASE = 139 ;
		M_BASE = 9 ;%�1�7�1�7�1�7���1�7�1�7�˄1�7�1�7�1�7�1�7
    else
		base_matrix_path 	= './4KV1_BASE_matrix/hold_idx_6.dat' ;
		hold_idx_path 		= './4KV1_BASE_matrix/hold_idx_6.dat';
        output_path         = './4KV1_BASE_matrix/o_code_data_6.txt';
		m_output_path       = './4KV1_BASE_matrix/m_o_code_data_6.txt';
        PCM_MASK = 16 ;
		N_BASE = 138 ;
		M_BASE = 8 ;%�1�7�1�7�1�7���1�7�1�7�˄1�7�1�7�1�7�1�7
	end	

	% 1�1�7�1�7�0�0�1�7�1�7�0�0�1�7�1�7�1�7�1�7�1�7�0�9func_encoder�1�7�1�7
	% o_code_data = func_encoder(base_matrix_path,u_data_path,hold_idx_path,PCM_MASK) ;
	% fid = fopen(output_path ,'w');

	% for j = 1 : N_BASE - M_BASE 
	% 	func_bin2hex(u_data((j-1)*BLOCK_SIZE + 1 : j*BLOCK_SIZE, 1), fid); fprintf(fid,'\n');
	% end
	
	% for j = 1 : M_BASE
	% 	func_bin2hex(o_code_data((j-1)*BLOCK_SIZE + 1 : j*BLOCK_SIZE, 1), fid); fprintf(fid,'\n');
	% end
	% fclose(fid);

	%2�1�7�1�7�1�7�1�7�1�7�1�7�1�7�1�7�1�7�0�9func_m_encoder�1�7�1�7
	m_o_code_data = func_m_encoder(base_matrix_path,u_data_path,BLOCK_SIZE) ; % 内部

	fid = fopen(m_output_path, 'w');
	 
	for j = 1 : N_BASE - M_BASE 
		func_bin2hex(u_data((j-1)*BLOCK_SIZE + 1 : j*BLOCK_SIZE, 1), fid); fprintf(fid,'\n');
	end

	for j = 1 : M_BASE
		func_bin2hex(m_o_code_data((j-1)*BLOCK_SIZE + 1 : j*BLOCK_SIZE, 1), fid); fprintf(fid,'\n');
	end
	fclose(fid);
end