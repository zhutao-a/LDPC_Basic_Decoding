clear;
clear all;
tic;
%%
filename='main';
%����protograph����Ϊ�ľ���368��80����puncture��8��
H=load('base_matrix.txt');
H(H>=0)=1;
H(H==-1)=0;%��������-1��Ϊ0�����Ϊ1
%%
%����Ļ�������
[C,V] = size(H);
deg_per_col=sum(H,1);
deg_per_row=sum(H,2)';
punc_idx=[42,88,134,180,226,272,318,364];
punc_len=length(punc_idx);%Number of Punctured Nodes 
rate=(V-C)/(V-punc_len); %Rate of code only for EB_No_result
%%
sigma_min=0.3;
sigma_max=0.8;
iter=8;
Pe=1e-6;
[sigma_out,final_Pe]=GA_th_punc(sigma_min,sigma_max,iter,Pe,deg_per_col,deg_per_row,punc_idx);

ebn0=1/(2*rate*sigma_out.^2);%������ת��Ϊ�����EBN0

EBN0=10*log10(ebn0);
N0 = (1/rate)*(1./exp(EBN0*(log(10)/10))); 
sigma=sqrt(N0/2);
r_ber = normcdf(0, 1, sigma);
disp(r_ber);


toc;






