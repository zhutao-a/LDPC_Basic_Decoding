function [m_vn_deg_num,m_cn_deg_num]=generate_variant(vn_deg_num,cn_deg_num,strategy)%ͻ��õ��������
global mutate_num;
%�ظ�mutate_num��
persistent x;
if isempty(x)%��ʼ������
    x=0;
else
    x=~x;
end
m_vn_deg_num=repmat(vn_deg_num,mutate_num,1);
m_cn_deg_num=repmat(cn_deg_num,mutate_num,1);
switch strategy
    case 1      %����ͻ��
        if(x==0)
            for i=1:mutate_num
                m_vn_deg_num(i,:)=vn_deg_num_mutate(m_vn_deg_num(i,:),30);%vn_deg_num��ͻ��
            end
        else
            for i=1:mutate_num
                m_cn_deg_num(i,:)=cn_deg_num_mutate(m_cn_deg_num(i,:),30);%cn_deg_num��ͻ��
            end
        end
    case 2      %ͬʱͻ��
        for i=1:mutate_num
            m_vn_deg_num(i,:)=vn_deg_num_mutate(m_vn_deg_num(i,:),30);%vn_deg_num��ͻ��
            m_cn_deg_num(i,:)=cn_deg_num_mutate(m_cn_deg_num(i,:),30);%cn_deg_num��ͻ��
        end
end





