function [d_code,d_ram]=mix_decoder(d_ram,n_code,N0,H1,H2,alpha,gf_table,t)
%d_ram�Ĵ�СΪ128*2288,n_code�Ĵ�СΪ128*2288,d_code�Ĵ�СΪ128*2288
%bch����
for i=1:1144
    [~,w]=r_decoder( [d_ram(:,i+1144),n_code(:,i)]' ,gf_table,t);
    W_R_r=[d_ram(:,i+1144);n_code(:,i)]'+alpha*w;%��������Ϣ
    d_ram(:,i+1144)=W_R_r(1:128)';
    n_code(:,i)=W_R_r(129:256)';
end
%�������
d_code=d_ram;
%ldpc����
for i=1:128
    n_code(i,:)= MS_decoder1(n_code(i,:),N0, [H1,H2]);
end
%d_ram�洢�½���������
d_ram=n_code;



