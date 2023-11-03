function base_matrix = func_gen_latin_prime(q, idx_row, idx_col)
    pe = func_primitive_element(q);
    gf_map = zeros(1, q - 1);
    gf_map(1) = 1;
    for i = 2:q-1
        gf_map(i) = mod(gf_map(i-1) * pe, q);
    end
    idx_map = zeros(1, q - 1);
    for i = 1:q-1
        idx_map(gf_map(i)) = i - 1;
    end
    base_matrix = bsxfun(@minus, gf_map(idx_row + 1)', gf_map(idx_col + 1));
    base_matrix = mod(base_matrix+q, q);
    for i = 1:size(base_matrix, 1)
        for j = 1:size(base_matrix, 2)
            if base_matrix(i, j) == 0
                base_matrix(i, j) = -1;
            else
                base_matrix(i, j) = idx_map(base_matrix(i, j));
            end
        end
    end
end