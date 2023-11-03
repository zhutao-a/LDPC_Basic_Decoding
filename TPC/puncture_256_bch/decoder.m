function dcode=decoder(n_code,gf_table,t,data_ram_max)
dcode=n_code;
%��һ��
alpha=0.25;
%������
for i=1:256
    r=dcode(i,:);
    [~,w]=r_decoder(r,gf_table,t);
    dcode(i,:)=n_code(i,:)+fix(alpha*w);
end
dcode=max_constraint(dcode,2*data_ram_max);%�������ֵ
dcode=put_max(dcode,data_ram_max,2);
%������
for i=1:256
    r=dcode(:,i);
    [~,w]=r_decoder(r,gf_table,t);
    dcode(:,i)=n_code(:,i)+fix(alpha*w');
end
dcode=max_constraint(dcode,2*data_ram_max);%�������ֵ
dcode=put_max(dcode,data_ram_max,2);
%�ڶ���
alpha=0.5;
%������
for i=1:256
    r=dcode(i,:);
    [~,w]=r_decoder(r,gf_table,t);
    dcode(i,:)=n_code(i,:)+fix(alpha*w);
end
dcode=max_constraint(dcode,2*data_ram_max);%�������ֵ
dcode=put_max(dcode,data_ram_max,2);
%������
for i=1:256
    r=dcode(:,i);
    [~,w]=r_decoder(r,gf_table,t);
    dcode(:,i)=n_code(:,i)+fix(alpha*w');
end
dcode=max_constraint(dcode,2*data_ram_max);%�������ֵ
dcode=put_max(dcode,data_ram_max,2);
%������
alpha=0.75;
%������
for i=1:256
    r=dcode(i,:);
    [~,w]=r_decoder(r,gf_table,t);
    dcode(i,:)=n_code(i,:)+fix(alpha*w);
end
dcode=max_constraint(dcode,4*data_ram_max);%�������ֵ
dcode=put_max(dcode,data_ram_max,4);
%������
for i=1:256
    r=dcode(:,i);
    [~,w]=r_decoder(r,gf_table,t);
    dcode(:,i)=n_code(:,i)+fix(alpha*w');
end
dcode=max_constraint(dcode,4*data_ram_max);%�������ֵ
dcode=put_max(dcode,data_ram_max,4);
%���ļ�
alpha=1;
%������
for i=1:256
    r=dcode(i,:);
    [~,w]=r_decoder(r,gf_table,t);
    dcode(i,:)=n_code(i,:)+fix(alpha*w);
end
dcode=max_constraint(dcode,4*data_ram_max);%�������ֵ
dcode=put_max(dcode,data_ram_max,4);
%������
for i=1:256
    r=dcode(:,i);
    [~,w]=r_decoder(r,gf_table,t);
    dcode(:,i)=n_code(:,i)+fix(alpha*w');
end
dcode=max_constraint(dcode,4*data_ram_max);%�������ֵ
dcode=put_max(dcode,data_ram_max,4);

