function error_bit=error_count(n_code,code)
[M,N]=size(code);
b1=zeros(M,N);
for i=1:M
    for j=1:N
        if(n_code(i,j)>0)
            b1(i,j)=0;
        else
            b1(i,j)=1;
        end
    end
end
error_bit=sum(sum(mod(b1+code,2)));

