function [decision_codeword,data_out,data_ram]=decoder(data_ram,new_data,alpha,gf_table,t)
%new_data的大小为128*128，data_ram的大小为128*128，data_out的大小为128*128
W_R_r=zeros(128,256);
decision_codeword=zeros(128,128);

W_R_r(:,1:128)=rot90(data_ram,1);%逆时针旋转 90 度
W_R_r(:,129:256)=new_data;

for i=1:128
    [codeword,w]=r_decoder(W_R_r(i,:),gf_table,t);
    decision_codeword(i,:)=codeword(1:128);%后128比特作为输出
    W_R_r(i,:)=W_R_r(i,:)+alpha*w;%计算软信息
end
data_ram=W_R_r(:,129:256);
decision_codeword=rot90(decision_codeword,-1);
data_out=rot90(W_R_r(:,1:128),-1);



