function [sigma,current_Pe]=calculate_threshold_GA(sigma_min,sigma_max,max_iter,Pe,vn_degree,vn_edge_portion,cn_degree,cn_edge_portion)%�����ȷֲ��Ͳ������ø�˹���Ƽ��������ֵ(���ַ�)
vn_degree=vn_degree-1;
cn_degree=cn_degree-1;
Ecn= zeros(length(cn_degree), 1);
sigma_gap=sigma_max-sigma_min;

flag=0;
%�ж�sigma_min�Ƿ����������ֵҪ��
Evn=2/sigma_min^2*ones(length(vn_degree), 1);%��ʼ�������ڵ���ŵ���ȡ����ϢEvn
for i=1:max_iter
    weighted_sum = 0;
    for k = 1 : length(vn_degree)%���lambda_d*phi( u_l_d(v) )
        weighted_sum = weighted_sum + vn_edge_portion(k) * phi(Evn(k));
    end
    tmp = 1 - weighted_sum; 
    for k = 1 : length(cn_degree)%�����Ϊcn_degree(k)��У��ڵ������Ϣ�ľ�ֵ
        [Ecn(k), ~] = phi_inverse(1 - tmp^cn_degree(k));
    end
    Ave_CN = cn_edge_portion * Ecn;%�����ж�Ϊcn_degree��У��ڵ���Ϣ��ֵ��ƽ��
    Evn = (2/sigma_min^2 + vn_degree * Ave_CN)';%������յı����ڵ������Ϣ��ֵ
    current_Pe = vn_edge_portion * (1 - normcdf(sqrt(Evn/2)));%�Բ�ͬ�����ڵ��vn_degree�Ĵ��������ƽ��
    if current_Pe < Pe%����ǰ�������С��ָ��������ʣ���min_flag��1
        flag=1;
        break;
    end
end
if(flag==0)%sigma_min������Ҫ��
    sigma=sigma_min;
    current_Pe=1;
    return;
end

% flag=0;
% %�ж�sigma_max�Ƿ����������ֵҪ��
% Evn=2/sigma_max^2*ones(length(vn_degree), 1);%��ʼ�������ڵ���ŵ���ȡ����ϢEvn
% for i=1:max_iter
%     weighted_sum = 0;
%     for k = 1 : length(vn_degree)%���lambda_d*phi( u_l_d(v) )
%         weighted_sum = weighted_sum + vn_edge_portion(k) * phi(Evn(k));
%     end
%     tmp = 1 - weighted_sum; 
%     for k = 1 : length(cn_degree)%�����Ϊcn_degree(k)��У��ڵ������Ϣ�ľ�ֵ
%         [Ecn(k), ~] = phi_inverse(1 - tmp^cn_degree(k));
%     end
%     Ave_CN = cn_edge_portion * Ecn;%�����ж�Ϊcn_degree��У��ڵ���Ϣ��ֵ��ƽ��
%     Evn = (2/sigma_max^2 + vn_degree * Ave_CN)';%������յı����ڵ������Ϣ��ֵ
%     current_Pe = vn_edge_portion * (1 - normcdf(sqrt(Evn/2)));%�Բ�ͬ�����ڵ��vn_degree�Ĵ��������ƽ��
%     if current_Pe < Pe%����ǰ�������С��ָ��������ʣ���min_flag��1��������0
%         flag=1;
%         break;
%     end
% end
% if(flag==1)%sigma_max������Ҫ��
%     disp('please input a bigger sigma_max');
%     pause;
% end


while(sigma_gap>0.0001)%ֱ���������Ҫ��
    sigma=(sigma_min+sigma_max)/2;
    flag=0;
    %�ж�sigma�Ƿ����������ֵҪ��
    Evn=2/sigma^2*ones(length(vn_degree), 1);%��ʼ�������ڵ���ŵ���ȡ����ϢEvn
    for i=1:max_iter
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
        if current_Pe < Pe%����ǰ�������С��ָ��������ʣ���min_flag��1��������0
            flag=1;
            break;
        end
    end
    if(flag==1)%��ʱsigma���������ֵ
        sigma_min=sigma;
    else%��ʱsigma�����������ֵ
        sigma_max=sigma;
    end
    sigma=sigma_min;%��sigma_min��Ϊ���ս��
    sigma_gap=sigma_max-sigma_min;
end














