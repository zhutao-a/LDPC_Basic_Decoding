clear;
clear all;

EBN0=[3.4,3.5,3.6,3.75,3.8,3.85,3.9,3.95,4,4.02,4.04,4.06];
n_max=12;
R=111/128;
N0 = (1/R)*(1./exp(EBN0*(log(10)/10)));
sigma=sqrt(N0/2);
r_ber = normcdf(0, 1, sigma);
gf_table=gf_table_generate();
t=error_pattern_generate(6);
error_bit=zeros(1,n_max);
frame=zeros(1,n_max);%�˴�ָ32*128
error_frame=zeros(1,n_max);%�˴�ָ����1*128��С��֡����ÿ��msg��32֡
d_msg_ram_size=4;
stop_frame=50;

for n=1:n_max
    disp(n);
    msg_ram=zeros(128,128);
    data_ram1=ones(128,128);%��һ����������data_ram
    data_ram2=ones(128,128);%��һ����������data_ram
    data_ram3=ones(128,128);%��һ����������data_ram
    data_ram4=ones(128,128);%��һ����������data_ram
    d_msg_ram=zeros(d_msg_ram_size*128,128);
    while(error_frame(n)<stop_frame||frame(n)<5000)
        frame(n)=frame(n)+1;
        rng(frame(n));disp(frame(n));

        msg=round(rand(128,111));
        [d_msg,msg_ram]=encoder(msg,msg_ram);
        n_code=noise_code(d_msg,EBN0(n),frame(n));

        d_msg_out=d_msg_ram(1:128,:);
        d_msg_ram=circshift(d_msg_ram,-128);
        d_msg_ram(d_msg_ram_size*128-127:d_msg_ram_size*128,:)=d_msg;

        alpha=0.25;
        [decision_codeword1,data_out1,data_ram1]=decoder(data_ram1,n_code,alpha,gf_table,t);
        alpha=0.5;
        [decision_codeword2,data_out2,data_ram2]=decoder(data_ram2,data_out1,alpha,gf_table,t);
        alpha=0.75;
        [decision_codeword3,data_out3,data_ram3]=decoder(data_ram3,data_out2,alpha,gf_table,t);
        alpha=1;
        [~,data_out4,data_ram4]=decoder(data_ram4,data_out3,alpha,gf_table,t); 

        decision_codeword4=zeros(128,128);
        for i=1:128
            for j=1:128
                if(data_out4(i,j)>=0)
                    decision_codeword4(i,j)=0;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                else
                    decision_codeword4(i,j)=1;
                end
            end
        end
        for i=1:128
            temp=sum(mod(decision_codeword4(i,:)+d_msg_out(i,:),2));%���㲻ֵͬ�ĸ���
            if(temp~=0)
                error_frame(n)=error_frame(n)+1;
            end
            error_bit(n)=error_bit(n)+temp;
        end  
    end
end

ber=error_bit./(128*128*(frame-4));

disp(ber);






