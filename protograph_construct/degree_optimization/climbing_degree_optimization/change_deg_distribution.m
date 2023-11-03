function [m_deg_per_col,m_deg_per_row]=change_deg_distribution(deg_per_col,deg_per_row,strategy)
%ͨ����ͬ�������ı�ȷֲ�
%%
global  M;              global  N; 
global  mutate_num;
global  vn_deg_max;     global  cn_deg_max;  
%NP��ʾ��Ⱥ��С
%strategy   1:�Ի�������ͬһ�в�ͬ�е�0,1���н���   2:�Ի�������ͬһ�в�ͬ�е�0,1���н���   3:����һ����     4:����һ����
%������Ⱥ��ÿ��ÿ�еĶȷֲ�
m_deg_per_col=zeros(mutate_num,N);
m_deg_per_row=zeros(mutate_num,M);
c_change=50;
r_change=10;
edge_change=50;
%ͨ����ͬ���Ըı�ȷֲ�
switch strategy
    case 1%1:�Ի�������ͬһ�в�ͬ�е�0,1���н���
        for i=1:mutate_num
            times=randi(c_change);%�仯�Ĵ���
            for j=1:times
                m_deg_per_row(i,:)=deg_per_row;%�еĶȷֲ�����
                m_deg_per_col(i,:)=deg_per_col;
                out_col=randi(N);%�Ƴ�1���е�λ��
                while(m_deg_per_col(i,out_col)==2)%�����Ƴ����Ϊ1
                    out_col=randi(N);
                end
                in_col=randi(N);%����1���е�λ��
                while(in_col==out_col)%ȷ�����߲����
                    in_col=randi(N);
                end
                out_num=randi(m_deg_per_col(i,out_col)-2);%�Ƴ�1�ĸ�������֤������Ϊ2
                if((out_num+m_deg_per_col(i,in_col))>vn_deg_max)%��������λ�öȳ������ֵ
                    out_num=vn_deg_max-m_deg_per_col(i,in_col);
                end
                m_deg_per_col(i,in_col)=m_deg_per_col(i,in_col)+out_num;%�����жȼ�1
                m_deg_per_col(i,out_col)=m_deg_per_col(i,out_col)-out_num; %�Ƴ��жȼ�1
            end
        end
    case 2%2:�Ի�������ͬһ�в�ͬ�е�0,1���н���
        for i=1:mutate_num
            times=randi(r_change);%�仯�Ĵ���
            for j=1:times
                m_deg_per_col(i,:)=deg_per_col;%�еĶȷֲ�����
                m_deg_per_row(i,:)=deg_per_row;
                out_row=randi(M);%�Ƴ�1���е�λ��
                while(m_deg_per_row(i,out_row)==2)%�����Ƴ����Ϊ1
                    out_row=randi(M);
                end
                in_row=randi(M);%����1���е�λ��
                while(in_row==out_row)%ȷ�����߲����
                    in_row=randi(M);
                end
                out_num=randi(m_deg_per_row(i,out_row)-2);%�Ƴ�1�ĸ�������֤������Ϊ2
                if((out_num+m_deg_per_row(i,in_row))>cn_deg_max)%��������λ�öȳ������ֵ
                    out_num=cn_deg_max-m_deg_per_row(i,in_row);
                end
                m_deg_per_row(i,in_row)=m_deg_per_row(i,in_row)+out_num;%�����жȼ�1
                m_deg_per_row(i,out_row)=m_deg_per_row(i,out_row)-out_num; %�Ƴ��жȼ�1
            end
        end
    case 3%3:����һ����
        for i=1:mutate_num
            times=randi(edge_change);%�仯�Ĵ���
            for j=1:times
                m_deg_per_row(i,:)=deg_per_row;
                m_deg_per_col(i,:)=deg_per_col;
                tmp=find(deg_per_row~=cn_deg_max);%�ҵ���С�����ȵ�У��ڵ�
                if(isempty(tmp))
                    break;
                end
                in_row=tmp(randi(length(tmp)));%������1����
                tmp=find(deg_per_col~=vn_deg_max);%�ҵ���С�����ȵı����ڵ�
                if(isempty(tmp))
                    break;
                end
                in_col=tmp(randi(length(tmp)));%������1����
                m_deg_per_row(i,in_row)=m_deg_per_row(i,in_row)+1;%�����жȼ�1
                m_deg_per_col(i,in_col)=m_deg_per_col(i,in_col)+1;%�����жȼ�1
            end
        end
    case 4%4:����һ����  
        for i=1:mutate_num
            times=randi(edge_change);%�仯�Ĵ���
            for j=1:times
                m_deg_per_row(i,:)=deg_per_row;
                m_deg_per_col(i,:)=deg_per_col;
                out_col=randi(N);%�Ƴ�1���е�λ��
                while(m_deg_per_col(i,out_col)==2)%�����Ƴ����Ϊ1
                    out_col=randi(N);
                end
                out_row=randi(M);%�Ƴ�1���е�λ��
                while(m_deg_per_row(i,out_row)==2)%�����Ƴ����Ϊ1
                    out_row=randi(M);
                end
                m_deg_per_col(i,out_col)=m_deg_per_col(i,out_col)-1; %�Ƴ��жȼ�1
                m_deg_per_row(i,out_row)=m_deg_per_row(i,out_row)-1; %�Ƴ��жȼ�1
            end
        end
end





