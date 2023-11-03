%���ڸ�˹��ȥ�ı���
function [code,P,rearranged_cols]=ldpc_encode(s,H)
%             ��˹��Ԫ
%��H=[A | B] ==========> [I | P]
%  code=[c | s]
%��  H*code' = code*H' = 0
%����ã�
%         _    _
%         | c' |
%  [I | P]|    | = 0
%         | s' |
%         -    -
%��I*c' + P*s' = 0
%��I*c' = P*s' (��GF(2)��)
%��  c' = P*s'
%����u=[c | s]���ɵõ����������֡�
%�����˹��Ԫ�����н������н�����
%��ֻ���¼�н����������෴����Ա���������ͬ�������н������ɡ�
%����ʱ�����code1���ٽ����н����õ�code=[c | s]�����沿�ּ�����Ҫ����Ϣ��

dim=size(H);
rows=dim(1);
cols=dim(2);

[P,rearranged_cols]=H2P(H);
c=mul_GF2(P,s');
code1=[c' s];                              %����ǰ��ΪУ��λ������Ϊ��Ϣλ

code=reorder_bits(code1,rearranged_cols);  %�����ֽ���λ�仯���������ֱ��ͨ��H����У��
