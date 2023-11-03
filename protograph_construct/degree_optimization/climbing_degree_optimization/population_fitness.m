function [pop_sigma,pop_Pe]=population_fitness(pop_deg_per_col,pop_deg_per_row)%计算种群的适应度
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
    [vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop]=degree_distribution(pop_deg_per_col(i,:),pop_deg_per_row(i,:));
    %二分法计算迭代阈值
    [pop_sigma(i),pop_Pe(i)]=GA_threshold_punc(sigma_min,sigma_max,iter,Pe,vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop);
end



