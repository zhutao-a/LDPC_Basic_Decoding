load('3.mat')
A = errorrate_ber;
B = errorrate_ber1;
load('4.mat')
C = errorrate_ber1;
figure;semilogy(r_ber,A,'-ro',r_ber,B,'--k+',r_ber,C,':bs',r_ber,r_ber,'-ms');grid on;
legend('SCAN','BCH','SCAN增强1','UNCODED');
xlabel('RBER');
ylabel('BER');
grid on;