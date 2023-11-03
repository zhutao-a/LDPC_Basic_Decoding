function [u]=ldpc_encode(s,H)
%             高斯消元
%设H=[A | B] ==========> [I | P]
%  u=[c | s]
%∵  H*u' = u*H' = 0
%代入得：
%         _    _
%         | c' |
%  [I | P]|    | = 0
%         | s' |
%         -    -
%∴I*c' + P*s' = 0
%∴I*c' = P*s' (在GF(2)上)
%∴  c' = P*s'
%G=[P'|I]
%再由u=[c | s]即可得到编码后的码字。
%如果高斯消元过程中进行了列交换，
%则只需记录列交换，并以相反次序对编码后的码字同样进行列交换即可。
%解码时先求出u1，再进行列交换得到u=[c | s]，后面部分即是想要的信息。

[P,rearranged_cols]=H2P(H);%高斯消元函数

c=mod(P*s',2);

u1=[c' s];

u=reorder_bits(u1,rearranged_cols);
