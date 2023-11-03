clear;
clear all;
EBN0=4;
n_max=1;
R=(113/128)^2;
N0 = (1/R)*(1./exp(EBN0*(log(10)/10))); 
sigma=sqrt(N0/2);
r_ber = normcdf(0, 1, sigma);
disp(r_ber);
b=zeros(128,128);
BER=zeros(1,n_max);
rr_ber=zeros(1,n_max);
frame=10;
for n=1:n_max
    disp(n);
    error_bit=0;
    rr_error_bit=0;
    for k=1:frame
        disp(k);
        rng(k);
        msg=round(rand(113));
        ecode=lfsr_encoder(msg);%完成编码
        n_code=noise_code(ecode,EBN0(n),k);%添加噪声
%         %用来求rr_ber
%         for i=1:128
%             for j=1:128
%                 if(n_code(i,j)>0)
%                     b(i,j)=1;
%                 else
%                     b(i,j)=0;
%                 end
%             end
%         end
%         [~,cnumerr,decoded] = bchdec(gf(b(1,1:127)),127,113);
%         for i=1:128
%             for j=1:128
%                 if b(i,j)~=ecode(i,j)
%                     rr_error_bit=rr_error_bit+1;
%                 end
%             end
%         end 
        %解码
        de_code=tpc_decoder(n_code);%译码器
        for i=1:128
            for j=1:128
                if de_code(i,j)~=ecode(i,j)
                    error_bit=error_bit+1;
                end
            end
        end
    end
    BER(n)=error_bit/(128*128*frame);
%     rr_ber(n)=rr_error_bit/(128*128*frame);
end
disp(r_ber);
disp(BER);










