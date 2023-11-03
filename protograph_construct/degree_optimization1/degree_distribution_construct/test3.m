clear;
clear all;
tic;
%%
%protograph的参数
vn_degree_max=20;
cn_degree_max=20;
% average_dc=27.85;
rate=1-80/368;%要求的码率
M=80;%protograph的行数
N=368;%protograph的列数

% real_rate=1-M/N;%实际得到的码率
% disp(N);disp(M);disp(real_rate);
%%
%GA计算迭代阈值的参数
Pe = 1e-20;%最小错误概率
max_iter = 50;%设置最大的迭代次数
NP=300;
%%
%初始化protograph每行每列的度，需要满足sum(degree_per_col)=sum(degree_per_row)
% [degree_per_col,degree_per_row]=initial_degree(N,M,average_dc,vn_degree_max,cn_degree_max);
%通过每行每列的度计算出度分布

vn_degree=[3,14,15,16,17,18];%变量节点的度d
vn_degree_num=[352,2,3,5,4,2];%变量节点度为d对应的变量节点的数目
cn_degree=[12,13,14,15,16,17,18,19,20];%校验节点的度d
cn_degree_num=[1,2,3,15,18,22,16,2,1];%校验节点度为d对应的校验节点的数目
degree_per_col=zeros(1,368);
j=1;
i=1;
while(i<=368)
    if(vn_degree_num(j)~=0)
        degree_per_col(i)=vn_degree(j);
        vn_degree_num(j)=vn_degree_num(j)-1;
        i=i+1;
    else
        j=j+1;
    end
end
degree_per_row=zeros(1,80);
j=1;
i=1;
while(i<=80)
    if(cn_degree_num(j)~=0)
        degree_per_row(i)=cn_degree(j);
        cn_degree_num(j)=cn_degree_num(j)-1;
        i=i+1;
    else
        j=j+1;
    end
end

[vn_degree,vn_edge_portion,cn_degree,cn_edge_portion]=degree_distribution(degree_per_col,degree_per_row);
%给定度分布和参数利用高斯近似计算迭代阈值(二分法)
[sigma,Pe_best]=calculate_threshold_GA(0.3,0.7,max_iter,Pe,vn_degree,vn_edge_portion,cn_degree,cn_edge_portion);
sigma_best=sigma;
disp(sigma_best);
disp(Pe_best);

sigma_current=zeros(NP,1);
Pe_current=zeros(NP,1);
i=0;
while(i<300)
    disp(i);
    for j=1:4
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
