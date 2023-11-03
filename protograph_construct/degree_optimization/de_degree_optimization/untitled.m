clear;
clear all;

load('result.mat');

plot(E,sigma);
grid on;
grid minor;
xlabel('E');
ylabel('sigma');