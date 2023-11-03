function [m_vn_deg_num,m_cn_deg_num]=generate_variant(vn_deg_num,cn_deg_num,strategy)%突变得到多个个体
global mutate_num;
%重复mutate_num次
persistent x;
if isempty(x)%初始化方法
    x=0;
else
    x=~x;
end
m_vn_deg_num=repmat(vn_deg_num,mutate_num,1);
m_cn_deg_num=repmat(cn_deg_num,mutate_num,1);
switch strategy
    case 1      %轮流突变
        if(x==0)
            for i=1:mutate_num
                m_vn_deg_num(i,:)=vn_deg_num_mutate(m_vn_deg_num(i,:),30);%vn_deg_num的突变
            end
        else
            for i=1:mutate_num
                m_cn_deg_num(i,:)=cn_deg_num_mutate(m_cn_deg_num(i,:),30);%cn_deg_num的突变
            end
        end
    case 2      %同时突变
        for i=1:mutate_num
            m_vn_deg_num(i,:)=vn_deg_num_mutate(m_vn_deg_num(i,:),30);%vn_deg_num的突变
            m_cn_deg_num(i,:)=cn_deg_num_mutate(m_cn_deg_num(i,:),30);%cn_deg_num的突变
        end
end





