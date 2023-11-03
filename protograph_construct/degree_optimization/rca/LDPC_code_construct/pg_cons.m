base_size = [28,286];
for cnu_count=[5,6]
    [mask, hold_idx] = func_gen_mask_hold_new(base_size,cnu_count);
    pg=1-mask;
    fn=sprintf("pg_%d_%d_%d.txt",base_size(1),base_size(2),cnu_count);
    dlmwrite(fn,pg,'\t');
    fn=sprintf("hold_idx_%d_%d_%d.txt",base_size(1),base_size(2),cnu_count);
    dlmwrite(fn,hold_idx,'\t');
end
