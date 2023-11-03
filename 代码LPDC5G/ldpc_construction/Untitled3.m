q=389;
base_size=[5,37];

idx_perm = randperm(q - 1) - 1;
idx_row = idx_perm(1:base_size(1));
idx_col = idx_perm(base_size(1)+1:base_size(1)+base_size(2));

base_matrix = func_gen_latin_prime(q, idx_row, idx_col);

for vi=1:base_size(2)
    while 1
        deg=0;
        for ci=1:base_size(1)
            if base_matrix(ci,vi)>=0
                deg=deg+1;
            end
        end
        if deg<=5
            break
        end
        ci=randi([1,base_size(1)]);
        base_matrix(ci,vi)=-1;
    end
end

dlmwrite('mat_full_388.dat',base_matrix,'\t');

