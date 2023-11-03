function [pop_sigma,pop_Pe]=population_fitness(pop_vn_deg_num,pop_cn_deg_num)%������Ⱥ����Ӧ��
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
    [vn_deg,vn_deg_prop,cn_deg,cn_deg_prop,punc_deg,punc_prop]=degree_distribution(pop_vn_deg_num(i,:),pop_cn_deg_num(i,:));
    %���ַ����������ֵ
    [pop_sigma(i),pop_Pe(i)]=GA_th_punc(sigma_min,sigma_max,iter,Pe,vn_deg,vn_deg_prop,cn_deg,cn_deg_prop,punc_deg,punc_prop);
end



