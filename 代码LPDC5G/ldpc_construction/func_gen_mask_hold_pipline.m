function  [mask, hold_idx] = func_gen_mask_hold_pipline(base_size)

    % hold_num = [10,  6,  4,  4,  6,  3, 4];
    % rate_mode = 106 - base_size(2) + 1;
    hold_num = mod(base_size(2)-base_size(1),base_size(1));
	mar = 2;         % margin in order to prevent collision
    prob = 0;      % probability to mask another row insdie the belt
    hold_idx_diff = 0;
    while ismember(1,hold_idx_diff) || ismember(0,hold_idx_diff)
        %hold_idx = randi([mar,base_size(2)-mar],1,hold_num(rate_mode));
		hold_idx = randi([mar,base_size(2)-base_size(1)-1],1,hold_num);  %select the colomn which shall be hold.
        hold_idx_diff = diff(sort(hold_idx));
    end
    mask = true(base_size);
    ena_idx = 1:1:5;
%     for j = 1:base_size(2)
	for j = 1:base_size(2)-base_size(1)
        mask(ena_idx,j) = 0;
        tmp = rand();
        if tmp < prob
            ena_idx_2 = ena_idx(randi(5));
            mask(ena_idx_2,j) = 1;
        end
        if ~ismember(j, hold_idx)
            ena_idx = mod(ena_idx,base_size(1)) + 1; %lxz
%             ena_idx = mod((mod(ena_idx,base_size(1)) + 4),base_size(1)) + 1; %djh
        end
	end
	
	
	for j = base_size(2)-base_size(1)+1:base_size(2)
        mask(ena_idx,j) = 0;
        tmp = rand();
        if tmp < prob
            ena_idx_2 = ena_idx(randi(5));
            mask(ena_idx_2,j) = 1;
        end
            ena_idx = mod(ena_idx,base_size(1)) + 1; %lxz
%             ena_idx = mod((mod(ena_idx,base_size(1)) + 4),base_size(1)) + 1; %djh
	end
end