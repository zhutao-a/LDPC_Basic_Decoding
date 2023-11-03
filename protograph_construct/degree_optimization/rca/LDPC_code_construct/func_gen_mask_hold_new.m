function  [mask, hold_idx] = func_gen_mask_hold_new(base_size,vdeg)
    hold_num = mod(base_size(2)-base_size(1),base_size(1));
	mar = 2;
    hold_idx_diff = 0;
    while ismember(1,hold_idx_diff) || ismember(0,hold_idx_diff)
		hold_idx = randi([mar,base_size(2)-base_size(1)-1],1,hold_num);
        hold_idx_diff = diff(sort(hold_idx));
    end
    mask = true(base_size);
    ena_idx = 1:1:vdeg;
	for j = 1:base_size(2)-base_size(1)
        mask(ena_idx,j) = 0;
        tmp = rand();
        if ~ismember(j, hold_idx)
            ena_idx = mod(ena_idx,base_size(1)) + 1;
        end
	end
	for j = base_size(2)-base_size(1)+1:base_size(2)
        mask(ena_idx,j) = 0;
        tmp = rand();
        ena_idx = mod(ena_idx,base_size(1)) + 1;
	end
end