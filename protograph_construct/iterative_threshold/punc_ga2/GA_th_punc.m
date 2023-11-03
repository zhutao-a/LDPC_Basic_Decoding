function [sigma_out,final_Pe]=GA_th_punc(sigma_min,sigma_max,iter,Pe,deg_per_col,deg_per_row,punc_idx)
%���ַ����������ֵ
%����puncture�ĸ�˹����
gap=sigma_max-sigma_min;%�����ʱ��gap
min_gap=0.00001;%�����������Сgap
%�ж���С�������Ƿ������
[flag,final_Pe]=GA_apprx(sigma_min,iter,Pe,deg_per_col,deg_per_row,punc_idx);
if(flag==0)%��С������Ҳ�������룬��ֵΪsigma_min-0.1���˳�����
    sigma_out=sigma_min-0.1;
    return;
end

while(gap>min_gap)
    sigma=(sigma_max+sigma_min)/2;%ȡ��ֵ
    %�жϴ�ʱ�������Ƿ������
    [flag,final_Pe]=GA_apprx(sigma_min,iter,Pe,deg_per_col,deg_per_row,punc_idx);
    if(flag==1)%������
        sigma_min=sigma;
    else%������Ҫ��
        sigma_max=sigma;
    end
    sigma_out=sigma_min;%ȡ��С��������Ϊ���
    gap=sigma_max-sigma_min;%�������һ�ֺ��gap
end


