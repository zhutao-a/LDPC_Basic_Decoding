function [m_deg_per_col,m_deg_per_row]=change_deg_distribution(deg_per_col,deg_per_row,strategy)
%通过不同策略来改变度分布
%%
global  M;              global  N; 
global  mutate_num;
global  vn_deg_max;     global  cn_deg_max;  
%NP表示种群大小
%strategy   1:对基础矩阵同一行不同列的0,1进行交换   2:对基础矩阵同一列不同行的0,1进行交换   3:增加一条边     4:减少一条边
%生成种群个每行每列的度分布
m_deg_per_col=zeros(mutate_num,N);
m_deg_per_row=zeros(mutate_num,M);
c_change=50;
r_change=10;
edge_change=50;
%通过不同策略改变度分布
switch strategy
    case 1%1:对基础矩阵同一行不同列的0,1进行交换
        for i=1:mutate_num
            times=randi(c_change);%变化的次数
            for j=1:times
                m_deg_per_row(i,:)=deg_per_row;%行的度分布不变
                m_deg_per_col(i,:)=deg_per_col;
                out_col=randi(N);%移出1的列的位置
                while(m_deg_per_col(i,out_col)==2)%避免移出后度为1
                    out_col=randi(N);
                end
                in_col=randi(N);%移入1的列的位置
                while(in_col==out_col)%确保两者不相等
                    in_col=randi(N);
                end
                out_num=randi(m_deg_per_col(i,out_col)-2);%移出1的个数并保证度至少为2
                if((out_num+m_deg_per_col(i,in_col))>vn_deg_max)%避免移入位置度超过最大值
                    out_num=vn_deg_max-m_deg_per_col(i,in_col);
                end
                m_deg_per_col(i,in_col)=m_deg_per_col(i,in_col)+out_num;%移入列度加1
                m_deg_per_col(i,out_col)=m_deg_per_col(i,out_col)-out_num; %移出列度减1
            end
        end
    case 2%2:对基础矩阵同一列不同行的0,1进行交换
        for i=1:mutate_num
            times=randi(r_change);%变化的次数
            for j=1:times
                m_deg_per_col(i,:)=deg_per_col;%列的度分布不变
                m_deg_per_row(i,:)=deg_per_row;
                out_row=randi(M);%移出1的行的位置
                while(m_deg_per_row(i,out_row)==2)%避免移出后度为1
                    out_row=randi(M);
                end
                in_row=randi(M);%移入1的行的位置
                while(in_row==out_row)%确保两者不相等
                    in_row=randi(M);
                end
                out_num=randi(m_deg_per_row(i,out_row)-2);%移出1的个数并保证度至少为2
                if((out_num+m_deg_per_row(i,in_row))>cn_deg_max)%避免移入位置度超过最大值
                    out_num=cn_deg_max-m_deg_per_row(i,in_row);
                end
                m_deg_per_row(i,in_row)=m_deg_per_row(i,in_row)+out_num;%移入行度加1
                m_deg_per_row(i,out_row)=m_deg_per_row(i,out_row)-out_num; %移出行度减1
            end
        end
    case 3%3:增加一条边
        for i=1:mutate_num
            times=randi(edge_change);%变化的次数
            for j=1:times
                m_deg_per_row(i,:)=deg_per_row;
                m_deg_per_col(i,:)=deg_per_col;
                tmp=find(deg_per_row~=cn_deg_max);%找到度小于最大度的校验节点
                if(isempty(tmp))
                    break;
                end
                in_row=tmp(randi(length(tmp)));%求出添加1的行
                tmp=find(deg_per_col~=vn_deg_max);%找到度小于最大度的变量节点
                if(isempty(tmp))
                    break;
                end
                in_col=tmp(randi(length(tmp)));%求出添加1的列
                m_deg_per_row(i,in_row)=m_deg_per_row(i,in_row)+1;%移入行度加1
                m_deg_per_col(i,in_col)=m_deg_per_col(i,in_col)+1;%移入列度加1
            end
        end
    case 4%4:减少一条边  
        for i=1:mutate_num
            times=randi(edge_change);%变化的次数
            for j=1:times
                m_deg_per_row(i,:)=deg_per_row;
                m_deg_per_col(i,:)=deg_per_col;
                out_col=randi(N);%移出1的列的位置
                while(m_deg_per_col(i,out_col)==2)%避免移出后度为1
                    out_col=randi(N);
                end
                out_row=randi(M);%移出1的行的位置
                while(m_deg_per_row(i,out_row)==2)%避免移出后度为1
                    out_row=randi(M);
                end
                m_deg_per_col(i,out_col)=m_deg_per_col(i,out_col)-1; %移出列度减1
                m_deg_per_row(i,out_row)=m_deg_per_row(i,out_row)-1; %移出行度减1
            end
        end
end





