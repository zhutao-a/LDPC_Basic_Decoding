function cn_deg_num=cn_deg_num_mutate(cn_deg_num,max_mutate_times)
global  cn_deg_min;     global  cn_deg_max;  
mutate_times=randi(max_mutate_times);%���������
for i=1:mutate_times
    %���ڱ�����1
    nozero_index=find(cn_deg_num~=0);%�ҵ�cn_deg_num�в�Ϊ0������
    r1=randi(length(nozero_index));
    lshift_out=nozero_index(r1);%��Ҫ���ƵĶȶ�Ӧ��У��ڵ�����
    while((lshift_out+cn_deg_min-1)==cn_deg_min)%����ȡ��С��
        r1=randi(length(nozero_index));
        lshift_out=nozero_index(r1);%��Ҫ���ƵĶȶ�Ӧ��У��ڵ�����
    end
    lshift_in=lshift_out-1;
    cn_deg_num(lshift_out)=cn_deg_num(lshift_out)-1;
    cn_deg_num(lshift_in)=cn_deg_num(lshift_in)+1;
    %���ڱ߼���1
    nozero_index=find(cn_deg_num~=0);%�ҵ�cn_deg_num�в�Ϊ0������
    r2=randi(length(nozero_index));
    rshift_out=nozero_index(r2);%��Ҫ���ƵĶȶ�Ӧ��У��ڵ�����
    while((rshift_out+cn_deg_min-1)==cn_deg_max)
        r2=randi(length(nozero_index));
        rshift_out=nozero_index(r2);%��Ҫ���ƵĶȶ�Ӧ�ı����ڵ�����
    end
    rshift_in=rshift_out+1;
    cn_deg_num(rshift_out)=cn_deg_num(rshift_out)-1;
    cn_deg_num(rshift_in)=cn_deg_num(rshift_in)+1;
end

