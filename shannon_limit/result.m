clear;
clear all;

data=load('data.txt');


R=data(:,1);
gauss_source_limit=data(:,2);
bernoulli_source_soft_limit=data(:,3);
bernoulli_source_hard_limit=data(:,4);

plot(gauss_source_limit,R,'r.-','LineWidth',1.5,'MarkerSize',13);
grid on;
grid minor;
hold on;
plot(bernoulli_source_soft_limit,R,'b.-','LineWidth',1.5,'MarkerSize',13);
hold on;
plot(bernoulli_source_hard_limit,R,'g.-','LineWidth',1.5,'MarkerSize',13);
xlabel('Eb/N0 (dB)');
ylabel('Capacity (bits/channel symbol)');
legend('Shannon','soft','hard');


