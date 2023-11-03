function [pop_deg_per_col,pop_deg_per_row]=initial_population()%产生NP个种群
%%
%全局参数
global  NP; 
global  N;              global  M;  
%%
%产生NP个种群
pop_deg_per_col=zeros(NP,N);
pop_deg_per_row=zeros(NP,M);
for i=1:NP 
    [pop_deg_per_col(i,:),pop_deg_per_row(i,:)]=initial_degree();%初始化protograph每行每列的度
end


