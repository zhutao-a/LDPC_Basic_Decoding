function [base_matrix_opt, valid, inv_H2] = func_full_rank_check(base_matrix_dts, N_BASE, M_BASE, q, COL_WEIGHT)



base_matrix_opt = base_matrix_dts;
base_mat_2 = base_matrix_dts(:, N_BASE-M_BASE+1:N_BASE);

mask_col = [];
for j = 1:M_BASE
    cnt = 0;
    for i = 1:M_BASE
        if(base_mat_2(i,j)~=-1)
            cnt = cnt + 1;
        end
    end
    % if(cnt == COL_WEIGHT || cnt == COL_WEIGHT-1)
    if(cnt == COL_WEIGHT ) %
        mask_col = [mask_col,j];
    end

end

fprintf("col can be masked ");
for j = 1:size(mask_col,2)
    temp = mask_col(1,j);
    fprintf(" %d ",temp);
    % fprintf("\n");
end

% disp(mask_col);

H_mat_2 = func_gen_h(base_mat_2, q-1);

rank_H_mat_2 = gfrank(H_mat_2);

fprintf("initial rank = %d\t", rank_H_mat_2); fprintf("\n");

if(rank_H_mat_2 == (q-1)*M_BASE )
    valid = 1 ;
    inv_H2= 0 ;
else
    valid = 0 ;
    inv_H2= 0 ;
end
if(valid == 1)

    fprintf("H2 is invable, jump out\n");
else
    fprintf("H2 is not invable, start search\n");   
end
% [valid, inv_H2] = func_inv2(H_mat_2);

if(valid == 1)

    fprintf("H2 is invable, jump out\n");
else
    fprintf("H2 is not invable, start search\n");   
end

% [valid, inv_H2] = func_inv2(H_mat_2);

% if(valid == 1)
%     fprintf("H2 is invable, jump out again\n");
% else
%     fprintf("H2 is not invable, start search\n");   
% end

flag_3583 = 0 ;

if((valid == 0) && ~(isempty(mask_col)) ) % && (rank_H_mat_2 >= ((q-1)*M_BASE - 3)))
    for j = 1:size(mask_col,2)

        % if(rank_H_mat_2 == (q-1)*M_BASE - 1 )
        %     base_matrix_opt = [base_matrix_dts(:,1:N_BASE-M_BASE) base_mat_2];
        %     % flag_3583 = 1 ;
        %     dlmwrite('.\base_matrix_cw6\qc_m6_28_286_6_286_5\qc_m6_28_286_6_286_3853.dat', base_matrix_opt, 'delimiter','\t');
        %     break;
        % end

        temp_col = mask_col(1,j);
        if( temp_col > (M_BASE - COL_WEIGHT + 2))
            start_position = temp_col;
        else
            start_position = temp_col + 1;
        end

        for i = start_position:temp_col + COL_WEIGHT - 1
            if(mod(i,M_BASE)==0)
                temp_row = M_BASE;
            else
                temp_row = mod(i,M_BASE);
            end
            
            base_mat_2(temp_row,temp_col) = -1;
            H_mat_2 = func_gen_h(base_mat_2, q-1);
            rank_H_mat_2 = gfrank(H_mat_2);
            fprintf("rank = %d\t \n", rank_H_mat_2);

            if(rank_H_mat_2 ~= (q-1)*M_BASE )
                if(rank_H_mat_2 == (q-1)*M_BASE - 1 || rank_H_mat_2 == (q-1)*M_BASE - 2)
                    base_matrix_opt = [base_matrix_opt(:,1:N_BASE-M_BASE) base_mat_2];
                    % flag_3583 = 1 ;
                    % dlmwrite('.\qc_m6_38_296_6_296\qc_pcoa_32_290_5_4095.dat', base_matrix_opt, 'delimiter','\t');
                    break; % 在这里设置跳出，防止在同一列掩膜多个元素；
                end
                base_mat_2 = base_matrix_opt(:, N_BASE-M_BASE+1:N_BASE);
                % fprintf("current H2 is not full rank"); fprintf("\n");
                continue;
            end
            % 使用计算逆矩阵方式判断可逆
            % [valid, inv_H2] = func_inv2(H_mat_2);
            % 使用满秩方式判断可逆
            if(rank_H_mat_2 == (q-1)*M_BASE )
                valid = 1 ;
            else
                valid = 0 ;
            end
            if(valid == 1)
                fprintf("H2 is invable, jump out\n");
            else
                fprintf("H2 is not invable, start search\n");   
            end

            if(valid == 1)
                base_matrix_opt = [base_matrix_opt(:,1:N_BASE-M_BASE) base_mat_2];
                break;
            else
                base_mat_2 = base_matrix_opt(:, N_BASE-M_BASE+1:N_BASE);
            end     
        end
        
        if(valid == 1)
            break;
        end
        if(flag_3583 == 1)
            break ;
        end
    end

end

if(valid == 0)
    fprintf("can not find the invable H2 \n");   
end



end
