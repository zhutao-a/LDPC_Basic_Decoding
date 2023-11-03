function d_msg=mix_encoder(msg,H1,H2_T_inv)
%msg��СΪ237*1976,d_msg��СΪ256*2288
d_msg=zeros(256,2288);
%bch����
for i=1:1976
    temp=lfsr_encoder(msg(:,i)');
    d_msg(:,i)=temp';
end
%ldpc����
for i=1:256
    d_msg(i,:)=encoder_ldpc(d_msg(i,1:1976),H1,H2_T_inv);
end








