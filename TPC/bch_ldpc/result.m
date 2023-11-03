clear;
clear all;
%单个bch性能
rber_bch=[0.0063,0.0058,0.0053,0.0049,0.0044,0.0040,0.0037,0.0033];
ber_bch=[4.1930e-04,2.8609e-04,1.8406e-04,1.1008e-04,6.8984e-05,3.8594e-05,2.0625e-05,1.1719e-05];
%单个ldpc性能
rber_ldpc=[0.0203,0.0192,0.0181,0.0170,0.0160,0.0150,0.0141,0.0132];
ber_ldpc=[3.6276e-03,1.8032e-03,7.9847e-04,2.8615e-04,1.0533e-04,1.9930e-05,7.0367e-06,1.3112e-07];


semilogy(rber_bch,ber_bch,'-o','LineWidth',1.5,'MarkerSize',5);
hold on;
semilogy(rber_ldpc,ber_ldpc,'-o','LineWidth',1.5,'MarkerSize',5);
grid on;
grid minor;
% axis([0.0130,0.0205,1e-07,4e-03]);
xlabel('rber');
ylabel('ber');
set(gca,'XDir','reverse');
legend('eBCH(256,239)','LDPC(44*52=2288,38*52=1976)');

