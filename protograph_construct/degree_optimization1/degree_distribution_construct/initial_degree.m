function [degree_per_col,degree_per_row]=initial_degree(N,M,average_dc,vn_degree_max,cn_degree_max)
%average_dc��Ҫ����15.0588
if(average_dc>cn_degree_max||average_dc<22.588)
    average_dc=28.612;
end
%����ܱ���
E=floor(average_dc*M);
%�������ֲ�ͬ�ȵ�У��ڵ�
degree_per_row=floor(E/M)*ones(1,M);%����ƽ���ֲ���ÿ��
%����ı�ƽ����������Žϴ����
remained=E-M*floor(E/M);
degree_per_row(end-remained+1:end)=degree_per_row(end-remained+1:end)+1;
E=E-2*N;%ÿ�������ڵ������Ϊ2
degree_per_col=2*ones(1,N);%�����ڵ�Ȳ�С��2
for i=1:N
    if(E==0)%���Ѿ��������
        break;
    end
    tmp=randi([0,vn_degree_max-2]);%����һ�������������ÿһ���ϣ���ʹ�ò���������
    tmp=min(tmp,E);%ȷ�������һ��ʱ���ᳬ��ʣ��ı���
    degree_per_col(i)=degree_per_col(i)+tmp;
    E=E-tmp;
end


