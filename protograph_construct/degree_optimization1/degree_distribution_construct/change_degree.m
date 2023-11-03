function [m_degree_per_col,m_degree_per_row]=change_degree(degree_per_col,degree_per_row,NP,strategy,vn_degree_max,cn_degree_max)%通过不同策略来改变度分布
%NP表示种群大小
%strategy   1:对基础矩阵同一行不同列的0,1进行交换   2:对基础矩阵同一列不同行的0,1进行交换   3:增加一条边     4:减少一条边
%生成种群个每行每列的度分布
N=length(degree_per_col);
M=length(degree_per_row);
m_degree_per_col=zeros(NP,N);
m_degree_per_row=zeros(NP,M);
rc_change=10;
edge_change=30;
%通过不同策略改变度分布
switch strategy
    case 1%1:对基础矩阵同一行不同列的0,1进行交换
        for i=1:NP
            times=randi(rc_change);%变化的次数
            for j=1:times
                m_degree_per_row(i,:)=degree_per_row;%行的度分布不变
                m_degree_per_col(i,:)=degree_per_col;
                out_column=randi(N);%移出1的列的位置
                while(m_degree_per_col(i,out_column)==2)%避免移出后度为1
                    out_column=randi(N);
                end
                in_column=randi(N);%移入1的列的位置
                while(in_column==out_column)%确保两者不相等
                    in_column=randi(N);
                end
                out_num=randi(m_degree_per_col(i,out_column)-2);%移出1的个数并保证度至少为2
                if((out_num+m_degree_per_col(i,in_column))>vn_degree_max)%避免移入位置度超过最大值
                    out_num=vn_degree_max-m_degree_per_col(i,in_column);
                end
                m_degree_per_col(i,in_column)=m_degree_per_col(i,in_column)+out_num;%移入列度加1
                m_degree_per_col(i,out_column)=m_degree_per_col(i,out_column)-out_num; %移出列度减1
            end
        end
    case 2%2:对基础矩阵同一列不同行的0,1进行交换
        for i=1:NP
            times=randi(rc_change);%变化的次数
            for j=1:times
                m_degree_per_col(i,:)=degree_per_col;%列的度分布不变
                m_degree_per_row(i,:)=degree_per_row;
                out_row=randi(M);%移出1的行的位置
                while(m_degree_per_row(i,out_row)==2)%避免移出后度为1
                    out_row=randi(M);
                end
                in_row=randi(M);%移入1的行的位置
                while(in_row==out_row)%确保两者不相等
                    in_row=randi(M);
                end
                out_num=randi(m_degree_per_row(i,out_row)-2);%移出1的个数并保证度至少为2
                if((out_num+m_degree_per_row(i,in_row))>cn_degree_max)%避免移入位置度超过最大值
                    out_num=cn_degree_max-m_degree_per_row(i,in_row);
                end
                m_degree_per_row(i,in_row)=m_degree_per_row(i,in_row)+out_num;%移入行度加1
                m_degree_per_row(i,out_row)=m_degree_per_row(i,out_row)-out_num; %移出行度减1
            end
        end
    case 3%3:增加一条边
        for i=1:NP
            times=randi(edge_change);%变化的次数
            for j=1:times
                m_degree_per_row(i,:)=degree_per_row;
                m_degree_per_col(i,:)=degree_per_col;
                in_row=randi(M);
                while(m_degree_per_row(i,in_row)==cn_degree_max)%除去度已经最大的校验节点
                    in_row=randi(M);
                end
                in_column=randi(N);
                while(m_degree_per_col(i,in_column)==vn_degree_max)%除去度已经最大的变量节点
                    in_column=randi(N);
                end
                m_degree_per_row(i,in_row)=m_degree_per_row(i,in_row)+1;%移入行度加1
                m_degree_per_col(i,in_column)=m_degree_per_col(i,in_column)+1;%移入列度加1
            end
        end
    case 4%4:减少一条边  
        for i=1:NP
            times=randi(edge_change);%变化的次数
            for j=1:times
                m_degree_per_row(i,:)=degree_per_row;
                m_degree_per_col(i,:)=degree_per_col;
                out_column=randi(N);%移出1的列的位置
                while(m_degree_per_col(i,out_column)==2)%避免移出后度为1
                    out_column=randi(N);
                end
                out_row=randi(M);%移出1的行的位置
                while(m_degree_per_row(i,out_row)==2)%避免移出后度为1
                    out_row=randi(M);
                end
                m_degree_per_col(i,out_column)=m_degree_per_col(i,out_column)-1; %移出列度减1
                m_degree_per_row(i,out_row)=m_degree_per_row(i,out_row)-1; %移出行度减1
            end
        end
end





