function [flag,final_Pe]= GA_apprx(sigma,iter,Pe,deg_per_col,deg_per_row,punc_idx)
[vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop]=deg_distr(deg_per_col,deg_per_row,punc_idx);

vn_deg_len=length(vn_deg);
cn_deg_len=length(cn_deg);
Ecn= zeros(1,cn_deg_len);
punc_deg_len=length(punc_deg);

vn_message=2/sigma^2*ones(1,length(deg_per_col));
vn_message(punc_idx)=0;

Evn0=2/sigma^2*ones(1,vn_deg_len);%初始化变量节点从信道获取的信息Evn0(没被puncture时)
for i=1:punc_deg_len%puncture后的变量节点信息
    for j=1:vn_deg_len
        if(punc_deg(i)==vn_deg(j))%vn_deg(j)的一部分被puncture掉了
            Evn0(j)=(1-punc_prop(i))*Evn0(j);%对被puncture掉的部分取平均
        end
    end
end
Evn=Evn0;
vn_deg=vn_deg-1;
cn_deg=cn_deg-1;
%flag=1表示可译码，否则表示不可译码
flag=0;
for i=1:iter
    weighted_sum = 0;
    for k = 1 : vn_deg_len%求和lambda_d*phi( u_l_d(v) )(参考信道编码经典与现代中的符号表示)
        weighted_sum = weighted_sum + vn_edge_prop(k) * phi(Evn(k));
    end
    tmp = 1 - weighted_sum; 
    for k = 1 : cn_deg_len%求出度为cn_degree(k)的校验节点输出消息的均值
        [Ecn(k), ~] = phi_inverse(1 - tmp^cn_deg(k));
    end
    Ave_CN = sum(cn_edge_prop .* Ecn);%对所有度为cn_degree的校验节点消息均值做平均
    Evn = Evn0 + vn_deg * Ave_CN;%求出最终的变量节点输出信息均值
    for j=1:length(deg_per_col)
        vn_message(j)=vn_message(j)+(deg_per_col(j)-1)*Ave_CN;
    end
    final_Pe = max(1 - normcdf(sqrt(vn_message/2)));
    if(final_Pe < Pe)%若当前错误概率小于指定错误概率，flag=1
        flag=1;
        break;
    end
end













