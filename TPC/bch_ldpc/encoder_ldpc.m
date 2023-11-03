function c_data = encoder_ldpc(u_data,H1,H2_T_inv)
%p=uH1H2',根据信息位求出校验位
r= mod(u_data*H1', 2);   
p= mod(r*H2_T_inv, 2);
c_data = [u_data, p] ;          %拼接为最终的码字




