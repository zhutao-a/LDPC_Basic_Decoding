function [deg_per_col,deg_per_row]=initial_degree()%��ʼ��protographÿ��ÿ�еĶ�
%%
%ȫ�ֲ���
global  N;              global  M;                
global  E0;
global  vn_deg_min;     global  vn_deg_max;
global  cn_deg_min;     global  cn_deg_max;

average_dc=floor(E0/M);
if(average_dc>=cn_deg_max)%�ж��Ƿ��������
    error('please input a smaller E0');
end
%%
%��ʼ�������ڵ�ȷֲ�
deg_per_col=vn_deg_min*ones(1,N);%ÿһ�г�ʼ��Ϊvn_deg_min
E=E0-sum(deg_per_col);%����Ҫ�����ٱ�
while(E~=0)%ֱ���������
    for i=1:N
        if(E==0)%���Ѿ��������
            break;
        end
        tmp=randi([0,vn_deg_max-deg_per_col(i)]);%����һ�������������ÿһ���ϲ�ʹ�ò�����vn_deg_max
        tmp=min(tmp,E);%ȷ�������һ��ʱ���ᳬ��ʣ��ı���
        deg_per_col(i)=deg_per_col(i)+tmp;
        E=E-tmp;
    end
end
%%
%��ʼ��У��ڵ�ȷֲ�
deg_per_row=cn_deg_min*ones(1,M);%ÿһ�жȳ�ʼ��Ϊcn_deg_min
E=E0-cn_deg_min*M;%����Ҫ�����ٱ�
while(E~=0)%ֱ���������
    for i=1:M
        if(E==0)%���Ѿ��������
            break;
        end
        tmp=randi([0,cn_deg_max-deg_per_row(i)]);%����һ�������������ÿһ���ϲ�ʹ�ò�����cn_deg_max
        tmp=min(tmp,E);%ȷ�������һ��ʱ���ᳬ��ʣ��ı���
        deg_per_row(i)=deg_per_row(i)+tmp;
        E=E-tmp;
    end
end

