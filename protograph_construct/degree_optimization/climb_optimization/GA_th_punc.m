function [sigma_out,final_Pe]=GA_th_punc(sigma_min,sigma_max,iter,Pe,vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop)%���ַ����������ֵ
%����puncture�ĸ�˹����
gap=sigma_max-sigma_min;%�����ʱ��gap
min_gap=0.001;%�����������Сgap

[flag,final_Pe]= GA_apprx(sigma_min,iter,Pe,vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop);%�ж���С�������Ƿ������
if(flag==0)%��С������Ҳ�������룬��ֵΪsigma_min-0.1���˳�����
    sigma_out=sigma_min-0.1;
    return;
end

while(gap>min_gap)
    sigma=(sigma_max+sigma_min)/2;%ȡ��ֵ
    [flag,final_Pe]= GA_apprx(sigma,iter,Pe,vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop);%�жϴ�ʱ�������Ƿ������
    if(flag==1)%������
        sigma_min=sigma;
    else%������Ҫ��
        sigma_max=sigma;
    end
    sigma_out=sigma_min;%ȡ��С��������Ϊ���
    gap=sigma_max-sigma_min;%�������һ�ֺ��gap
end

