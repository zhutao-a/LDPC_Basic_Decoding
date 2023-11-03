function [m_degree_per_col,m_degree_per_row]=change_degree(degree_per_col,degree_per_row,NP,strategy,vn_degree_max,cn_degree_max)%ͨ����ͬ�������ı�ȷֲ�
%NP��ʾ��Ⱥ��С
%strategy   1:�Ի�������ͬһ�в�ͬ�е�0,1���н���   2:�Ի�������ͬһ�в�ͬ�е�0,1���н���   3:����һ����     4:����һ����
%������Ⱥ��ÿ��ÿ�еĶȷֲ�
N=length(degree_per_col);
M=length(degree_per_row);
m_degree_per_col=zeros(NP,N);
m_degree_per_row=zeros(NP,M);
rc_change=10;
edge_change=30;
%ͨ����ͬ���Ըı�ȷֲ�
switch strategy
    case 1%1:�Ի�������ͬһ�в�ͬ�е�0,1���н���
        for i=1:NP
            times=randi(rc_change);%�仯�Ĵ���
            for j=1:times
                m_degree_per_row(i,:)=degree_per_row;%�еĶȷֲ�����
                m_degree_per_col(i,:)=degree_per_col;
                out_column=randi(N);%�Ƴ�1���е�λ��
                while(m_degree_per_col(i,out_column)==2)%�����Ƴ����Ϊ1
                    out_column=randi(N);
                end
                in_column=randi(N);%����1���е�λ��
                while(in_column==out_column)%ȷ�����߲����
                    in_column=randi(N);
                end
                out_num=randi(m_degree_per_col(i,out_column)-2);%�Ƴ�1�ĸ�������֤������Ϊ2
                if((out_num+m_degree_per_col(i,in_column))>vn_degree_max)%��������λ�öȳ������ֵ
                    out_num=vn_degree_max-m_degree_per_col(i,in_column);
                end
                m_degree_per_col(i,in_column)=m_degree_per_col(i,in_column)+out_num;%�����жȼ�1
                m_degree_per_col(i,out_column)=m_degree_per_col(i,out_column)-out_num; %�Ƴ��жȼ�1
            end
        end
    case 2%2:�Ի�������ͬһ�в�ͬ�е�0,1���н���
        for i=1:NP
            times=randi(rc_change);%�仯�Ĵ���
            for j=1:times
                m_degree_per_col(i,:)=degree_per_col;%�еĶȷֲ�����
                m_degree_per_row(i,:)=degree_per_row;
                out_row=randi(M);%�Ƴ�1���е�λ��
                while(m_degree_per_row(i,out_row)==2)%�����Ƴ����Ϊ1
                    out_row=randi(M);
                end
                in_row=randi(M);%����1���е�λ��
                while(in_row==out_row)%ȷ�����߲����
                    in_row=randi(M);
                end
                out_num=randi(m_degree_per_row(i,out_row)-2);%�Ƴ�1�ĸ�������֤������Ϊ2
                if((out_num+m_degree_per_row(i,in_row))>cn_degree_max)%��������λ�öȳ������ֵ
                    out_num=cn_degree_max-m_degree_per_row(i,in_row);
                end
                m_degree_per_row(i,in_row)=m_degree_per_row(i,in_row)+out_num;%�����жȼ�1
                m_degree_per_row(i,out_row)=m_degree_per_row(i,out_row)-out_num; %�Ƴ��жȼ�1
            end
        end
    case 3%3:����һ����
        for i=1:NP
            times=randi(edge_change);%�仯�Ĵ���
            for j=1:times
                m_degree_per_row(i,:)=degree_per_row;
                m_degree_per_col(i,:)=degree_per_col;
                in_row=randi(M);
                while(m_degree_per_row(i,in_row)==cn_degree_max)%��ȥ���Ѿ�����У��ڵ�
                    in_row=randi(M);
                end
                in_column=randi(N);
                while(m_degree_per_col(i,in_column)==vn_degree_max)%��ȥ���Ѿ����ı����ڵ�
                    in_column=randi(N);
                end
                m_degree_per_row(i,in_row)=m_degree_per_row(i,in_row)+1;%�����жȼ�1
                m_degree_per_col(i,in_column)=m_degree_per_col(i,in_column)+1;%�����жȼ�1
            end
        end
    case 4%4:����һ����  
        for i=1:NP
            times=randi(edge_change);%�仯�Ĵ���
            for j=1:times
                m_degree_per_row(i,:)=degree_per_row;
                m_degree_per_col(i,:)=degree_per_col;
                out_column=randi(N);%�Ƴ�1���е�λ��
                while(m_degree_per_col(i,out_column)==2)%�����Ƴ����Ϊ1
                    out_column=randi(N);
                end
                out_row=randi(M);%�Ƴ�1���е�λ��
                while(m_degree_per_row(i,out_row)==2)%�����Ƴ����Ϊ1
                    out_row=randi(M);
                end
                m_degree_per_col(i,out_column)=m_degree_per_col(i,out_column)-1; %�Ƴ��жȼ�1
                m_degree_per_row(i,out_row)=m_degree_per_row(i,out_row)-1; %�Ƴ��жȼ�1
            end
        end
end





