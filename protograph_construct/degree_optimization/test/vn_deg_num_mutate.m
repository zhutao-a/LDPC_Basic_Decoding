function vn_deg_num=vn_deg_num_mutate(vn_deg_num,max_mutate_times)%�����ڵ��ͻ�䷽ʽ
global  vn_deg_min;     global  vn_deg_max;
mutate_times=randi(max_mutate_times);%���������
for i=1:mutate_times
    %���ڱ�����1
    nozero_index=find(vn_deg_num~=0);%�ҵ�vn_deg_num�в�Ϊ0������
    r1=randi(length(nozero_index));
    lshift_out=nozero_index(r1);%��Ҫ���ƵĶȶ�Ӧ�ı����ڵ�����
    while((lshift_out+vn_deg_min-1)==vn_deg_min)%����ȡ��С��
        r1=randi(length(nozero_index));
        lshift_out=nozero_index(r1);%��Ҫ���ƵĶȶ�Ӧ�ı����ڵ�����
    end
    lshift_in=lshift_out-1;
    vn_deg_num(lshift_out)=vn_deg_num(lshift_out)-1;
    vn_deg_num(lshift_in)=vn_deg_num(lshift_in)+1;
    %���ڱ߼���1
    nozero_index=find(vn_deg_num~=0);%�ҵ�vn_deg_num�в�Ϊ0������
    r2=randi(length(nozero_index));
    rshift_out=nozero_index(r2);%��Ҫ���ƵĶȶ�Ӧ�ı����ڵ�����
    while((rshift_out+vn_deg_min-1)==vn_deg_max)
        r2=randi(length(nozero_index));
        rshift_out=nozero_index(r2);%��Ҫ���ƵĶȶ�Ӧ�ı����ڵ�����
    end
    rshift_in=rshift_out+1;
    vn_deg_num(rshift_out)=vn_deg_num(rshift_out)-1;
    vn_deg_num(rshift_in)=vn_deg_num(rshift_in)+1;
end

