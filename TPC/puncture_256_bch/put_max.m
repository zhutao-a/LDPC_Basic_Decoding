function n_code=put_max(n_code,data_ram_max,k)

for i=1:239
    for j=1:98
        n_code(i,mod(i-1+j-1,239)+1)=k*data_ram_max;
    end
end


