clear;
clear all;
tic;
% code_table=[
% 0 0 0 0 0 0 0 
% 1 0 0 0 1 1 0 
% 0 0 1 0 1 1 1
% 1 1 1 1 1 1 1 
% 0 1 0 0 0 1 1 
% 1 0 0 1 0 1 1
% 1 0 1 0 0 0 1 
% 1 1 0 0 1 0 1
% 1 1 0 1 0 0 0 
% 1 1 1 0 0 1 0
% 0 1 1 0 1 0 0 
% 0 1 1 1 0 0 1
% 0 0 1 1 0 1 0 
% 1 0 1 1 1 0 0
% 0 0 0 1 1 0 1 
% 0 1 0 1 1 1 0
% ];
% syms x;
% f=1/sqrt(2*pi)*exp(-x^2/2);
% R=0.8;
% EBN0=-8;
% N0 = (1/R)*(1./exp(EBN0*(log(10)/10))); 
% sigma=sqrt(N0/2);
% w=100;
% disp(sigma);
% a=sqrt(2*w/N0);
% Q=double(int(f,x,a,inf));%求出最低的性能限
% disp(Q);
% 
% rrber=normcdf(0,1,sigma);
% disp(rrber);
% stop_num=1e7;
% rber=0;
% ber=0;
% for j=1:stop_num
%     msg=round(rand(1,4));%产生消息序列
%     for i=1:16%编码
%         temp=isequal(msg,code_table(i,1:4));
%         if(temp==1)
%             code=code_table(i,:);
%             break;
%         end
%     end
%     n_code=1-2*code+sigma*randn(size(code));%加噪
%     rber=rber+error_count(n_code,code);%计算rber
%     d=zeros(1,16);
%     for i=1:16%译码
%         for k=1:7
%             d(i)=d(i)+(n_code(k)-(1-2*code_table(i,k)))^2;
%         end
%     end
%     [~,I]=min(d);
%     d_code=code_table(I,:); 
%     ber=ber+sum(sum(mod(d_code+code,2)));%计算ber
% end
% rber=rber/(7*stop_num);
% ber=ber/(7*stop_num);
% 
% disp(rber);
% disp(ber);



% x=0:0.1:120;
% y=chi2pdf(x,5);
% plot(x,y);
% hold on;
% y2=chi2pdf(x,100);
% plot(x,y2);
% axis([0,120,0,0.2]);

n=100;
w=50;
R=(n-1)/n;
sigma=0.74;
rber = normcdf(0, 1, sigma);
P = 1-chi2cdf(2*w/(sigma^2),n);
N0=2*sigma^2;
EBN0=-10*log10(N0*R);
disp(rber);
disp(EBN0);
disp(P);

























% code=[
% 0 0 0 0
% 0 0 0 1
% 0 0 1 0
% 0 0 1 1
% 0 1 0 0
% 0 1 0 1
% 0 1 1 0
% 0 1 1 1
% 1 0 0 0
% 1 0 0 1
% 1 0 1 0
% 1 0 1 1
% 1 1 0 0
% 1 1 0 1
% 1 1 1 0
% 1 1 1 1
% ];
% d=zeros(16,16);
% for i=1:16
%     for j=1:16
%         d(i,j)=sum(mod(code(i,:)+code(j,:),2));
%     end
% end
% disp(d);
% 
% xlswrite('C:\Users\password_is_447\Desktop\d.xlsx',d);
% 
% xlswrite('C:\Users\password_is_447\Desktop\d_complementary.xlsx',4-d);










toc;