load('3.mat')
figure;semilogy(r_ber,errorrate_ber,'-ro',r_ber,errorrate_ber1,'--k+',r_ber,errorrate_ber2,':bs');grid on;
legend('SCAN','BCH','SCANL');
xlabel('RBER');
ylabel('BER');
grid on;

