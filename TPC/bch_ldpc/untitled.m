clear;
clear all;


% EBN0=2.5;
% R=0.8;
% N0 = (1/R).*(1./(exp(EBN0*log(10)./10))); 
% sigma=sqrt(N0/2);% r_ber = normcdf(0, 1, sigma);
% r_ber = normcdf(0, 1, sigma);
% disp(r_ber);
a=1;k=128;
for i=1:17
    a=a*k*(1-0.045)^6;
    k=k-1;
    a=a/i;
end
a=a*(1-0.045)^9*0.045^17;
disp(a);
