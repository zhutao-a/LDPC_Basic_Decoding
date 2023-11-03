clear;
clear all;

% syms x;
x=linspace(0,10,100);
phi=-log(tanh(x));

figure;
plot(x,phi);
% phi_inverse=finverse(y);
% disp(phi_inverse);

% a=linspace(0,10,100);
% b=atanh(exp(-a));
% 
% hold on;
% plot(a,b);