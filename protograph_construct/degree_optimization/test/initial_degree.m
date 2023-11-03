function [deg_per_col,deg_per_row]=initial_degree()%初始化protograph每行每列的度
%%
%全局参数
global  N;              global  M;                
global  E0;
global  vn_deg_min;     global  vn_deg_max;
global  cn_deg_min;     global  cn_deg_max;

average_dc=floor(E0/M);
if(average_dc>=cn_deg_max)%判断是否边数过大
    error('please input a smaller E0');
end
%%
%初始化变量节点度分布
deg_per_col=vn_deg_min*ones(1,N);%每一列初始化为vn_deg_min
E=E0-sum(deg_per_col);%还需要填充多少边
while(E~=0)%直到边填充完
    for i=1:N
        if(E==0)%边已经填充完了
            break;
        end
        tmp=randi([0,vn_deg_max-deg_per_col(i)]);%产生一个随机整数加在每一列上并使得不超过vn_deg_max
        tmp=min(tmp,E);%确保在最后一次时不会超过剩余的边数
        deg_per_col(i)=deg_per_col(i)+tmp;
        E=E-tmp;
    end
end
%%
%初始化校验节点度分布
deg_per_row=cn_deg_min*ones(1,M);%每一行度初始化为cn_deg_min
E=E0-cn_deg_min*M;%还需要填充多少边
while(E~=0)%直到边填充完
    for i=1:M
        if(E==0)%边已经填充完了
            break;
        end
        tmp=randi([0,cn_deg_max-deg_per_row(i)]);%产生一个随机整数加在每一行上并使得不超过cn_deg_max
        tmp=min(tmp,E);%确保在最后一次时不会超过剩余的边数
        deg_per_row(i)=deg_per_row(i)+tmp;
        E=E-tmp;
    end
end

