function [base_matrix_opt, mask_add, no_trapping_set_flag] = func_trapping_set_c1c2(base_matrix, blk_len, max_iter, min_vdeg)

no_trapping_set_flag = 0;
base_size = size(base_matrix);

cnt = 0;
cycle_cnt = zeros(1,12);
tic;
for first_row = 1:base_size(1)-2
    for second_row = first_row + 1:base_size(1)-1
        for thrid_row = second_row + 1:base_size(1)
            
            for first_col = 1:base_size(2)-2
                for second_col = first_col + 1:base_size(2)-1
                    for thrid_col = second_col + 1:base_size(2)
                        a11_addr = [first_row,first_col];
                        a12_addr = [first_row,second_col];
                        a13_addr = [first_row,thrid_col];
                        a21_addr = [second_row,first_col];
                        a22_addr = [second_row,second_col];
                        a23_addr = [second_row,thrid_col];
                        a31_addr = [thrid_row,first_col];
                        a32_addr = [thrid_row,second_col];
                        a33_addr = [thrid_row,thrid_col];
                        
                        a11 = base_matrix(a11_addr(1),a11_addr(2));
                        a12 = base_matrix(a12_addr(1),a12_addr(2));
                        a13 = base_matrix(a13_addr(1),a13_addr(2));
                        a21 = base_matrix(a21_addr(1),a21_addr(2));
                        a22 = base_matrix(a22_addr(1),a22_addr(2));
                        a23 = base_matrix(a23_addr(1),a23_addr(2));
                        a31 = base_matrix(a31_addr(1),a31_addr(2));
                        a32 = base_matrix(a32_addr(1),a32_addr(2));
                        a33 = base_matrix(a33_addr(1),a33_addr(2));
                     
                        masked_cnt = (a11==-1) + (a12==-1) + (a13==-1) + (a21==-1) + (a22==-1) + (a23==-1) + (a31==-1) + (a32==-1) + (a33==-1);
                        if (masked_cnt>=4)
                            continue;
                        end
                        
      
                        if(a11~=-1 && a22~=-1 && a33~=-1 && a12~=-1 && a23~=-1 && a31~=-1)
                            if (mod(a11+a22+a33-a12-a23-a31,blk_len) == 0)
                                cnt = cnt + 1;
                                cycle_cnt(cnt,1:12) = [a11_addr, a12_addr, a22_addr, a23_addr, a31_addr, a33_addr];
                            end
                        end
                        
                       if(a11~=-1 && a32~=-1 && a23~=-1 && a12~=-1 && a33~=-1 && a21~=-1)
                            if (mod(a11+a32+a23-a12-a33-a21,blk_len) == 0)
                                cnt = cnt + 1;
                                cycle_cnt(cnt,1:12) = [a11_addr, a12_addr, a21_addr, a23_addr, a32_addr, a33_addr];
                            end
                       end
                        
                       if(a21~=-1 && a32~=-1 && a13~=-1 && a22~=-1 && a33~=-1 && a11~=-1)
                            if (mod(a21+a32+a13-a22-a33-a11,blk_len) == 0)
                                cnt = cnt + 1;
                                cycle_cnt(cnt,1:12) = [a11_addr, a13_addr, a21_addr, a22_addr, a32_addr, a33_addr];
                            end
                       end
                        
                       if(a31~=-1 && a22~=-1 && a13~=-1 && a32~=-1 && a23~=-1 && a11~=-1)
                            if (mod(a31+a22+a13-a32-a23-a11,blk_len) == 0)
                                cnt = cnt + 1;
                                cycle_cnt(cnt,1:12) = [a11_addr, a13_addr, a22_addr, a23_addr, a31_addr, a32_addr];
                            end
                       end
                       
                       if(a31~=-1 && a12~=-1 && a23~=-1 && a32~=-1 && a13~=-1 && a21~=-1)
                            if (mod(a31+a12+a23-a32-a13-a21,blk_len) == 0)
                                cnt = cnt + 1;
                                cycle_cnt(cnt,1:12) = [a12_addr, a13_addr, a21_addr, a23_addr, a31_addr, a32_addr];
                            end
                       end
                       
                       if(a21~=-1 && a12~=-1 && a33~=-1 && a22~=-1 && a13~=-1 && a31~=-1)
                            if (mod(a21+a12+a33-a22-a13-a31,blk_len) == 0)
                                cnt = cnt + 1;
                                cycle_cnt(cnt,1:12) = [a12_addr, a13_addr, a21_addr, a22_addr, a31_addr, a33_addr];
                            end
                       end
                          
                    end
                end
            end

        end
    end
end

fprintf("Base matrix has %d girth-6\n", cnt);
toc;

base_matrix_opt = base_matrix;

mask_add = zeros(1,2);
mask_index = 1;

for iter=1:max_iter
    tic;

mask_valid = 0;
mask_cnt = zeros(base_size(1)*base_size(2),1);

horizon_edge_cnt = zeros(size(cycle_cnt,1),3);
% 计算 horizon edge row*1e8 + col_1*1e4 + col2
for i = 1:length(cycle_cnt)
    for j = 1:3
        horizon_edge_cnt(i,j) = 1e8*cycle_cnt(i,4*j-3) + 1e4*cycle_cnt(i,4*j-2) + cycle_cnt(i,4*j);
    end
end

for i=1:length(horizon_edge_cnt)-1
    cnt_c3 = 1;
    girth_c3 = zeros(1,3);
    girth_c3(cnt_c3,:) = horizon_edge_cnt(i,:);
    for j=i+1:length(horizon_edge_cnt)
        tmp_col = unique([horizon_edge_cnt(i,1),horizon_edge_cnt(i,2),horizon_edge_cnt(i,3),...
                            horizon_edge_cnt(j,1),horizon_edge_cnt(j,2),horizon_edge_cnt(j,3)]);
        if (length(tmp_col) <= 5)
            cnt_c3 = cnt_c3 + 1;
            girth_c3(cnt_c3,:) = horizon_edge_cnt(j,:);

            for n = 1:length(tmp_col)
                tmp_row = floor(tmp_col(n) / 1e8);
                tmp_col_1 = floor((tmp_col(n)-tmp_row*1e8) / 1e4);
                tmp_col_2 = tmp_col(n) - tmp_row*1e8 - tmp_col_1*1e4 ;
                mask_cnt((tmp_row-1)*(base_size(2))+tmp_col_1) = mask_cnt((tmp_row-1)*(base_size(2))+tmp_col_1) + 1;
                mask_cnt((tmp_row-1)*(base_size(2))+tmp_col_2) = mask_cnt((tmp_row-1)*(base_size(2))+tmp_col_2) + 1;
            end

        end
    end
 
end

% 提前跳出
if((mask_index ~= iter) || (iter > max_iter))
    fprintf("Finish deleting ");   
    if (mask_cnt == zeros(base_size(1)*base_size(2),1))
        no_trapping_set_flag = 1;
        fprintf("and there are no trapping sets.\n");
    else
        fprintf("but there still exist %d trapping sets.\n",sum(mask_cnt));
    end
    toc;
    break;
end

fprintf("there exist %d trapping sets.\n",sum(mask_cnt));

%统计参与trapping set最多的节点
[a,b]=sort(mask_cnt,'descend');
for delete_index = 1:length(mask_cnt)
    if (mask_valid == 1)
        break;
    end
    tmp_col = mod(b(delete_index),base_size(2));
    if(tmp_col == 0)
        tmp_col = base_size(2);
    end
    tmp_row = (b(delete_index)-tmp_col) / base_size(2) + 1;
    
    if a(delete_index)==0 % 未参与环
        continue
    end
    if base_matrix_opt(tmp_row,tmp_col)<0 % 已经掩过
        continue
    end
    if (tmp_col-tmp_row) == (base_size(2)-base_size(1)) % H2 对角线
        continue
    end
    if sum(base_matrix_opt(:,tmp_col)>=0)<=min_vdeg
        continue
    end
    
    mask_valid = 1;
    mask_add(mask_index,:) = [tmp_row,tmp_col];
    base_matrix_opt(tmp_row,tmp_col) = -1;
    fprintf("Node %d (%d, %d) has been masked, which is involved in %d trapping sets. \n",iter,tmp_row,tmp_col,a(delete_index));
    mask_index = mask_index + 1;
    filename = sprintf('base_matrix_masked_%d.txt',iter);
    dlmwrite(filename,base_matrix_opt,'\t');
    start_of_jjjj = length(cycle_cnt);
    for jjjj=start_of_jjjj:-1:1
        for kkkk=1:6
            if (cycle_cnt(jjjj,2*kkkk-1) == tmp_row && cycle_cnt(jjjj,2*kkkk) == tmp_col)
                cycle_cnt(jjjj,:) = [];
                break;
            end
        end
    end

end

toc;

end

end