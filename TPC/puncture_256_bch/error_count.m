function error_bit=error_count(n_code,code)
b1=zeros(239,239);
for i=1:239
    for j=1:239
        if(n_code(i,j)>0)
            b1(i,j)=0;
        else
            b1(i,j)=1;
        end
    end
end
error_bit=0;
for i=1:239
    for j=1:239
        if(i+97<=239)%ǰ��û��
            if(j<i||j>i+97)%��Ϣλ
                if(b1(i,j)~=code(i,j))
                    error_bit=error_bit+1;
                end
            end
        else%ǰ����
            if(j>mod(97+i,239)&&j<i)%��Ϣλ
                if(b1(i,j)~=code(i,j))
                    error_bit=error_bit+1;
                end
            end
        end
    end
end

