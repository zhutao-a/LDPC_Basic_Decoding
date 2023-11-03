function [valid, G]=func_inv2(H)%高斯消元求逆，二进制表示
%一个数作为矩阵的一行，依次遍历，高斯消元就把两个数按位异或，右边补全的单位阵也进行同样的操作，最后就是逆矩阵
[m,n] = size(H);
matrix = [H eye(m,n)];
valid = 1;
for i=1:n
    for j=i:m
        if(matrix(j,i) == 1)
            if(j==i)
                break;
            end
            matrix([i, j], :) = matrix([j, i], :);
            break;
        end
        if(j == m)
            valid = 0;
        end
    end
    
    for j=1:m
        if(matrix(j,i) == 1 && j~=i)
            matrix(j,:) = mod(matrix(j,:)+matrix(i,:),2);
        end
             
    end
end
G = matrix(:,n+1:n+m);




