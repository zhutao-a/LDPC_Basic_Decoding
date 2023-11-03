function [flag,final_Pe]= GA_apprx(sigma,iter,Pe,vn_deg,vn_edge_prop,cn_deg,cn_edge_prop)%给定sigma判断是否可译码
vn_deg=vn_deg-1;
cn_deg=cn_deg-1;
%flag=1表示可译码，否则表示不可译码
flag=0;
vn_deg_len=length(vn_deg);
cn_deg_len=length(cn_deg);
Ecn= zeros(cn_deg_len, 1);
Evn=2/sigma^2*ones(vn_deg_len, 1);%初始化变量节点从信道获取的信息Evn
for i=1:iter
    weighted_sum = 0;
    for k = 1 : vn_deg_len%求和lambda_d*phi( u_l_d(v) )(参考信道编码经典与现代中的符号表示)
        weighted_sum = weighted_sum + vn_edge_prop(k) * phi(Evn(k));
    end
    tmp = 1 - weighted_sum; 
    for k = 1 : cn_deg_len%求出度为cn_degree(k)的校验节点输出消息的均值
        [Ecn(k), ~] = phi_inverse(1 - tmp^cn_deg(k));
    end
    Ave_CN = cn_edge_prop * Ecn;%对所有度为cn_degree的校验节点消息均值做平均
    Evn = (2/sigma^2 + vn_deg * Ave_CN)';%求出最终的变量节点输出信息均值
    final_Pe = vn_edge_prop * (1 - normcdf(sqrt(Evn/2)));%对不同变量节点度vn_degree的错误概率做平均
    if(final_Pe < Pe)%若当前错误概率小于指定错误概率，flag=1
        flag=1;
        break;
    end
end















