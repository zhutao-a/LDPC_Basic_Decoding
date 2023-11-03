function [d_code,d_ram]=mix_decoder(d_ram,n_code,N0,H1,H2,alpha,gf_table,t)
%d_ram的大小为128*2288,n_code的大小为128*2288,d_code的大小为128*2288
%bch译码
for i=1:1144
    [~,w]=r_decoder( [d_ram(:,i+1144),n_code(:,i)]' ,gf_table,t);
    W_R_r=[d_ram(:,i+1144);n_code(:,i)]'+alpha*w;%计算软信息
    d_ram(:,i+1144)=W_R_r(1:128)';
    n_code(:,i)=W_R_r(129:256)';
end
%译码输出
d_code=d_ram;
%ldpc译码
for i=1:128
    n_code(i,:)= MS_decoder1(n_code(i,:),N0, [H1,H2]);
end
%d_ram存储新进来的数据
d_ram=n_code;



