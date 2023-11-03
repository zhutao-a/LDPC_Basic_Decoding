function [sigma,EBN0]=calculate_threshold_GA(sigma,sigma_inc,max_iter,Pe,Rate,vn_degree,vn_edge_portion,cn_degree,cn_edge_portion)%给定度分布和参数利用高斯近似计算迭代阈值
vn_degree=vn_degree-1;
cn_degree=cn_degree-1;
Ecn = zeros(length(cn_degree), 1);
Evn = zeros(length(vn_degree), 1);
iter = 1;
while(iter <= max_iter)
    if iter == 1
        for k = 1 : length(cn_degree)%求出度为cn_degree(k)的校验节点输出消息的均值
            [Ecn(k), ~] = phi_inverse(1 - (1 - phi(2/sigma^2))^cn_degree(k));
        end
        Ave_CN = cn_edge_portion * Ecn;%对所有度为cn_degree的校验节点消息均值做平均
        Evn = (2/sigma^2 + vn_degree * Ave_CN)';%求出最终的变量节点输出信息均值
        current_Pe = vn_edge_portion * (1 - normcdf(sqrt(Evn/2)));%对不同变量节点度vn_degree的错误概率做平均
        if current_Pe < Pe%若当前错误概率小于指定错误概率，则增大噪声sigma
            sigma = sigma + sigma_inc;
            iter = 1;
        else%否则的话进行下一轮迭代
            iter = iter + 1;
        end
    else
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
        if current_Pe < Pe%若当前错误概率小于指定错误概率，则增大噪声sigma
            sigma = sigma + sigma_inc;
            iter = 1;
        else%否则的话进行下一轮迭代
            iter = iter + 1;
        end
    end
    if iter > max_iter
        disp(['Gaussian Approximation is finished. The threshold sigma = ' num2str(sigma - sigma_inc)]);
        sigma=sigma - sigma_inc;
        ebn0=1/(2*Rate*sigma^2);
        EBN0=10*log10(ebn0);
        disp(['The threshold EBN0 = ' num2str(EBN0)]);
    end
end






