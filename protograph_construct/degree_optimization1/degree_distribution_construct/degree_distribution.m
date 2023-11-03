function [vn_degree,vn_edge_portion,cn_degree,cn_edge_portion]=degree_distribution(degree_per_col,degree_per_row)%通过每行每列的度计算出度分布
%计算出总边数
E=sum(degree_per_col);
%计算出变量节点含有的不同大小的度
vn_degree=unique(degree_per_col);
%计算出变量节点某一度包含的边占总边数的比例
vn_edge_portion=zeros(1,length(vn_degree));
for i=1:length(vn_degree)
    vn_degree_num=sum(degree_per_col==vn_degree(i));
    vn_edge_portion(i)=vn_degree_num*vn_degree(i)/E;
end
%计算出校验节点含有的不同大小的度
cn_degree=unique(degree_per_row);
%计算出校验节点某一度包含的边占总边数的比例
cn_edge_portion=zeros(1,length(cn_degree));
for i=1:length(cn_degree)
    cn_degree_num=sum(degree_per_row==cn_degree(i));
    cn_edge_portion(i)=cn_degree_num*cn_degree(i)/E;
end

