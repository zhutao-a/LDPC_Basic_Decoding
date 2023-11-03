function [degree_per_col,degree_per_row]=initial_degree(N,M,average_dc,vn_degree_max,cn_degree_max)
%average_dc需要大于15.0588
if(average_dc>cn_degree_max||average_dc<22.588)
    average_dc=28.612;
end
%求出总边数
E=floor(average_dc*M);
%产生两种不同度的校验节点
degree_per_row=floor(E/M)*ones(1,M);%将边平均分布在每行
%多余的边平均放置在序号较大的行
remained=E-M*floor(E/M);
degree_per_row(end-remained+1:end)=degree_per_row(end-remained+1:end)+1;
E=E-2*N;%每个变量节点度至少为2
degree_per_col=2*ones(1,N);%变量节点度不小于2
for i=1:N
    if(E==0)%边已经填充完了
        break;
    end
    tmp=randi([0,vn_degree_max-2]);%产生一个随机整数加在每一列上，并使得不超过最大度
    tmp=min(tmp,E);%确保在最后一次时不会超过剩余的边数
    degree_per_col(i)=degree_per_col(i)+tmp;
    E=E-tmp;
end


