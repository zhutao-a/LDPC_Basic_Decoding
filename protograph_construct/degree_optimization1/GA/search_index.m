function [var_index_out]=search_index(var_index0,fixed_Rate)%找出随机初始化中性能最好的度分布
global var_degree
global var_index
global ch_degree
global ch_index
[M,N]=size(var_index0);sigma_n=0.2;
degree=rand(1,N);var_index=var_index0(1,:);var_degree=[];var_degree(var_index)=degree/sum(degree);%产生一个含6个不同度的度值和度分布（最大度为20）
[ch_degree,ch_index,dc_av]=rate_redress2(var_degree(var_index),fixed_Rate,var_index);%通过1的总数的约束关系利用变量节点度分布求出一个含2个不同度的校验节点度分布
sigma_PRECISION=0.1;
[sigma_n]=ir_GA(sigma_n,sigma_PRECISION,4);%利用高斯近似求出初始化的度分布的迭代阈值的信噪比
for loop=1:10
    for i=2:M%利用均匀分布产生度
      degree=rand(1,N);
      var_degree=[];var_degree(var_index)=degree/sum(degree);var_index=var_index0(i,:);
      [ch_degree,ch_index,dc_av]=rate_redress2(var_degree(var_index),fixed_Rate,var_index);
      sigma_n2=sigma_n+0.0001;
      iter_mu0=ir_GA2(sigma_n2);%验证发送全-1是否也满足迭代阈值要求
      if iter_mu0==1
          sigma_PRECISION=0.1;
          [sigma_n]=ir_GA(sigma_n,sigma_PRECISION,5);%利用高斯近似求出初始化的度分布的迭代阈值的信噪比
          var_index_out=var_index;
      end
    end
    for i=2:M%利用高斯分布产生度
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
