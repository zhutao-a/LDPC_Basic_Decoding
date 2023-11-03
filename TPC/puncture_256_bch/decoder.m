function dcode=decoder(n_code,gf_table,t,data_ram_max)
dcode=n_code;
%第一级
alpha=0.25;
%行译码
for i=1:256
    r=dcode(i,:);
    [~,w]=r_decoder(r,gf_table,t);
    dcode(i,:)=n_code(i,:)+fix(alpha*w);
end
dcode=max_constraint(dcode,2*data_ram_max);%限制最大值
dcode=put_max(dcode,data_ram_max,2);
%列译码
for i=1:256
    r=dcode(:,i);
    [~,w]=r_decoder(r,gf_table,t);
    dcode(:,i)=n_code(:,i)+fix(alpha*w');
end
dcode=max_constraint(dcode,2*data_ram_max);%限制最大值
dcode=put_max(dcode,data_ram_max,2);
%第二级
alpha=0.5;
%行译码
for i=1:256
    r=dcode(i,:);
    [~,w]=r_decoder(r,gf_table,t);
    dcode(i,:)=n_code(i,:)+fix(alpha*w);
end
dcode=max_constraint(dcode,2*data_ram_max);%限制最大值
dcode=put_max(dcode,data_ram_max,2);
%列译码
for i=1:256
    r=dcode(:,i);
    [~,w]=r_decoder(r,gf_table,t);
    dcode(:,i)=n_code(:,i)+fix(alpha*w');
end
dcode=max_constraint(dcode,2*data_ram_max);%限制最大值
dcode=put_max(dcode,data_ram_max,2);
%第三级
alpha=0.75;
%行译码
for i=1:256
    r=dcode(i,:);
    [~,w]=r_decoder(r,gf_table,t);
    dcode(i,:)=n_code(i,:)+fix(alpha*w);
end
dcode=max_constraint(dcode,4*data_ram_max);%限制最大值
dcode=put_max(dcode,data_ram_max,4);
%列译码
for i=1:256
    r=dcode(:,i);
    [~,w]=r_decoder(r,gf_table,t);
    dcode(:,i)=n_code(:,i)+fix(alpha*w');
end
dcode=max_constraint(dcode,4*data_ram_max);%限制最大值
dcode=put_max(dcode,data_ram_max,4);
%第四级
alpha=1;
%行译码
for i=1:256
    r=dcode(i,:);
    [~,w]=r_decoder(r,gf_table,t);
    dcode(i,:)=n_code(i,:)+fix(alpha*w);
end
dcode=max_constraint(dcode,4*data_ram_max);%限制最大值
dcode=put_max(dcode,data_ram_max,4);
%列译码
for i=1:256
    r=dcode(:,i);
    [~,w]=r_decoder(r,gf_table,t);
    dcode(:,i)=n_code(:,i)+fix(alpha*w');
end
dcode=max_constraint(dcode,4*data_ram_max);%限制最大值
dcode=put_max(dcode,data_ram_max,4);

