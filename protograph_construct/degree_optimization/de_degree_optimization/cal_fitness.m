function [p_sigma,p_Pe]=cal_fitness(sig_min,sig_max,iter,Pe,p_deg_per_col,p_deg_per_row,punc_idx)
[NP,~]=size(p_deg_per_col);
p_sigma=zeros(NP,1);
p_Pe=zeros(NP,1);
for i=1:NP
    %通过每行每列的度计算出度分布,同时给出puncture掉的度以及比例
    [vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop]=deg_distr(p_deg_per_col(i,:),p_deg_per_row(i,:),punc_idx);
    %二分法计算迭代阈值
    [p_sigma(i),p_Pe(i)]=GA_th_punc(sig_min,sig_max,iter,Pe,vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop);
end



