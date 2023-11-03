clear;
clear all;
tic;

%BCH准备工作
gf_table=gf_table_generate();
t=error_pattern_generate(6);
%参数
n_max=8;
EBN0=[5.5,5.6,5.7,5.8,5.9,6.0,6.1,6.2,6.3];
R=(239/256);
N0 = (1/R).*(1./(exp(EBN0*log(10)./10))); 
sigma=sqrt(N0/2);
frame=50000;

ber_bit=zeros(1,n_max);
fer_frame=zeros(1,n_max);
rber_bit=zeros(1,n_max);

fid=fopen('bch_data.v','w');
fprintf(fid,'rber\t');
fprintf(fid,'ber\t\t\t');
fprintf(fid,'fer\r\n');
%开始编译码
for n=1:n_max
    disp(n);
    for i=1:frame
        disp(i);rng(i);
        msg=round(rand(1,239));
        %编码
        d_msg = lfsr_encoder(msg);
        n_code=noise_code(d_msg,sigma(n),i);%加噪
        %计算rber
        rber_num=count_error(n_code,d_msg);
        rber_bit(n)=rber_bit(n)+rber_num;
        %译码
        d_code=n_code;
        %第一级
        alpha=0.25;
        [~,w]=r_decoder(d_code,gf_table,t);
        d_code=n_code+alpha*w;%计算软信息
        %第二级
        alpha=0.5;
        [~,w]=r_decoder(d_code,gf_table,t);
        d_code=n_code+alpha*w;%计算软信息
        %第三级
        alpha=0.75;
        [~,w]=r_decoder(d_code,gf_table,t);
        d_code=n_code+alpha*w;%计算软信息
        %第四级
        alpha=1;
        [~,w]=r_decoder(d_code,gf_table,t);
        d_code=n_code+alpha*w;%计算软信息
        %计算ber与fer
        ber_num=count_error(d_code,d_msg);
        if(ber_num~=0)
            fer_frame(n)=fer_frame(n)+1;
        end
        ber_bit(n)=ber_bit(n)+ber_num;
    end
    fprintf(fid,'%.4f\t',rber_bit(n)/(frame*256));
    fprintf(fid,'%.4e\t',ber_bit(n)/(frame*256));
    fprintf(fid,'%.4e\n',fer_frame(n)/frame);
end

fclose(fid);

rber=rber_bit./(frame*256);
ber=ber_bit./(frame*256);
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






