function [vn_deg_num,cn_deg_num,sigma,Pe]=variant_iteration(vn_deg_num,cn_deg_num,sigma,Pe)%ͻ�����
[m_vn_deg_num,m_cn_deg_num]=generate_variant(vn_deg_num,cn_deg_num,2);%ͻ��õ��������
[m_sigma,m_Pe]=population_fitness(m_vn_deg_num,m_cn_deg_num);%����ͻ����Ⱥ����Ӧ��
sigma_best=max(m_sigma);
sigma_best_index=find(m_sigma==sigma_best);
[Pe_best,index]=min(m_Pe(sigma_best_index));
if( (sigma_best>sigma) || ( (sigma_best==sigma) && (Pe_best<=Pe) ) )%ͻ��������ԭ�ȸ���
    vn_deg_num=m_vn_deg_num(sigma_best_index(index),:);
    cn_deg_num=m_cn_deg_num(sigma_best_index(index),:);
    sigma=m_sigma(sigma_best_index(index));
    Pe=m_Pe(sigma_best_index(index));
end

