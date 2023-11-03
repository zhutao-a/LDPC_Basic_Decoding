load('3.mat')
A = errorrate_ber;
B = errorrate_ber1;
load('4.mat')
C = [0.025626171875000,0.015335156250000,0.005385156250000,0.002019531250000,3.303906250000000e-04,6.218750000000000e-05]
figure;semilogy(r_ber,A,'-ro',r_ber,B,'--k+',r_ber,C,':bs',r_ber,r_ber,':ms');grid on;
legend('SCAN','BCH','SCAN增强2','UNCODED');
xlabel('RBER');
ylabel('BER');
grid on;