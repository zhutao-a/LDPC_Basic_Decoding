clear;
clear all;
tic;
% syms x;
% nmax=40;
% C=zeros(1,nmax);
% EBNO=zeros(1,nmax);
% for i=1:nmax
%     sigma=0.5+1.1^(i-1)-1;
%     u=1;
%     p=1/2*1/(sqrt(2*pi)*sigma)*(exp(-(x-u).^2/(2*sigma^2))+exp(-(x+u).^2/(2*sigma^2)));
%     y=-p.*log2(p);
%     C(i) =double(int(y,x,-inf,inf))-1/2*log2(2*pi*exp(1)*sigma^2);
%     EBNO(i)=10*log10(1/(C(i)*2*sigma^2));
% end
% 
% plot(EBNO,C);
% grid on;
% axis([-2,10,0,1]);
% syms x;
% f=1/sqrt(2*pi)*exp(-x^2/2);
% w=12;R=0.867;EBN0=0.5;
% a=sqrt(2*w*R*EBN0);
% disp(a);
% Q=double(int(f,x,a,inf));
% disp(Q);
% C=0:0.1:1;
% ebn0=1./(2*C).*(2.^(2*C)-1);
% EBN0=10*log10(ebn0);
% plot(EBN0,C);
% hold on;
% ebn1=1./(4*(1-C).*C);
% EBN1=10*log10(ebn1);
% plot(EBN1,C);
% 
% c=0.8;
% ebn1=1./(4*(1-c).*c);
% EBN1=10*log10(ebn1);
% disp(EBN1);
Z=3;
circ_mat_array = {};
for i = 0 : Z - 1
    circ_mat = zeros(Z,Z);
    for j = 0 : Z - 1
        circ_mat(j + 1, mod(j + i, Z) + 1) = 1;
    end
    circ_mat_array{i + 1} = circ_mat;
end
disp(cell2mat(circ_mat_array(1,3)));

toc;





