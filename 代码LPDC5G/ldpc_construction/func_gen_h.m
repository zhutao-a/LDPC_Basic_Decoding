function h_mat = func_gen_h(base_matrix, blk_len)
    h_mat = zeros(size(base_matrix) * blk_len);
    for i = 1:size(base_matrix, 1)
        for j = 1:size(base_matrix, 2)
            if base_matrix(i, j) >= 0
                h_mat((i-1)*blk_len+1:i*blk_len, (j-1)*blk_len+1:j*blk_len) = circshift(eye(blk_len), base_matrix(i, j), 2);
            end          
        end
    end
end