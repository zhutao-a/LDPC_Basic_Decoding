clear;
clear all;
tic;
%%
%��ӡ�ļ�ͷ��ʾ��Ϣ
add_discription=0;
if(add_discription)
    fid=fopen('data.v','w');
    fprintf(fid,"note:��������8bit��alpha=[0.25��0.5��0.75��1]������4��ѡ���֣������ŵ���ʼ��Ϣ��[2ram,2ram,2ram,2ram,4ram,4ram,4ram,4ram]\r\n");
    fprintf(fid,'sigma\t\t');
    fprintf(fid,'msg_num\t\t');
    fprintf(fid,'fer_msg\t\t');
    fprintf(fid,'rber\t\t');
    fprintf(fid,'ber\t\t');
    fprintf(fid,'fer\r\n');
    fclose(fid);
end
%%
n_max=12;
R=0.800185;
sigma=linspace(0.5850,0.5468,12);%rber=normcdf(0,1,sigma);
data_ram_max=127;%����ram��������ֵ
gf_table=gf_table_generate();%������
t=error_pattern_generate(6);%����ͼ��
stop_num=2000;
msg_num=stop_num*ones(1,n_max);%�˴�ָ32*128��С�Ŀ�
fer_msg=zeros(1,n_max);%�������
rber_bit=zeros(1,n_max);%ͳ�Ƴ�ʼ���������
ber_bit=zeros(1,n_max);%�������������
%%
parfor n=1:n_max
    for i=1:stop_num
        rng(i);
        msg=round(rand(239,239));%������Ϣ����
        msg=put_zeros(msg);
        code=encoder(msg);
        n_code=noise_code(code,sigma(n),i);
        n_code=round(data_ram_max*n_code);%�Ŵ�
        n_code=max_constraint(n_code,data_ram_max);%�������ֵ
        n_code=put_max(n_code,data_ram_max,1);
        %����rber
        rber_num=error_count(n_code,code);
        rber_bit(n)=rber_bit(n)+rber_num;
        %����
        dcode=decoder(n_code,gf_table,t,data_ram_max);
        %����ber��fer
        ber_num=error_count(dcode,code);
        if(ber_num~=0)
            fer_msg(n)=fer_msg(n)+1;
        end
        ber_bit(n)=ber_bit(n)+ber_num; 
    end
    fid=fopen('data.v','a');
    fprintf(fid,'%.4f\t\t',sigma(n));
    fprintf(fid,'%d\t\t',msg_num(n));
    fprintf(fid,'%d\t\t',fer_msg(n));
    fprintf(fid,'%.4f\t\t',rber_bit(n)/(msg_num(n)*239*(239-98)));
    fprintf(fid,'%.4e\t\t',ber_bit(n)/(msg_num(n)*239*(239-98)));
    fprintf(fid,'%.4e\r\n',fer_msg(n)/msg_num(n));
    fclose(fid);
end
%%
rber=rber_bit./(msg_num*239*(239-98));
ber=ber_bit./(msg_num*239*(239-98));
fer=fer_msg./msg_num;
%��ʾ����
fprintf('����:\t%.4f\r\n',R);

fprintf('rber:\t');
for i=1:n_max
    fprintf('%.4f\t\t',rber(i));
end
fprintf('\r\n');

fprintf('ber:\t');
for i=1:n_max
    fprintf('%.4e\t',ber(i));
end
fprintf('\r\n');

fprintf('fer:\t');
for i=1:n_max
    fprintf('%.4e\t',fer(i));
end
fprintf('\r\n');

toc;


