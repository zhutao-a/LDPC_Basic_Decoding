function msg=put_zeros(msg)

for i=1:239
    for j=1:98
        msg(i,mod(i-1+j-1,239)+1)=0;
    end
end


