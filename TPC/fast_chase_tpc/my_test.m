% clear;
% clear all;
% EBN0=[3.5,3.6,3.7,3.8,3.9,4,4.1,4.2];
% R=(239/256)^2;
% N0 = (1/R).*(1./(exp((log(10)/10)).*EBN0)); 
% sigma=sqrt(N0/2);
% r_ber = normcdf(0, 1, sigma);
% BER=zeros(1,8);
% frame=1000;
% for n=1:8
%     disp(n);
%     error_bit=0;
%     for k=1:frame
%         disp(k);
%         msg=round(rand(239));
%         ecode=lfsr_encoder(msg);%ÕÍ≥…±‡¬Î
%         n_code=noise_code(ecode,EBN0(n));%ÃÌº”‘Î…˘
%         de_code=tpc_decoder(n_code);%“Î¬Î∆˜
%         for i=1:256
%             for j=1:256
%                 if de_code(i,j)~=ecode(i,j)
%                     error_bit=error_bit+1;
%                 end
%             end
%         end
%     end
%     BER(n)=error_bit/(256*256*frame);
% end
% disp(r_ber);
% disp(BER);
% save r_ber;
% save BER;
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
