clear;
clear all;
tic;
%LDPC׼������
block_size=52;
base_matrix=load('base_matrix.txt');
[M,N]=size(base_matrix);%����M������N
H1_mat = base_matrix(:,1:N-M);%base_matrix��ǰK=N-M��
H2_mat = base_matrix(:,N-M+1:N);%base_matrix�ĺ�M��
H1= h_full_generate(H1_mat, block_size);%��base_matrixչ��ȫ����Ϊ0��1����
H2= h_full_generate(H2_mat, block_size);%��base_matrixչ��ȫ����Ϊ0��1����
[~ ,H2_T_inv] = func_inv2 (H2') ;%��˹��Ԫ���棬�����Ʊ�ʾ

%BCH׼������
gf_table=gf_table_generate();
t=error_pattern_generate(6);

%����
n_max=8;
EBN0=[3.5,3.6,3.7,3.8,3.9,4,4.1,4.2];
R=(239/256)*((N-M)/N);
N0 = (1/R).*(1./(exp(EBN0*log(10)./10))); 
sigma=sqrt(N0/2);% r_ber = normcdf(0, 1, sigma);
frame=100;

ber_bit=zeros(1,n_max);
fer_frame=zeros(1,n_max);
rber_bit=zeros(1,n_max);

fid=fopen('tpc_data.v','w');
fprintf(fid,'rber\t');
fprintf(fid,'ber\t\t\t');
fprintf(fid,'fer\r\n');
%��ʼ������
for n=1:n_max
    disp(n);
    for i=1:frame
        disp(i);rng(i);
        msg=round(rand(239,(N-M)*block_size));
        %����
        d_msg=mix_encoder(msg,H1,H2_T_inv);
        n_code=noise_code(d_msg,sigma(n),i);%����
        %����rber
        rber_num=count_error(n_code,d_msg);
        rber_bit(n)=rber_bit(n)+rber_num;
        %����
        d_code=mix_decoder(n_code,[H1,H2],gf_table,t);
        %����ber��fer
        ber_num=count_error(d_code,d_msg);
        if(ber_num~=0)
            fer_frame(n)=fer_frame(n)+1;
        end
        ber_bit(n)=ber_bit(n)+ber_num;
    end
    fprintf(fid,'%.4f\t',rber_bit(n)/(frame*256*2288));
    fprintf(fid,'%.4e\t',ber_bit(n)/(frame*256*2288));
    fprintf(fid,'%.4e\n',fer_frame(n)/frame);
end

fclose(fid);

rber=rber_bit./(frame*256*2288);
ber=ber_bit./(frame*256*2288);
fer=fer_frame./frame;

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




