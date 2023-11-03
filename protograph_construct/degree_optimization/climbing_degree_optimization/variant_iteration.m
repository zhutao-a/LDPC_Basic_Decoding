function [deg_per_col,deg_per_row,sigma,Pe]=variant_iteration(deg_per_col,deg_per_row,sigma,Pe,strategy)%突变迭代
[m_deg_per_col,m_deg_per_row]=change_deg_distribution(deg_per_col,deg_per_row,strategy);%突变得到多个个体
[m_sigma,m_Pe]=population_fitness(m_deg_per_col,m_deg_per_row);%计算突变种群的适应度
sigma_best=max(m_sigma);
sigma_best_index=find(m_sigma==sigma_best);
[Pe_best,index]=min(m_Pe(sigma_best_index));
if( (sigma_best>sigma) || ( (sigma_best==sigma) && (Pe_best<Pe) ) )%突变体优于原先个体
    deg_per_col=m_deg_per_col(sigma_best_index(index),:);
    deg_per_row=m_deg_per_row(sigma_best_index(index),:);
    sigma=m_sigma(sigma_best_index(index));
    Pe=m_Pe(sigma_best_index(index));
end

