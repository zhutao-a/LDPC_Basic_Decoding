function [u_deg_per_col,u_deg_per_row]=cross(p_deg_per_col,p_deg_per_row,v_deg_per_col,v_deg_per_row,CR)%产生交叉群体
[~,N]=size(p_deg_per_col);
[~,M]=size(p_deg_per_row);
u_deg_per_col=zeros(size(p_deg_per_col));
u_deg_per_row=zeros(size(p_deg_per_row));
col=randi(N);%随机选择某一列
%对deg_per_col产生交叉群体
for i=1:N
    r=rand(1);
    if(r<=CR||i==col)
        u_deg_per_col(:,i)=v_deg_per_col(:,i);
    else
        u_deg_per_col(:,i)=p_deg_per_col(:,i);
    end
end
row=randi(M);%随机选择某一行
%对deg_per_col产生交叉群体
for i=1:M
    r=rand(1);
    if(r<=CR||i==row)
        u_deg_per_row(:,i)=v_deg_per_row(:,i);
    else
        u_deg_per_row(:,i)=p_deg_per_row(:,i);
    end
end

