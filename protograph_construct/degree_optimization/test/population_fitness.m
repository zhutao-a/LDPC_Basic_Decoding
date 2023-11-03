function [pop_sigma,pop_Pe]=population_fitness(pop_vn_deg_num,pop_cn_deg_num)%计算种群的适应度
%%
%全局参数
global NP;
global Pe;  
global iter;   
global sigma_min;   
global sigma_max;
%%
%通过度分布求出迭代阈值和错误概率
pop_sigma=zeros(NP,1);
pop_Pe=zeros(NP,1);
for i=1:NP
    %通过每行每列的度计算出度分布,同时给出puncture掉的度以及比例
    [vn_deg,vn_deg_prop,cn_deg,cn_deg_prop,punc_deg,punc_prop]=degree_distribution(pop_vn_deg_num(i,:),pop_cn_deg_num(i,:));
    %二分法计算迭代阈值
    [pop_sigma(i),pop_Pe(i)]=GA_th_punc(sigma_min,sigma_max,iter,Pe,vn_deg,vn_deg_prop,cn_deg,cn_deg_prop,punc_deg,punc_prop);
end



