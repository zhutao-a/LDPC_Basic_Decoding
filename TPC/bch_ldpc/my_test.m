clear;
clear all;
tic;
%LDPC准备工作
block_size=52;
base_matrix=load('base_matrix.txt');
[M,N]=size(base_matrix);%行数M，列数N
H1_mat = base_matrix(:,1:N-M);%base_matrix的前K=N-M列
H2_mat = base_matrix(:,N-M+1:N);%base_matrix的后M列
H1= h_full_generate(H1_mat, block_size);%将base_matrix展开全，变为0，1矩阵
H2= h_full_generate(H2_mat, block_size);%将base_matrix展开全，变为0，1矩阵
[~ ,H2_T_inv] = func_inv2 (H2') ;%高斯消元求逆，二进制表示

%BCH准备工作
gf_table=gf_table_generate();
t=error_pattern_generate(6);

%参数
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
%开始编译码
for n=1:n_max
    disp(n);
    for i=1:frame
        disp(i);rng(i);
        msg=round(rand(239,(N-M)*block_size));
        %编码
        d_msg=mix_encoder(msg,H1,H2_T_inv);
        n_code=noise_code(d_msg,sigma(n),i);%加噪
        %计算rber
        rber_num=count_error(n_code,d_msg);
        rber_bit(n)=rber_bit(n)+rber_num;
        %译码
        d_code=mix_decoder(n_code,[H1,H2],gf_table,t);
        %计算ber与fer
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

fprintf('码率:\t%.4f\r\n',R);

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




