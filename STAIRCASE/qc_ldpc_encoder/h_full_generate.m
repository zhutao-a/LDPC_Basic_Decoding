function h_full= h_full_generate(base_matrix, blk_len)%将base_matrix展开全，变为0，1矩阵
[m,n]=size(base_matrix);
h_full = zeros(m*blk_len,n*blk_len);
for i = 1:m
    for j = 1:n
        if base_matrix(i, j) >= 0 
            h_full((i-1)*blk_len+1:i*blk_len, (j-1)*blk_len+1:j*blk_len) = circshift(eye(blk_len), base_matrix(i, j), 2);%行循环移动
        end          
    end
end
