function [sigma,EBN0]=calculate_threshold_GA(sigma,sigma_inc,max_iter,Pe,Rate,vn_degree,vn_edge_portion,cn_degree,cn_edge_portion)%�����ȷֲ��Ͳ������ø�˹���Ƽ��������ֵ
vn_degree=vn_degree-1;
cn_degree=cn_degree-1;
Ecn = zeros(length(cn_degree), 1);
Evn = zeros(length(vn_degree), 1);
iter = 1;
while(iter <= max_iter)
    if iter == 1
        for k = 1 : length(cn_degree)%�����Ϊcn_degree(k)��У��ڵ������Ϣ�ľ�ֵ
            [Ecn(k), ~] = phi_inverse(1 - (1 - phi(2/sigma^2))^cn_degree(k));
        end
        Ave_CN = cn_edge_portion * Ecn;%�����ж�Ϊcn_degree��У��ڵ���Ϣ��ֵ��ƽ��
        Evn = (2/sigma^2 + vn_degree * Ave_CN)';%������յı����ڵ������Ϣ��ֵ
        current_Pe = vn_edge_portion * (1 - normcdf(sqrt(Evn/2)));%�Բ�ͬ�����ڵ��vn_degree�Ĵ��������ƽ��
        if current_Pe < Pe%����ǰ�������С��ָ��������ʣ�����������sigma
            sigma = sigma + sigma_inc;
            iter = 1;
        else%����Ļ�������һ�ֵ���
            iter = iter + 1;
        end
    else
        weighted_sum = 0;
        for k = 1 : length(vn_degree)%���lambda_d*phi( u_l_d(v) )
            weighted_sum = weighted_sum + vn_edge_portion(k) * phi(Evn(k));
        end
        tmp = 1 - weighted_sum; 
        for k = 1 : length(cn_degree)%�����Ϊcn_degree(k)��У��ڵ������Ϣ�ľ�ֵ
            [Ecn(k), ~] = phi_inverse(1 - tmp^cn_degree(k));
        end
        Ave_CN = cn_edge_portion * Ecn;%�����ж�Ϊcn_degree��У��ڵ���Ϣ��ֵ��ƽ��
        Evn = (2/sigma^2 + vn_degree * Ave_CN)';%������յı����ڵ������Ϣ��ֵ
        current_Pe = vn_edge_portion * (1 - normcdf(sqrt(Evn/2)));%�Բ�ͬ�����ڵ��vn_degree�Ĵ��������ƽ��
        if current_Pe < Pe%����ǰ�������С��ָ��������ʣ�����������sigma
            sigma = sigma + sigma_inc;
            iter = 1;
        else%����Ļ�������һ�ֵ���
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






