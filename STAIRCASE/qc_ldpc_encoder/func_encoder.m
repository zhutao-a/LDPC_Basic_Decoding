function p_T = func_encoder(base_matrix_path,u_data_path,hold_idx_path,PCM_MASK)
	base_matrix = load (base_matrix_path) ;
	fid=fopen(u_data_path);
	u_data_str = fgetl(fid);
	fclose(fid);
	hold_idx = load (hold_idx_path);

	q = 257;
	N_BASE = size(base_matrix,2) ;   %������������
	M_BASE = size(base_matrix,1) ;
    K_BASE = N_BASE - M_BASE;
	BLOCK_SIZE = q-1;
	COL_WEIGHT = 5	;
	P_PRE_CAL_NUM = 3;
%	PCM_MASK = 2 	;           %�޸�����Ĥ��ǣ�����Ҫ�޸�����
	IN_BLK_PARALLEL = 64;		% ����У��λ�ļ��㲢�ж�
% 	base_matrix(:,N_BASE) = -1;
% 	base_matrix(M_BASE,N_BASE - M_BASE +1:N_BASE) = -1;
% 	base_matrix(M_BASE,N_BASE  ) = 0;
	H2_mat = base_matrix(1:M_BASE , N_BASE-M_BASE+1:N_BASE);
% 	H2_mat( :,M_BASE )  = -1 ;        			% H2���һ���Ӿ������㣬���������½ǵ�λ����
% 	H2_mat( M_BASE,: )  = -1 ;					% H2���һ���Ӿ������㣬���������½ǵ�λ����
% 	H2_mat( M_BASE,M_BASE )  = 0  ;					% H2�����½�Ԫ�����㣨����λ����
	H2_mat_shift = zeros(M_BASE-P_PRE_CAL_NUM,5);
	OFFSET_1 = 0;% ��ʼֵ����ڵ�һ��CNUδ���ڵ��Ŀ���Ϊ1-5��λ��ֵ������Ϊ��
	OFFSET_2 = OFFSET_1 - COL_WEIGHT + 1 ;% ��ʼֵ����ڵ�һ��CNUδ���ڵ��Ŀ���Ϊ1-5��λ��ֵ������Ϊ��

	for i = 1:M_BASE-P_PRE_CAL_NUM
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
				H2_mat_shift(i,j-start_position+1) = PCM_MASK;
			else
				H2_mat_shift(i,j-start_position+1) = base_matrix(i,CNU_num+N_BASE-M_BASE);
			end
		end
    end
	
	u_data = str2num(u_data_str(:)) ; 		%��ȡδ����ԭʼ��Ϣλ
	u_data_T = u_data.' ;

	H1_mat = base_matrix(1:M_BASE , 1:N_BASE-M_BASE);
	H1_mat_exp = func_gen_h(H1_mat , BLOCK_SIZE);
	result = zeros(1 , M_BASE*BLOCK_SIZE) ;
	u_data_block_0 = zeros(N_BASE-M_BASE , BLOCK_SIZE) ;
	u_data_block_1 = zeros(N_BASE-M_BASE , BLOCK_SIZE) ;
	u_data_block_2 = zeros(N_BASE-M_BASE , BLOCK_SIZE) ;
	u_data_block_3 = zeros(N_BASE-M_BASE , BLOCK_SIZE) ;
	u_data_block_4 = zeros(N_BASE-M_BASE , BLOCK_SIZE) ;
	u_data_block_shift = zeros(M_BASE , BLOCK_SIZE) ;
	shifer_number = zeros(N_BASE-M_BASE , 5) ;
	input_my = zeros(1,COL_WEIGHT) ;
	col_i = 1;
	n_hold_idx = 1 ;  								%hold_idx Ԫ���±��ʼֵ
	hold_idx_size = size(hold_idx , 2);  			%��� hold_idx Ԫ�ظ���
    
    hold_index_cnt = 0;

    for i = 1:K_BASE
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

            if(base_matrix(CNU_num,i) == -1)
                shifer_number(i,j-start_position+1) = PCM_MASK;
                
            else
                shifer_number(i,j-start_position+1) = base_matrix(CNU_num,i);
            end
        end
        if((hold_index_cnt ~= size(hold_idx,2)) && (i == hold_idx(1,hold_index_cnt+1))) 
            hold_index_cnt = hold_index_cnt + 1;
        end
    end
	%-------------------------------------------------��1��������r_T-------------------------------------------%
	n_hold_idx = 1 ;     
	for block_number = 1:N_BASE-M_BASE
		for i = 1:N_BASE-M_BASE %����ǰ�����ֶθ�����ݣ����ڲ�ͬ����λֵ
			u_data_block_0(i , :) = u_data_T(1 , (i-1)*BLOCK_SIZE+1:i*BLOCK_SIZE);
			u_data_block_1(i , :) = u_data_T(1 , (i-1)*BLOCK_SIZE+1:i*BLOCK_SIZE);
			u_data_block_2(i , :) = u_data_T(1 , (i-1)*BLOCK_SIZE+1:i*BLOCK_SIZE);
			u_data_block_3(i , :) = u_data_T(1 , (i-1)*BLOCK_SIZE+1:i*BLOCK_SIZE);
			u_data_block_4(i , :) = u_data_T(1 , (i-1)*BLOCK_SIZE+1:i*BLOCK_SIZE);
		end
		%  ������λֵ�ֱ�Ե�ǰ���ֶν�����λ
		if shifer_number(block_number,1) == PCM_MASK
			u_data_block_0(block_number,:) = 0 ;
		else
			u_data_block_0(block_number,:) = circshift(u_data_block_0(block_number,:) ,[0,-shifer_number(block_number,1)]) ;
		end
		if shifer_number(block_number,2) == PCM_MASK
			u_data_block_1(block_number,:) = 0 ;
		else
			u_data_block_1(block_number,:) = circshift(u_data_block_1(block_number,:) ,[0,-shifer_number(block_number,2)]) ;
		end	
		if shifer_number(block_number,3) == PCM_MASK
			u_data_block_2(block_number,:) = 0 ;
		else
			u_data_block_2(block_number,:) = circshift(u_data_block_2(block_number,:) ,[0,-shifer_number(block_number,3)]) ;
		end
		if shifer_number(block_number,4) == PCM_MASK
			u_data_block_3(block_number,:) = 0 ;
		else
			u_data_block_3(block_number,:) = circshift(u_data_block_3(block_number,:) ,[0,-shifer_number(block_number,4)]) ;
		end
		if shifer_number(block_number,5) == PCM_MASK
			u_data_block_4(block_number,:) = 0 ;
		else
			u_data_block_4(block_number,:) = circshift(u_data_block_4(block_number,:) ,[0,-shifer_number(block_number,5)]) ;
		end	

		%��λ���֮�󣬽���λ�����result�Ĵ�����ǰ5�ν������
		result(1,1:BLOCK_SIZE) = mod(result(1,1:BLOCK_SIZE) + u_data_block_0(block_number,:) ,2 );
		result(1,BLOCK_SIZE+1:2*BLOCK_SIZE) = mod( result(1,BLOCK_SIZE+1:2*BLOCK_SIZE) + u_data_block_1(block_number,:) ,2);
		result(1,2*BLOCK_SIZE+1:3*BLOCK_SIZE) = mod(result(1,2*BLOCK_SIZE+1:3*BLOCK_SIZE) + u_data_block_2(block_number,:) ,2 );
		result(1,3*BLOCK_SIZE+1:4*BLOCK_SIZE) = mod(result(1,3*BLOCK_SIZE+1:4*BLOCK_SIZE) + u_data_block_3(block_number,:) ,2);
		result(1,4*BLOCK_SIZE+1:5*BLOCK_SIZE) = mod( result(1,4*BLOCK_SIZE+1:5*BLOCK_SIZE) + u_data_block_4(block_number,:) ,2 );
		
		%result�Ĵ������� BLOCK_SIZE λ �������hold_idx�е�ֵ�����result��������λ����hold���ã�
		result = circshift(result,[0,- BLOCK_SIZE]);
		if (n_hold_idx <= hold_idx_size)
			if (block_number == hold_idx(1,n_hold_idx))
				result = circshift(result,[0, BLOCK_SIZE]);
				n_hold_idx = n_hold_idx + 1 ;
			end
		end 
	end
	r_T = result.' ;
	%-------------------------------------------------��2����Ԥ��У��λ����-------------------------------------------%
	H2_mat_exp = func_gen_h(H2_mat,q-1);
	[flag1 ,H2_mat_exp_inv] = func_inv2 (H2_mat_exp) ; %���H2�����
    if flag1 == 0
        fprintf('������ִ�������H2���󲻿���');
    end
	p_pre_T_1 = zeros(BLOCK_SIZE,1);
	p_pre_T_2 = zeros(BLOCK_SIZE,1);
	p_pre_T_3 = zeros(BLOCK_SIZE,1);
	p_pre_T_4 = zeros(BLOCK_SIZE,1);

	for i = 1 :IN_BLK_PARALLEL : M_BASE * BLOCK_SIZE-1  %ÿ�μ��㽫 IN_BLK_PARALLEL ����ӽ�������������ֻ��������һ��⼴��
		p_pre_T_1 = mod( p_pre_T_1 + H2_mat_exp_inv( (M_BASE-4)*BLOCK_SIZE+1:(M_BASE-3)*BLOCK_SIZE , i:i+IN_BLK_PARALLEL-1) * r_T(i:i+IN_BLK_PARALLEL-1 , 1 ) ,2);
		p_pre_T_2 = mod( p_pre_T_2 + H2_mat_exp_inv( (M_BASE-3)*BLOCK_SIZE+1:(M_BASE-2)*BLOCK_SIZE , i:i+IN_BLK_PARALLEL-1) * r_T(i:i+IN_BLK_PARALLEL-1 , 1 ) ,2);
		p_pre_T_3 = mod( p_pre_T_3 + H2_mat_exp_inv( (M_BASE-2)*BLOCK_SIZE+1:(M_BASE-1)*BLOCK_SIZE , i:i+IN_BLK_PARALLEL-1) * r_T(i:i+IN_BLK_PARALLEL-1 , 1 ) ,2);
		p_pre_T_4 = mod( p_pre_T_4 + H2_mat_exp_inv( (M_BASE-1)*BLOCK_SIZE+1: M_BASE   *BLOCK_SIZE , i:i+IN_BLK_PARALLEL-1) * r_T(i:i+IN_BLK_PARALLEL-1 , 1 ) ,2);
	end

	%--------------------------------------------------��3��:����ʣ��У��λ-------------------------------------------%
	p_T = zeros( M_BASE* BLOCK_SIZE , 1) ;
	p_T(1:BLOCK_SIZE,1) = p_pre_T_1;
	p_T(BLOCK_SIZE+1:2*BLOCK_SIZE,1) = p_pre_T_2;
	p_T(2*BLOCK_SIZE+1:3*BLOCK_SIZE,1) = p_pre_T_3;
	p_T(3*BLOCK_SIZE+1:4*BLOCK_SIZE,1) = p_pre_T_4;

	for j = 1 : M_BASE-4
		if H2_mat_shift(j,1) == PCM_MASK   
            p_T_result_1 = 0 ;
        else
            p_T_result_1 = circshift(p_T(1:BLOCK_SIZE,1),[-H2_mat_shift(j,1),0]);                 
        end
		
		if(H2_mat_shift(j,2) == PCM_MASK)    
            p_T_result_2 = 0 ;
        else
            p_T_result_2 = circshift(p_T(BLOCK_SIZE+1:2*BLOCK_SIZE,1),[-H2_mat_shift(j,2),0]);    
        end
		
		if(H2_mat_shift(j,3) == PCM_MASK)    
            p_T_result_3 = 0 ;
        else
            p_T_result_3 = circshift(p_T(2*BLOCK_SIZE+1:3*BLOCK_SIZE,1),[-H2_mat_shift(j,3),0]);  
        end
		
		if(H2_mat_shift(j,4) == PCM_MASK)    
            p_T_result_4 = 0 ;
        else
            p_T_result_4 = circshift(p_T(3*BLOCK_SIZE+1:4*BLOCK_SIZE,1),[-H2_mat_shift(j,4),0]);  
        end
		
		p_T_result_5 = mod(p_T(4*BLOCK_SIZE+1:5*BLOCK_SIZE,1) + p_T_result_1 + p_T_result_2 + p_T_result_3 + p_T_result_4 + result(1,(j-1)*BLOCK_SIZE+1 : j*BLOCK_SIZE).',2);

		p_T = circshift(p_T,[-BLOCK_SIZE,0]);
		p_T(3*BLOCK_SIZE+1:4*BLOCK_SIZE,1) = circshift(p_T_result_5,[H2_mat_shift(j,5),0]);
		
	end
	p_T = circshift(p_T,[-8*BLOCK_SIZE,0]);  %���ݹ�λ

end