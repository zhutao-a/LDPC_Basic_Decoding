function [pop_vn_deg_num,pop_cn_deg_num]=initial_population()%产生NP个种群
%%
%全局参数
global  NP; 
global  N;              global  M;  
global  vn_deg_min;     global  vn_deg_max;
global  cn_deg_min;     global  cn_deg_max;  
%%
%产生NP个种群
pop_deg_per_col=zeros(NP,N);
pop_deg_per_row=zeros(NP,M);
for i=1:NP 
    [pop_deg_per_col(i,:),pop_deg_per_row(i,:)]=initial_degree();%初始化protograph每行每列的度
end
%%
%将每行每列的度进行统计
pop_vn_deg_num=zeros(NP,vn_deg_max-vn_deg_min+1);
pop_cn_deg_num=zeros(NP,cn_deg_max-cn_deg_min+1);
for i=1:NP
    for j=1:(vn_deg_max-vn_deg_min+1)
        pop_vn_deg_num(i,j)=sum(pop_deg_per_col(i,:)==(j+vn_deg_min-1));
    end
end

for i=1:NP
    for j=1:(cn_deg_max-cn_deg_min+1)
        pop_cn_deg_num(i,j)=sum(pop_deg_per_row(i,:)==j+cn_deg_min-1);
    end
end

