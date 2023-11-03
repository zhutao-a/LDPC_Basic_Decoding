clear;
clear all;
tic;
%%
%protograph的参数
vn_degree_max=17;
cn_degree_max=30;
average_dc=27.85;
rate=111/128;%要求的码率
M=17;%protograph的行数
N=round(M/(1-rate));%protograph的列数

real_rate=1-M/N;%实际得到的码率
disp(N);disp(M);disp(real_rate);
%%
%GA计算迭代阈值的参数
Pe = 1e-16;%最小错误概率
max_iter = 50;%设置最大的迭代次数
NP=300;
%%
%初始化protograph每行每列的度，需要满足sum(degree_per_col)=sum(degree_per_row)
[degree_per_col,degree_per_row]=initial_degree(N,M,average_dc,vn_degree_max,cn_degree_max);
%通过每行每列的度计算出度分布
[vn_degree,vn_edge_portion,cn_degree,cn_edge_portion]=degree_distribution(degree_per_col,degree_per_row);
%给定度分布和参数利用高斯近似计算迭代阈值(二分法)
[sigma,Pe_best]=calculate_threshold_GA(0.2,0.6,max_iter,Pe,vn_degree,vn_edge_portion,cn_degree,cn_edge_portion);
sigma_best=sigma;
disp(sigma_best);
disp(Pe_best);
sigma_current=zeros(NP,1);
Pe_current=zeros(NP,1);
i=0;
while(i<300)
    disp(i);
    for j=1:2
        [m_degree_per_col,m_degree_per_row]=change_degree(degree_per_col,degree_per_row,NP,j,vn_degree_max,cn_degree_max);%通过不同策略来改变度分布
        for k=1:NP
            %通过每行每列的度计算出度分布
            [vn_degree,vn_edge_portion,cn_degree,cn_edge_portion]=degree_distribution(m_degree_per_col(k,:),m_degree_per_row(k,:));
            %给定度分布和参数利用高斯近似计算迭代阈值(二分法)
            [sigma_current(k),Pe_current(k)]=calculate_threshold_GA(0.2,0.6,max_iter,Pe,vn_degree,vn_edge_portion,cn_degree,cn_edge_portion);
        end
        [sigma_current_best,index] = max(sigma_current);%求得度变化后的最大的sigma
        if(sigma_current_best>sigma_best)
            sigma_best=sigma_current_best;
            Pe_best=Pe_current(index);
            degree_per_col=m_degree_per_col(index,:);
            degree_per_row=m_degree_per_row(index,:);
        elseif(sigma_current_best==sigma_best)
            tmp1=find(sigma_current==sigma_current_best);%找到所有sigma相同的索引        
            [Pe_min,tmp2]=min(Pe_current(tmp1));%取最小pe,并找出索引
            if(Pe_min<Pe_best)
                Pe_best=Pe_min;
                degree_per_col=m_degree_per_col(tmp1(tmp2),:);
                degree_per_row=m_degree_per_row(tmp1(tmp2),:);
            end

        end
        disp(sigma_best);
        disp(Pe_best);
    end
    i=i+1;
    if(mod(i,10)==0)
        [vn_degree,vn_edge_portion,cn_degree,cn_edge_portion]=degree_distribution(degree_per_col,degree_per_row);
        disp(vn_degree);
        disp(vn_edge_portion);
        disp(cn_degree);
        disp(cn_edge_portion);
    end
end




toc;

%         ebn0=1/(2*Rate*sigma^2);
%         EBN0=10*log10(ebn0);
%         disp(['The threshold EBN0 = ' num2str(EBN0)]);
