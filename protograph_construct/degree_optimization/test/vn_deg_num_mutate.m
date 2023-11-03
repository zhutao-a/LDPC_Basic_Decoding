function vn_deg_num=vn_deg_num_mutate(vn_deg_num,max_mutate_times)%变量节点度突变方式
global  vn_deg_min;     global  vn_deg_max;
mutate_times=randi(max_mutate_times);%最大变异次数
for i=1:mutate_times
    %用于边增加1
    nozero_index=find(vn_deg_num~=0);%找到vn_deg_num中不为0的索引
    r1=randi(length(nozero_index));
    lshift_out=nozero_index(r1);%需要左移的度对应的变量节点索引
    while((lshift_out+vn_deg_min-1)==vn_deg_min)%不能取最小度
        r1=randi(length(nozero_index));
        lshift_out=nozero_index(r1);%需要左移的度对应的变量节点索引
    end
    lshift_in=lshift_out-1;
    vn_deg_num(lshift_out)=vn_deg_num(lshift_out)-1;
    vn_deg_num(lshift_in)=vn_deg_num(lshift_in)+1;
    %用于边减少1
    nozero_index=find(vn_deg_num~=0);%找到vn_deg_num中不为0的索引
    r2=randi(length(nozero_index));
    rshift_out=nozero_index(r2);%需要右移的度对应的变量节点索引
    while((rshift_out+vn_deg_min-1)==vn_deg_max)
        r2=randi(length(nozero_index));
        rshift_out=nozero_index(r2);%需要右移的度对应的变量节点索引
    end
    rshift_in=rshift_out+1;
    vn_deg_num(rshift_out)=vn_deg_num(rshift_out)-1;
    vn_deg_num(rshift_in)=vn_deg_num(rshift_in)+1;
end

