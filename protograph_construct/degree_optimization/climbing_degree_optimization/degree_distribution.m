function [vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop]=degree_distribution(deg_per_col,deg_per_row)
%通过每行每列的度计算出度分布
global  punc_len;           
global  E0;
%%
%计算出变量节点含有的不同大小的度
vn_deg=sort(unique(deg_per_col),'ascend');
%计算出变量节点某一度包含的边占总边数的比例
vn_edge_prop=zeros(1,length(vn_deg));
vn_deg_num=zeros(1,length(vn_deg));
for i=1:length(vn_deg)
    vn_deg_num(i)=sum(deg_per_col==vn_deg(i));
    vn_edge_prop(i)=vn_deg_num(i)*vn_deg(i)/E0;
end
%%
%计算出校验节点含有的不同大小的度
cn_deg=sort(unique(deg_per_row),'ascend');
%计算出校验节点某一度包含的边占总边数的比例
cn_edge_prop=zeros(1,length(cn_deg));
for i=1:length(cn_deg)
    cn_deg_num=sum(deg_per_row==cn_deg(i));
    cn_edge_prop(i)=cn_deg_num*cn_deg(i)/E0;
end
%%
%将变量节点度最大的punc_len列进行puncture处理
% for i=1:length(vn_deg_num)
%     if(sum(vn_deg_num(end-i+1:end))>=punc_len)
%         punc_deg_len=i;
%         break;
%     end
% end
% punc_deg=vn_deg(end-punc_deg_len+1:end);
% punc_prop=ones(1,punc_deg_len);
% punc_prop(1)=(punc_len-sum(vn_deg_num(end-punc_deg_len+2:end)))/vn_deg_num(end-punc_deg_len+1);


punc_col_deg=deg_per_col(1:punc_len);%找出被puncture的列的度
punc_deg=unique(punc_col_deg);%被puncture掉的列含有度的种类数
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

