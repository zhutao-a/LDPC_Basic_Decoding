function d_code=mix_decoder(n_code,H,gf_table,t)
%n_code,d_code��СΪ256*2288
d_code=n_code;
%��һ��
for i=1:256
    d_code(i,:)=MS_decoder2(d_code(i,:),n_code(i,:),H,5);
end
alpha=0.25;
for i=1:2288
    [~,w]=r_decoder(d_code(:,i)',gf_table,t);
    W_R_r=n_code(:,i)'+alpha*w;%��������Ϣ
    d_code(:,i)=W_R_r';
end
%�ڶ���
for i=1:256
    d_code(i,:)=MS_decoder2(d_code(i,:),n_code(i,:),H,5);
end
alpha=0.5;
for i=1:2288
    [~,w]=r_decoder(d_code(:,i)',gf_table,t);
    W_R_r=n_code(:,i)'+alpha*w;%��������Ϣ
    d_code(:,i)=W_R_r';
end
%������
for i=1:256
    d_code(i,:)=MS_decoder2(d_code(i,:),n_code(i,:),H,5);
end
alpha=0.75;
for i=1:2288
    [~,w]=r_decoder(d_code(:,i)',gf_table,t);
    W_R_r=n_code(:,i)'+alpha*w;%��������Ϣ
    d_code(:,i)=W_R_r';
end
%���ļ�
for i=1:256
    d_code(i,:)=MS_decoder2(d_code(i,:),n_code(i,:),H,5);
end
alpha=1;
for i=1:2288
    [~,w]=r_decoder(d_code(:,i)',gf_table,t);
    W_R_r=n_code(:,i)'+alpha*w;%��������Ϣ
    d_code(:,i)=W_R_r';
end


















