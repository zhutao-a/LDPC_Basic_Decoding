clear;
clear all;

load('LUT.mat');

n_max=20;

syms u f1 f2;
s=linspace(0,20,n_max);
t=zeros(1,n_max);
for i=1:n_max
    f1=log2(1+exp(-(2*sqrt(2*s(i))*u+2*s(i))))*exp(-u^2)/sqrt(pi);
    t(i)=double(int(f1,[-inf,+inf]));
end

R=zeros(1,n_max);
for i=1:n_max
    f2=log2(1+exp(-(2*sqrt(2*t(i))*u+2*t(i))))*exp(-u^2)/sqrt(pi);
    R(i)=1-double(int(f2,[-inf,+inf]));
end

disp(t);disp(R);




