function [u_deg_per_col,u_deg_per_row]=cross(p_deg_per_col,p_deg_per_row,v_deg_per_col,v_deg_per_row,CR)%��������Ⱥ��
[~,N]=size(p_deg_per_col);
[~,M]=size(p_deg_per_row);
u_deg_per_col=zeros(size(p_deg_per_col));
u_deg_per_row=zeros(size(p_deg_per_row));
col=randi(N);%���ѡ��ĳһ��
%��deg_per_col��������Ⱥ��
for i=1:N
    r=rand(1);
    if(r<=CR||i==col)
        u_deg_per_col(:,i)=v_deg_per_col(:,i);
    else
        u_deg_per_col(:,i)=p_deg_per_col(:,i);
    end
end
row=randi(M);%���ѡ��ĳһ��
%��deg_per_col��������Ⱥ��
for i=1:M
    r=rand(1);
    if(r<=CR||i==row)
        u_deg_per_row(:,i)=v_deg_per_row(:,i);
    else
        u_deg_per_row(:,i)=p_deg_per_row(:,i);
    end
end

