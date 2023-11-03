clear;
clear all;
tic;
%%
%��ӡ�ļ�ͷ��ʾ��Ϣ
add_discription=1;
if(add_discription)
    fid=fopen('data.v','w');
    fprintf(fid,"note:��������8bit��alpha=[0.25��0.5��0.75��1]������4��ѡ���֣������ŵ���ʼ��Ϣ��ram�㹻��\r\n");
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
R=111/128;
sigma=linspace(0.5150,0.4750,12);%rber=normcdf(0,1,sigma);
G=2;
data_ram_max=127;%����ram��������ֵ
ram_max=3000;
code_ram_size=4;%���������������
gf_table=gf_table_generate();%������
t=error_pattern_generate(6);%����ͼ��
stop_num=5000;
msg_num=stop_num*ones(1,n_max);%�˴�ָ32*128��С�Ŀ�
fer_msg=zeros(1,n_max);%�������
rber_bit=zeros(1,n_max);%ͳ�Ƴ�ʼ���������
ber_bit=zeros(1,n_max);%�������������
%%
for n=1:n_max
    msg_ram=zeros((8*2+2*G)*16,128);
    data_ram1=data_ram_max*ones((8*2+2*G)*16,128);%��һ����������data_ram
    data_ram2=data_ram_max*ones((8*2+2*G)*16,128);%�ڶ�����������data_ram
    data_ram3=data_ram_max*ones((8*2+2*G)*16,128);%��������������data_ram
    data_ram4=data_ram_max*ones((8*2+2*G)*16,128);%���ĸ���������data_ram
    code_ram=zeros(code_ram_size*(8*2+2*G)*16,128);%��������������ʹ�������������������
    n_code_ram1=data_ram_max*ones((8*2+2*G)*16,128);%�����ŵ���ʼ��Ϣ
    n_code_ram2=data_ram_max*ones((8*2+2*G)*16,128);%�����ŵ���ʼ��Ϣ
    n_code_ram3=data_ram_max*ones((8*2+2*G)*16,128);%�����ŵ���ʼ��Ϣ
    n_code_ram4=data_ram_max*ones((8*2+2*G)*16,128);%�����ŵ���ʼ��Ϣ
    for i=1:stop_num
        rng(i);
        msg=round(rand(2*16,111));%������Ϣ����
        [code,msg_ram]=encoder(msg,msg_ram);%����  
        %����Ϊ�����������������ӳ�3*(8+G)������
        code_out=code_ram(1:32,:);
        code_ram=circshift(code_ram,-32);%ѭ�������ƶ�32λ
        code_ram(code_ram_size*(8*2+2*G)*16-31:code_ram_size*(8*2+2*G)*16,:)=code;
        %����
        n_code=noise_code(code,sigma(n),i);
        n_code=round(data_ram_max*n_code);%�Ŵ�
        n_code=max_constraint(n_code,data_ram_max);%�������ֵ
        %����rber
        rber_num=error_count(n_code,code);
        rber_bit(n)=rber_bit(n)+rber_num;
        %�ļ�����
        alpha=0.25;
        [~,data_out1,data_ram1,n_code_out1,n_code_ram1]=r_32_decoder(data_ram1,n_code,n_code_ram1,n_code,alpha,gf_table,t,ram_max);
        alpha=0.5;  
        [~,data_out2,data_ram2,n_code_out2,n_code_ram2]=r_32_decoder(data_ram2,data_out1,n_code_ram2,n_code_out1,alpha,gf_table,t,ram_max);
        alpha=0.75;
        [~,data_out3,data_ram3,n_code_out3,n_code_ram3]=r_32_decoder(data_ram3,data_out2,n_code_ram3,n_code_out2,alpha,gf_table,t,ram_max);
        alpha=1; 
        [~,data_out4,data_ram4,n_code_out4,n_code_ram4]=r_32_decoder(data_ram4,data_out3,n_code_ram4,n_code_out3,alpha,gf_table,t,ram_max);%decision_codeword4��data_out4������
        %���Կ���d_msgҪ����d_msg_ram_size*(8+G)�����ں������decision_codeword���
        %����ber��fer
        ber_num=error_count(data_out4,code_out);
        if(ber_num~=0)
            fer_msg(n)=fer_msg(n)+1;
        end
        ber_bit(n)=ber_bit(n)+ber_num; 
    end
    fid=fopen('ofec_data.v','a');
    fprintf(fid,'%.4f\t\t',sigma(n));
    fprintf(fid,'%d\t\t',msg_num(n));
    fprintf(fid,'%d\t\t',fer_msg(n));
    fprintf(fid,'%.4f\t\t',rber_bit(n)/(msg_num(n)*32*128));
    fprintf(fid,'%.4e\t\t',ber_bit(n)/(msg_num(n)*32*128));
    fprintf(fid,'%.4e\r\n',fer_msg(n)/msg_num(n));
    fclose(fid);
end
%%
rber=rber_bit./(msg_num*32*128);
ber=ber_bit./(msg_num*32*128);
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


