function [u]=ldpc_encode_G(s,P,rearranged_cols)

c=mod(P*s',2);
u1=[c' s];
u=reorder_bits(u1,rearranged_cols);