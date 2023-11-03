function [d_msg,msg_ram]=encoder(msg,msg_ram)
%msg的大小为128*111，msg_ram的大小为128*128，d_msg的大小为128*128
W_R_r=zeros(128,256);
W_R_r(:,1:128)=rot90(msg_ram,1);%逆时针旋转 90 度
W_R_r(:,129:239)=msg;
for i=1:128
    temp=W_R_r(i,1:239);
    W_R_r(i,:)=lfsr_encoder(temp);
end
msg_ram=W_R_r(:,129:256);
d_msg=W_R_r(:,129:256);

