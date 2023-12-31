function [P,rearranged_cols]=H2P(H)

[rows,cols]=size(H);

rearranged_cols=zeros(1, rows);%1行rows列零矩阵

%逐行进行高斯消元，前面的rows行 x rows列形成单位矩阵
for k=1:rows
    vec = k:cols;

    %查找可交换的列
    x = k;
    while (x<=cols && H(k,x)==0)
        ind = find(H(k+1:rows, x) ~= 0, 1);%find(*,1)找到第一个非零元
        if ~isempty(ind)%参量为空，返回值为真
            break
        end
        x = x + 1;
    end

    %如果找不到可交换的列则视为非法的H矩阵并退出
    if x>cols
        error('Invalid H matrix.');
    end

    %如果不是当前列则进行列交换，同时保存交换记录
    if (x~=k)
        rearranged_cols(k)=x;
        temp=H(:,k);
        H(:,k)=H(:,x);
        H(:,x)=temp;
    end

    %高斯消元，使G(k,k)==1
    %若对角线元素为0
    if (H(k,k)==0)
        ind = find(H(k+1:rows, k) ~= 0);
        ind_major = ind(1);
        x = k + ind_major;
        H(k, vec) = rem(H(x, vec) + H(k, vec), 2);%？不明白
    end

    %高斯消元，使得第k列除G(k,k)==1外其他位置为0
    ind = find(H(:, k) ~= 0)';
    for x = ind
        if x ~= k
            H(x, vec) = rem(H(x, vec) + H(k, vec), 2);
        end
    end
end

P=H(:,rows+1:cols);
