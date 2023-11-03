function [sigma,current_Pe]=calculate_threshold_GA(sigma_min,sigma_max,max_iter,Pe,vn_degree,vn_edge_portion,cn_degree,cn_edge_portion)%给定度分布和参数利用高斯近似计算迭代阈值(二分法)
vn_degree=vn_degree-1;
cn_degree=cn_degree-1;
Ecn= zeros(length(cn_degree), 1);
sigma_gap=sigma_max-sigma_min;

flag=0;
%判断sigma_min是否满足迭代阈值要求
Evn=2/sigma_min^2*ones(length(vn_degree), 1);%初始化变量节点从信道获取的信息Evn
for i=1:max_iter
    weighted_sum = 0;
    for k = 1 : length(vn_degree)%求和lambda_d*phi( u_l_d(v) )
        weighted_sum = weighted_sum + vn_edge_portion(k) * phi(Evn(k));
    end
    tmp = 1 - weighted_sum; 
    for k = 1 : length(cn_degree)%求出度为cn_degree(k)的校验节点输出消息的均值
        [Ecn(k), ~] = phi_inverse(1 - tmp^cn_degree(k));
    end
    Ave_CN = cn_edge_portion * Ecn;%对所有度为cn_degree的校验节点消息均值做平均
    Evn = (2/sigma_min^2 + vn_degree * Ave_CN)';%求出最终的变量节点输出信息均值
    current_Pe = vn_edge_portion * (1 - normcdf(sqrt(Evn/2)));%对不同变量节点度vn_degree的错误概率做平均
    if current_Pe < Pe%若当前错误概率小于指定错误概率，则将min_flag置1
        flag=1;
        break;
    end
end
if(flag==0)%sigma_min不满足要求
    sigma=sigma_min;
    current_Pe=1;
    return;
end

% flag=0;
% %判断sigma_max是否满足迭代阈值要求
% Evn=2/sigma_max^2*ones(length(vn_degree), 1);%初始化变量节点从信道获取的信息Evn
% for i=1:max_iter
%     weighted_sum = 0;
%     for k = 1 : length(vn_degree)%求和lambda_d*phi( u_l_d(v) )
%         weighted_sum = weighted_sum + vn_edge_portion(k) * phi(Evn(k));
%     end
%     tmp = 1 - weighted_sum; 
%     for k = 1 : length(cn_degree)%求出度为cn_degree(k)的校验节点输出消息的均值
%         [Ecn(k), ~] = phi_inverse(1 - tmp^cn_degree(k));
%     end
%     Ave_CN = cn_edge_portion * Ecn;%对所有度为cn_degree的校验节点消息均值做平均
%     Evn = (2/sigma_max^2 + vn_degree * Ave_CN)';%求出最终的变量节点输出信息均值
%     current_Pe = vn_edge_portion * (1 - normcdf(sqrt(Evn/2)));%对不同变量节点度vn_degree的错误概率做平均
%     if current_Pe < Pe%若当前错误概率小于指定错误概率，则将min_flag置1，否则置0
%         flag=1;
%         break;
%     end
% end
% if(flag==1)%sigma_max不满足要求
%     disp('please input a bigger sigma_max');
%     pause;
% end


while(sigma_gap>0.0001)%直到满足误差要求
    sigma=(sigma_min+sigma_max)/2;
    flag=0;
    %判断sigma是否满足迭代阈值要求
    Evn=2/sigma^2*ones(length(vn_degree), 1);%初始化变量节点从信道获取的信息Evn
    for i=1:max_iter
        weighted_sum = 0;
        for k = 1 : length(vn_degree)%求和lambda_d*phi( u_l_d(v) )
            weighted_sum = weighted_sum + vn_edge_portion(k) * phi(Evn(k));
        end
        tmp = 1 - weighted_sum; 
        for k = 1 : length(cn_degree)%求出度为cn_degree(k)的校验节点输出消息的均值
            [Ecn(k), ~] = phi_inverse(1 - tmp^cn_degree(k));
        end
        Ave_CN = cn_edge_portion * Ecn;%对所有度为cn_degree的校验节点消息均值做平均
        Evn = (2/sigma^2 + vn_degree * Ave_CN)';%求出最终的变量节点输出信息均值
        current_Pe = vn_edge_portion * (1 - normcdf(sqrt(Evn/2)));%对不同变量节点度vn_degree的错误概率做平均
        if current_Pe < Pe%若当前错误概率小于指定错误概率，则将min_flag置1，否则置0
            flag=1;
            break;
        end
    end
    if(flag==1)%此时sigma满足迭代阈值
        sigma_min=sigma;
    else%此时sigma不满足迭代阈值
        sigma_max=sigma;
    end
    sigma=sigma_min;%将sigma_min最为最终结果
    sigma_gap=sigma_max-sigma_min;
end














