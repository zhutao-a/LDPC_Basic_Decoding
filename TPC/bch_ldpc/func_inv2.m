function [valid, G]=func_inv2(H)%��˹��Ԫ���棬�����Ʊ�ʾ
%һ������Ϊ�����һ�У����α�������˹��Ԫ�Ͱ���������λ����ұ߲�ȫ�ĵ�λ��Ҳ����ͬ���Ĳ����������������
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




