function [var_index_out]=search_index(var_index0,fixed_Rate)%�ҳ������ʼ����������õĶȷֲ�
global var_degree
global var_index
global ch_degree
global ch_index
[M,N]=size(var_index0);sigma_n=0.2;
degree=rand(1,N);var_index=var_index0(1,:);var_degree=[];var_degree(var_index)=degree/sum(degree);%����һ����6����ͬ�ȵĶ�ֵ�Ͷȷֲ�������Ϊ20��
[ch_degree,ch_index,dc_av]=rate_redress2(var_degree(var_index),fixed_Rate,var_index);%ͨ��1��������Լ����ϵ���ñ����ڵ�ȷֲ����һ����2����ͬ�ȵ�У��ڵ�ȷֲ�
sigma_PRECISION=0.1;
[sigma_n]=ir_GA(sigma_n,sigma_PRECISION,4);%���ø�˹���������ʼ���Ķȷֲ��ĵ�����ֵ�������
for loop=1:10
    for i=2:M%���þ��ȷֲ�������
      degree=rand(1,N);
      var_degree=[];var_degree(var_index)=degree/sum(degree);var_index=var_index0(i,:);
      [ch_degree,ch_index,dc_av]=rate_redress2(var_degree(var_index),fixed_Rate,var_index);
      sigma_n2=sigma_n+0.0001;
      iter_mu0=ir_GA2(sigma_n2);%��֤����ȫ-1�Ƿ�Ҳ���������ֵҪ��
      if iter_mu0==1
          sigma_PRECISION=0.1;
          [sigma_n]=ir_GA(sigma_n,sigma_PRECISION,5);%���ø�˹���������ʼ���Ķȷֲ��ĵ�����ֵ�������
          var_index_out=var_index;
      end
    end
    for i=2:M%���ø�˹�ֲ�������
      degree=abs(randn(1,N));
      var_degree=[];var_degree(var_index)=degree/sum(degree);var_index=var_index0(i,:);
      [ch_degree,ch_index,dc_av]=rate_redress2(var_degree(var_index),fixed_Rate,var_index);
      sigma_n2=sigma_n+0.0001;
      iter_mu0=ir_GA2(sigma_n2);
      if iter_mu0==1
          sigma_PRECISION=0.1;
          [sigma_n]=ir_GA(sigma_n,sigma_PRECISION,5);
          var_index_out=var_index;
      end
    end
end
