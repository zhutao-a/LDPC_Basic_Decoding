function [vn_degree,vn_edge_portion,cn_degree,cn_edge_portion]=degree_distribution(degree_per_col,degree_per_row)%ͨ��ÿ��ÿ�еĶȼ�����ȷֲ�
%������ܱ���
E=sum(degree_per_col);
%����������ڵ㺬�еĲ�ͬ��С�Ķ�
vn_degree=unique(degree_per_col);
%����������ڵ�ĳһ�Ȱ����ı�ռ�ܱ����ı���
vn_edge_portion=zeros(1,length(vn_degree));
for i=1:length(vn_degree)
    vn_degree_num=sum(degree_per_col==vn_degree(i));
    vn_edge_portion(i)=vn_degree_num*vn_degree(i)/E;
end
%�����У��ڵ㺬�еĲ�ͬ��С�Ķ�
cn_degree=unique(degree_per_row);
%�����У��ڵ�ĳһ�Ȱ����ı�ռ�ܱ����ı���
cn_edge_portion=zeros(1,length(cn_degree));
for i=1:length(cn_degree)
    cn_degree_num=sum(degree_per_row==cn_degree(i));
    cn_edge_portion(i)=cn_degree_num*cn_degree(i)/E;
end

