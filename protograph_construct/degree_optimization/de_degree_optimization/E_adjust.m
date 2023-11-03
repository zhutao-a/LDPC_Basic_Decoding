function [u_deg_per_col,u_deg_per_row]=E_adjust(E0,vn_deg_min,vn_deg_max,cn_deg_min,cn_deg_max,u_deg_per_col,u_deg_per_row)
[NP,N]=size(u_deg_per_col);
[~,M]=size(u_deg_per_row);
%限定种群列的数值范围
for i=1:NP
    for j=1:N
        if(u_deg_per_col(i,j)<vn_deg_min)
            u_deg_per_col(i,j)=vn_deg_min;
        elseif(u_deg_per_col(i,j)>vn_deg_max)
            u_deg_per_col(i,j)=vn_deg_max;
        end
    end
end
%调整边数
for i=1:NP
    E=sum(u_deg_per_col(i,:));%计算出当前的边数
    if(E>=E0)%边数比以前多
        E_delete=0;
        while(E_delete~=(E-E0))
            nomin_index=find(u_deg_per_col(i,:)~=vn_deg_min);
            col=randi(length(nomin_index));%删除边的列的索引
            u_deg_per_col(i,nomin_index(col))=u_deg_per_col(i,nomin_index(col))-1;
            E_delete=E_delete+1;
        end
    else%边数比以前少
        E_add=0;
        while(E_add~=(E0-E))
            nomax_index=find(u_deg_per_col(i,:)~=vn_deg_max);
            col=randi(length(nomax_index));%删除边的列的索引
            u_deg_per_col(i,nomax_index(col))=u_deg_per_col(i,nomax_index(col))+1;
            E_add=E_add+1;
        end
    end
end


%限定种群行的数值范围
for i=1:NP
    for j=1:M
        if(u_deg_per_row(i,j)<cn_deg_min)
            u_deg_per_row(i,j)=cn_deg_min;
        elseif(u_deg_per_row(i,j)>cn_deg_max)
            u_deg_per_row(i,j)=cn_deg_max;
        end
    end
end
%调整边数
for i=1:NP
    E=sum(u_deg_per_row(i,:));%计算出当前的边数
    if(E>=E0)%边数比以前多
        E_delete=0;
        while(E_delete~=(E-E0))
            nomin_index=find(u_deg_per_row(i,:)~=cn_deg_min);
            row=randi(length(nomin_index));%删除边的列的索引
            u_deg_per_row(i,nomin_index(row))=u_deg_per_row(i,nomin_index(row))-1;
            E_delete=E_delete+1;
        end
    else%边数比以前少
        E_add=0;
        while(E_add~=(E0-E))
            nomax_index=find(u_deg_per_row(i,:)~=cn_deg_max);
            row=randi(length(nomax_index));%删除边的列的索引
            u_deg_per_row(i,nomax_index(row))=u_deg_per_row(i,nomax_index(row))+1;
            E_add=E_add+1;
        end
    end
end



