function [ecode,ram]=mix_encoder(ram,ldpc_c,H1,H2_T_inv,bch_c)
%bch_c的大小为111*1144,ldpc_c的大小为128*832,ram的大小为128*2288,ecode的大小为128*2288
ecode=zeros(128,2288);
for i=1:1144
    temp=lfsr_encoder([ram(:,i+1144);bch_c(:,i)]');
    ecode(:,i)=temp(129:256)';
end
ecode(:,1145:1976)=ldpc_c;

for i=1:128
    ecode(i,:)=encoder_ldpc(ecode(i,1:1976),H1,H2_T_inv);
end

ram=ecode;







