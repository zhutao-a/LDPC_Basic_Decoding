clear;
clear all;
tic;
%%
%打印文件头提示信息
add_discription=1;
if(add_discription)
    fid=fopen('data.v','w');
    fprintf(fid,"note:数据类型8bit，alpha=[0.25，0.5，0.75，1]，保留4候选码字，保留信道初始信息，ram足够大\r\n");
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
data_ram_max=127;%存在ram里面的最大值
ram_max=3000;
code_ram_size=4;%用于输入输出对齐
gf_table=gf_table_generate();%有限域
t=error_pattern_generate(6);%错误图样
stop_num=5000;
msg_num=stop_num*ones(1,n_max);%此处指32*128大小的块
fer_msg=zeros(1,n_max);%错误块数
rber_bit=zeros(1,n_max);%统计初始错误比特数
ber_bit=zeros(1,n_max);%译码后错误比特数
%%
for n=1:n_max
    msg_ram=zeros((8*2+2*G)*16,128);
    data_ram1=data_ram_max*ones((8*2+2*G)*16,128);%第一个译码器的data_ram
    data_ram2=data_ram_max*ones((8*2+2*G)*16,128);%第二个译码器的data_ram
    data_ram3=data_ram_max*ones((8*2+2*G)*16,128);%第三个译码器的data_ram
    data_ram4=data_ram_max*ones((8*2+2*G)*16,128);%第四个译码器的data_ram
    code_ram=zeros(code_ram_size*(8*2+2*G)*16,128);%用来缓存输入以使得输入与译码输出对齐
    n_code_ram1=data_ram_max*ones((8*2+2*G)*16,128);%保留信道初始信息
    n_code_ram2=data_ram_max*ones((8*2+2*G)*16,128);%保留信道初始信息
    n_code_ram3=data_ram_max*ones((8*2+2*G)*16,128);%保留信道初始信息
    n_code_ram4=data_ram_max*ones((8*2+2*G)*16,128);%保留信道初始信息
    for i=1:stop_num
        rng(i);
        msg=round(rand(2*16,111));%产生消息序列
        [code,msg_ram]=encoder(msg,msg_ram);%编码  
        %单纯为了与输出对齐而进行延迟3*(8+G)个步骤
        code_out=code_ram(1:32,:);
        code_ram=circshift(code_ram,-32);%循环向上移动32位
        code_ram(code_ram_size*(8*2+2*G)*16-31:code_ram_size*(8*2+2*G)*16,:)=code;
        %加噪
        n_code=noise_code(code,sigma(n),i);
        n_code=round(data_ram_max*n_code);%放大
        n_code=max_constraint(n_code,data_ram_max);%限制最大值
        %计算rber
        rber_num=error_count(n_code,code);
        rber_bit(n)=rber_bit(n)+rber_num;
        %四级译码
        alpha=0.25;
        [~,data_out1,data_ram1,n_code_out1,n_code_ram1]=r_32_decoder(data_ram1,n_code,n_code_ram1,n_code,alpha,gf_table,t,ram_max);
        alpha=0.5;  
        [~,data_out2,data_ram2,n_code_out2,n_code_ram2]=r_32_decoder(data_ram2,data_out1,n_code_ram2,n_code_out1,alpha,gf_table,t,ram_max);
        alpha=0.75;
        [~,data_out3,data_ram3,n_code_out3,n_code_ram3]=r_32_decoder(data_ram3,data_out2,n_code_ram3,n_code_out2,alpha,gf_table,t,ram_max);
        alpha=1; 
        [~,data_out4,data_ram4,n_code_out4,n_code_ram4]=r_32_decoder(data_ram4,data_out3,n_code_ram4,n_code_out3,alpha,gf_table,t,ram_max);%decision_codeword4，data_out4均正序
        %可以看出d_msg要经过d_msg_ram_size*(8+G)个周期后才能在decision_codeword输出
        %计算ber与fer
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
%显示数据
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


