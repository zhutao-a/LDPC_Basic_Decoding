function h_full= h_full_generate(base_matrix, blk_len)%��base_matrixչ��ȫ����Ϊ0��1����
[m,n]=size(base_matrix);
h_full = zeros(m*blk_len,n*blk_len);
for i = 1:m
    for j = 1:n
        if base_matrix(i, j) >= 0 
            h_full((i-1)*blk_len+1:i*blk_len, (j-1)*blk_len+1:j*blk_len) = circshift(eye(blk_len), base_matrix(i, j), 2);%��ѭ���ƶ�
        end          
    end
end
