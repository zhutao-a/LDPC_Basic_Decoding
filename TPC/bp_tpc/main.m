clear;
clear all;
tic;

H=system_H_gen();

a=sum(H,2);
b=sum(H,1);


toc;