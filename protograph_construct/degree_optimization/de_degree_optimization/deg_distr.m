function [vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop]=deg_distr(deg_per_col,deg_per_row,punc_idx)%ͨ��ÿ��ÿ�еĶȼ�����ȷֲ�
%������ܱ���
E=sum(deg_per_col);
%����������ڵ㺬�еĲ�ͬ��С�Ķ�
vn_deg=unique(deg_per_col);
%����������ڵ�ĳһ�Ȱ����ı�ռ�ܱ����ı���
vn_edge_prop=zeros(1,length(vn_deg));
vn_deg_num=zeros(1,length(vn_deg));
for i=1:length(vn_deg)
    vn_deg_num(i)=sum(deg_per_col==vn_deg(i));
    vn_edge_prop(i)=vn_deg_num(i)*vn_deg(i)/E;
end
%�����У��ڵ㺬�еĲ�ͬ��С�Ķ�
cn_deg=unique(deg_per_row);
%�����У��ڵ�ĳһ�Ȱ����ı�ռ�ܱ����ı���
cn_edge_prop=zeros(1,length(cn_deg));
for i=1:length(cn_deg)
    cn_deg_num=sum(deg_per_row==cn_deg(i));
    cn_edge_prop(i)=cn_deg_num*cn_deg(i)/E;
end

punc_col_deg=deg_per_col(punc_idx);%�ҳ���puncture���еĶ�
punc_deg=unique(punc_col_deg);%��puncture�����к��жȵ�������
punc_deg_num=zeros(1,length(punc_deg));
for i=1:length(punc_deg)
    punc_deg_num(i)=sum(punc_col_deg==punc_deg(i));
end
punc_prop=zeros(1,length(punc_deg));
for i=1:length(punc_deg)
    for j=1:length(vn_deg)
        if(vn_deg(j)==punc_deg(i))
            punc_prop(i)=punc_deg_num(i)/vn_deg_num(j);
        end
    end
end



