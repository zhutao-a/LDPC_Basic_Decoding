function error_bit=count_error(n_code,d_msg)
[M,N]=size(d_msg);
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
error_bit=sum(sum(mod(b1+d_msg,2)));
% disp(error_bit);
