%基于高斯消去的编码
function [code,P,rearranged_cols]=ldpc_encode(s,H)
%             高斯消元
%设H=[A | B] ==========> [I | P]
%  code=[c | s]
%∵  H*code' = code*H' = 0
%代入得：
%         _    _
%         | c' |
%  [I | P]|    | = 0
%         | s' |
%         -    -
%∴I*c' + P*s' = 0
%∴I*c' = P*s' (在GF(2)上)
%∴  c' = P*s'
%再由u=[c | s]即可得到编码后的码字。
%如果高斯消元过程中进行了列交换，
%则只需记录列交换，并以相反次序对编码后的码字同样进行列交换即可。
%解码时先求出code1，再进行列交换得到code=[c | s]，后面部分即是想要的信息。

dim=size(H);
rows=dim(1);
cols=dim(2);

[P,rearranged_cols]=H2P(H);
c=mul_GF2(P,s');
code1=[c' s];                              %码字前面为校验位，后面为信息位

code=reorder_bits(code1,rearranged_cols);  %将码字进行位变化，输出可以直接通过H进行校验
