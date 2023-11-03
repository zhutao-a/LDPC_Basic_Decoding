function [pop_sigma,pop_Pe]=population_fitness(pop_deg_per_col,pop_deg_per_row)%������Ⱥ����Ӧ��
%%
%ȫ�ֲ���
global NP;
global Pe;  
global iter;   
global sigma_min;   
global sigma_max;
%%
%ͨ���ȷֲ����������ֵ�ʹ������
pop_sigma=zeros(NP,1);
pop_Pe=zeros(NP,1);
for i=1:NP
    %ͨ��ÿ��ÿ�еĶȼ�����ȷֲ�,ͬʱ����puncture���Ķ��Լ�����
    [vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop]=degree_distribution(pop_deg_per_col(i,:),pop_deg_per_row(i,:));
    %���ַ����������ֵ
    [pop_sigma(i),pop_Pe(i)]=GA_threshold_punc(sigma_min,sigma_max,iter,Pe,vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop);
end



