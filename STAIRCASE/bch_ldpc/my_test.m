clear;
clear all;
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
EBN0=5;
R=0.79723;
N0 = (1/R)*(1/(exp(EBN0*log(10)/10))); 
frame=300;
msg_ram=zeros(128,2288);
data_ram1=ones(128,2288);
data_ram2=ones(128,2288);

d_msg_ram_size=2;
d_msg_ram=zeros(d_msg_ram_size*128,2288);
for i=1:frame
    rng(i);disp(i);
    bch_c=round(rand(111,1144));
    ldpc_c=round(rand(128,832));
    %����
    [ecode,msg_ram]=mix_encoder(msg_ram,ldpc_c,H1,H2_T_inv,bch_c);
    %��ʱ�����ͬ��
    d_msg_out=d_msg_ram(1:128,:);
    d_msg_ram=circshift(d_msg_ram,-128);
    d_msg_ram(d_msg_ram_size*128-127:d_msg_ram_size*128,:)=ecode;
    %����
    n_code=noise_code(ecode,R,EBN0,frame);
    %����
    alpha=0.25;
    [data_out1,data_ram1]=mix_decoder(data_ram1,n_code,N0,H1,H2,alpha,gf_table,t);
    [data_out2,data_ram2]=mix_decoder(data_ram2,data_out1,N0,H1,H2,alpha,gf_table,t);
    %Ӳ�о�
    b=zeros(128,2288);
    for m=1:128
        for n=1:2288
            if(data_out2(m,n)>0)
                b(m,n)=0;
            else
                b(m,n)=1;
            end
        end
    end
    if(i==3)
        error_bit=sum(sum(mod(b+d_msg_out,2)));
        disp(error_bit);
        disp(1);   
    end    
    
    
end




% %���б���
% rng(1);
% u_data=round(rand(1,(N-M)*block_size));
% c_data = encoder_ldpc(u_data,H1,H2_T_inv);
% 
% frame=1;
% EBN0=3;
% R=38/44;
% n_code=noise_code(c_data,R,EBN0,frame);
% N0 = (1/R)*(1/(exp(EBN0*log(10)/10))); 
% sigma=sqrt(N0/2);
% r_ber = normcdf(0, 1, sigma);
% 
% b1=zeros(1,N*block_size);
% for i=1:N*block_size
%     if(n_code(i)>0)
%         b1(i)=0;
%     else
%         b1(i)=1;
%     end
% end
% error_bit=0;
% for i=1:N*block_size
%     if(b1(i)~=c_data(i))
%         error_bit=error_bit+1;%disp(i);disp(Lci(i));
%     end
% end
% 
% 
% 
% 
% ro= MS_decoder1(n_code,N0, [H1,H2]);
% disp(n_code(1:5));
% disp(ro(1:5));
% b2=zeros(1,N*block_size);
% for i=1:N*block_size
%     if(ro(i)>0)
%         b2(i)=0;
%     else
%         b2(i)=1;
%     end
% end
% error_bit=sum(mod(b2+c_data,2));
% disp(error_bit);

