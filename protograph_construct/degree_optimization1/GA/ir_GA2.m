function [iter_mu0]=ir_GA2(sigma_n)%验证发送全-1是否也满足迭代阈值要求
global IT_MAX
global pe_limit
global var_degree
global ch_degree
global change_point
global var_index
global ch_index
change_point=10;
alpha=-0.4527;beta=0.0218;gama=0.86;Phi_star=exp(alpha*change_point^gama+beta);

iter_mu0=-1; 
var_ch=4/sigma_n^2; mu0=var_ch/2;
pe(1)=0.5*erfc(sqrt(mu0)/2);
pp(1)=pe(1); kk=var_index-1;
h_sr=Phi(mu0);mv(var_index)=mu0;
for iteration=1:IT_MAX
    if iteration>1
    mv(var_index)=mu0+kk.*muu(iteration-1);
    end
    h=Phi(mv(var_index));h_sr=var_degree(var_index)*h';
    y(ch_index)=1-(1-h_sr).^(ch_index-1);
    for j=1:length(ch_index)
      if(y(ch_index(j))<Phi_star)
       f(ch_index(j))=inv_Phi_2(y(ch_index(j)),10);
      else
      f(ch_index(j))=((log(y(ch_index(j)))-beta)/alpha)^(1/gama); 
      end
    end %j
    f_st=ch_degree*f';muu(iteration)=f_st;
    pee(var_index)=0.5*erfc(sqrt(mv(var_index))/2);   
    pe(iteration)=var_degree*pee';
    
    if (pe(iteration)<pe_limit)
iter_mu0=1; break;
    end
    if (iteration>1) &(pe(iteration)>=pe(iteration-1))
    iter_mu0=-1;
    break; 
    end
  end
  