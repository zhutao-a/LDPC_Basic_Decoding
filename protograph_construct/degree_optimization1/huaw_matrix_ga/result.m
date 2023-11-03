clear;
clear all;
iter=[250,150,100,50,40,30,20,10];
a= [2.3905,2.3933,2.3991,2.4321,2.4566,2.5101,2.6608,3.3855];
b= [2.3646,2.3646,2.3646,2.3946,2.4246,2.4646,2.5746,3.0546];
plot(iter,a,'-ro','LineWidth',1.5,'MarkerSize',5);
hold on;
grid on;
grid minor;
plot(iter,b,'-bo','LineWidth',1.5,'MarkerSize',5);
xlabel('迭代次数iter');
ylabel('迭代阈值EBN0');
legend('华为矩阵：不puncture-GA','华为矩阵：不puncture-RCA');

title('GA-RCA');



