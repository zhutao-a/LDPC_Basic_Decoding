clear;
clear all;

data=load('data.txt');
R=data(:,1);
bernoulli_source_soft_limit=data(:,3);
r=0.8;
EBN0= interp1(R,bernoulli_source_soft_limit,r);
disp(EBN0);
