function [deg_per_col,deg_per_row]=init_deg(N,M,E0,vn_deg_min,vn_deg_max,cn_deg_min,cn_deg_max)
%�������ֲ�ͬ�ȵ�У��ڵ�
average_dc=floor(E0/M);
if(average_dc>=cn_deg_max)
    error('please input a smaller cn_deg_max');
end
%��ʼ��ÿ�������ڵ�Ķ�
deg_per_col=vn_deg_min*ones(1,N);%�����ڵ�Ȳ�С��vn_deg_min
E=E0-sum(deg_per_col);%ÿ�������ڵ������Ϊvn_deg_min
while(E~=0)%ֱ���������
    for i=1:N
        if(E==0)%���Ѿ��������
            break;
        end
        tmp=randi([0,vn_deg_max-deg_per_col(i)]);%����һ�������������ÿһ���ϣ���ʹ�ò���������
        tmp=min(tmp,E);%ȷ�������һ��ʱ���ᳬ��ʣ��ı���
        deg_per_col(i)=deg_per_col(i)+tmp;
        E=E-tmp;
    end
end
%��ʼ��ÿ��У��ڵ�Ķ�
E=E0-cn_deg_min*M;%ÿ��У��ڵ������Ϊcn_deg_min
deg_per_row=cn_deg_min*ones(1,M);%У��ڵ�Ȳ�С��cn_deg_min
while(E~=0)%ֱ���������
    for i=1:M
        if(E==0)%���Ѿ��������
            break;
        end
        tmp=randi([0,cn_deg_max-deg_per_row(i)]);%����һ�������������ÿһ���ϣ���ʹ�ò���������
        tmp=min(tmp,E);%ȷ�������һ��ʱ���ᳬ��ʣ��ı���
        deg_per_row(i)=deg_per_row(i)+tmp;
        E=E-tmp;
    end
end

