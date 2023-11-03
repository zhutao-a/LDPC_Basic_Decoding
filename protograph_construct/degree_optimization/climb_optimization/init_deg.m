function [deg_per_col,deg_per_row]=init_deg(N,M,E0,vn_deg_min,vn_deg_max,cn_deg_min,cn_deg_max)
%产生两种不同度的校验节点
average_dc=floor(E0/M);
if(average_dc>=cn_deg_max)
    error('please input a smaller cn_deg_max');
end
%初始化每个变量节点的度
deg_per_col=vn_deg_min*ones(1,N);%变量节点度不小于vn_deg_min
E=E0-sum(deg_per_col);%每个变量节点度至少为vn_deg_min
while(E~=0)%直到边填充完
    for i=1:N
        if(E==0)%边已经填充完了
            break;
        end
        tmp=randi([0,vn_deg_max-deg_per_col(i)]);%产生一个随机整数加在每一列上，并使得不超过最大度
        tmp=min(tmp,E);%确保在最后一次时不会超过剩余的边数
        deg_per_col(i)=deg_per_col(i)+tmp;
        E=E-tmp;
    end
end
%初始化每个校验节点的度
E=E0-cn_deg_min*M;%每个校验节点度至少为cn_deg_min
deg_per_row=cn_deg_min*ones(1,M);%校验节点度不小于cn_deg_min
while(E~=0)%直到边填充完
    for i=1:M
        if(E==0)%边已经填充完了
            break;
        end
        tmp=randi([0,cn_deg_max-deg_per_row(i)]);%产生一个随机整数加在每一行上，并使得不超过最大度
        tmp=min(tmp,E);%确保在最后一次时不会超过剩余的边数
        deg_per_row(i)=deg_per_row(i)+tmp;
        E=E-tmp;
    end
end

