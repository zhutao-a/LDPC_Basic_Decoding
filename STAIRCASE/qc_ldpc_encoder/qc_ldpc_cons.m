function base_matrix = qc_ldpc_cons(m_base,n_base,block_size)

idx_perm = randperm(block_size) - 1;
idx_row = idx_perm(1:m_base);
idx_col = idx_perm(m_base+1:m_base+n_base);

base_matrix = func_gen_latin_prime(block_size+1, idx_row, idx_col);

mask = ones(m_base,n_base);
for vi = 1:n_base
    vd = 4;
    t = vi - n_base + m_base;
    if t > 0
        mask(t,vi) = 0;
        vd = vd - 1;
    end
    while vd > 0
        ci = randi(m_base);
        if mask(ci,vi)
            mask(ci,vi) = 0;
            vd = vd - 1;
        end
    end
end

mask = logical(mask);
base_matrix(mask) = -1;

end