function pe = func_primitive_element(q)
    pe = -1;
    for i = 1:q-1
        val = 1;
        valid = 1;
        for j = 1:q-2
            val = mod(val*i, q);
            if val == 1
                valid = 0;
                break;
            end
        end
        val = mod(val*i, q);
        if and(valid, val == 1) 
            pe = i;
            break;
        end
    end
end