clear;
clear all;
tic;
%%
%protograph参数
global  M;              global  N;  
global  vn_deg_min;     global  vn_deg_max;
global  cn_deg_min;     global  cn_deg_max;  
global  vn_deg_full;    global  cn_deg_full;
global  punc_len;       global  E0;

M=17;                   N=128;      
vn_deg_min=3;           vn_deg_max=17;      
cn_deg_min=10;          cn_deg_max=30;
vn_deg_full=vn_deg_min:vn_deg_max;       
cn_deg_full=cn_deg_min:cn_deg_max;
punc_len=0;             E0=422;

rate=(N-M)/(N-punc_len);
%%
%GA求迭代阈值参数
global Pe;  global iter;    global sigma_min;   global sigma_max;
Pe = 1e-20;  iter = 50;       sigma_min=0.4;      sigma_max=0.7;
%%
global NP;
NP=10;
global mutate_num;
mutate_num=100;

[p_vn_deg_num,p_cn_deg_num]=initial_population();%产生NP个种群
[p_sigma,p_Pe]=population_fitness(p_vn_deg_num,p_cn_deg_num);%计算种群的适应度
[sigma_best,index]=max(p_sigma);
vn_deg_num_best=p_vn_deg_num(index,:);
cn_deg_num_best=p_cn_deg_num(index,:);
disp(sigma_best);
for i=1:200
    disp(i);
    for j=1:NP%突变迭代,更新整个种群
        [p_vn_deg_num(j,:),p_cn_deg_num(j,:),p_sigma(j),p_Pe(j)]=variant_iteration(p_vn_deg_num(j,:),p_cn_deg_num(j,:),p_sigma(j),p_Pe(j));
    end
    [sigma_best,index]=max(p_sigma);
    vn_deg_num_best=p_vn_deg_num(index,:);
    cn_deg_num_best=p_cn_deg_num(index,:);
    Pe_best=p_Pe(index);
    disp(sigma_best);
end
disp(sigma_best);
disp(Pe_best);
[vn_deg,vn_deg_prop,cn_deg,cn_deg_prop,punc_deg,punc_prop]=degree_distribution(vn_deg_num_best,cn_deg_num_best);
toc;








