function [vn_deg,vn_deg_prop,cn_deg,cn_deg_prop,punc_deg,punc_prop]=degree_distribution(vn_deg_num,cn_deg_num)
%%
%全局参数
global  punc_len;           
global  E0;
global  vn_deg_full;
global  cn_deg_full;
%%
%将vn_deg_num和cn_deg_num0元素部分去掉,以便用于GA
nozero_index=find(vn_deg_num~=0);
vn_deg=zeros(1,length(nozero_index));
vn_deg_n=zeros(1,length(nozero_index));
vn_deg_prop=zeros(1,length(nozero_index));
for i=1:length(nozero_index)
    vn_deg(i)=vn_deg_full(nozero_index(i));
    vn_deg_n(i)=vn_deg_num(nozero_index(i));
    vn_deg_prop(i)=vn_deg(i)*vn_deg_n(i)/E0;
end
nozero_index=find(cn_deg_num~=0);
cn_deg=zeros(1,length(nozero_index));
cn_deg_prop=zeros(1,length(nozero_index));
for i=1:length(nozero_index)
    cn_deg(i)=cn_deg_full(nozero_index(i));
    cn_deg_prop(i)=cn_deg(i)*cn_deg_num(nozero_index(i))/E0;
end
%%
%将变量节点度最大的punc_len列进行puncture处理
for i=1:length(vn_deg_n)
    if(sum(vn_deg_n(end-i+1:end))>=punc_len)
        punc_deg_len=i;
        break;
    end
end

punc_deg=vn_deg(end-punc_deg_len+1:end);
punc_prop=ones(1,punc_deg_len);
punc_prop(1)=(punc_len-sum(vn_deg_n(end-punc_deg_len+2:end)))/vn_deg_n(end-punc_deg_len+1);

