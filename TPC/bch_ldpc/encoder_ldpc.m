function c_data = encoder_ldpc(u_data,H1,H2_T_inv)
%p=uH1H2',������Ϣλ���У��λ
r= mod(u_data*H1', 2);   
p= mod(r*H2_T_inv, 2);
c_data = [u_data, p] ;          %ƴ��Ϊ���յ�����




