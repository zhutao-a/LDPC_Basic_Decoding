clear;
clear all;

iter=[250,150,100,50,40,30,20,10];
a= [1.3712,1.3812,1.4012,1.4812,1.5312,1.6412,1.8912,2.7812];
pa=[1.3009,1.3109,1.3309,1.4309,1.4909,1.6209,1.9309,3.0009];
b= [2.3646,2.3646,2.3646,2.3946,2.4246,2.4646,2.5746,3.0546];
pb=[2.2891,2.2891,2.2991,2.3491,2.3891,2.4491,2.6191,3.2591];


plot(iter,a,'-ro','LineWidth',1.5,'MarkerSize',5);
hold on;
grid on;
grid minor;
plot(iter,pa,'-.ro','LineWidth',1.5,'MarkerSize',5);
plot(iter,b,'-bo','LineWidth',1.5,'MarkerSize',5);
plot(iter,pb,'-.bo','LineWidth',1.5,'MarkerSize',5);

xlabel('迭代次数iter');
ylabel('迭代阈值EBN0');
legend('参考矩阵：不puncture','参考矩阵：puncture','华为矩阵：不puncture','华为矩阵：puncture');
title('RCA');

