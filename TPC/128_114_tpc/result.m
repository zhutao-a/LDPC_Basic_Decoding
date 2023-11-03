clear;
clear all;

EBN0=[2,2.25,2.5,2.75,3,3.1,3.15];
ber=[7e-2,6.4e-2,5e-2,2e-2,3.5e-4,1.2e-5,1.1e-7];
R=(113/128)^2;
N0 = (1/R)*(1./exp(EBN0*(log(10)/10))); 
sigma=sqrt(N0/2);
rber = normcdf(0, 1, sigma);
disp(rber);
semilogy(rber,ber,'-o','LineWidth',1.5,'MarkerSize',5);
hold on;
semilogy(0.04,1e-06,'rx','LineWidth',2.5,'MarkerSize',10);
set(gca,'XDir','reverse');
grid on;
grid minor;
xlabel('rber');
ylabel('ber');
legend('float,eBCH(128,113)^2');




