function [p_deg_per_col,p_deg_per_row]=init_pop(NP,N,M,E0,vn_deg_min,vn_deg_max,cn_deg_min,cn_deg_max)
%产生NP个种群
p_deg_per_col=zeros(NP,N);
p_deg_per_row=zeros(NP,M);
for i=1:NP 
    %初始化protograph每行每列的度
    [p_deg_per_col(i,:),p_deg_per_row(i,:)]=init_deg(N,M,E0,vn_deg_min,vn_deg_max,cn_deg_min,cn_deg_max);
end

