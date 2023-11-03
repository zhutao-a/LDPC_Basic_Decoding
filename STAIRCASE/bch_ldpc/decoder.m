function [decision_codeword,data_out,data_ram]=decoder(data_ram,new_data,alpha,gf_table,t)
%new_data�Ĵ�СΪ128*128��data_ram�Ĵ�СΪ128*128��data_out�Ĵ�СΪ128*128
W_R_r=zeros(128,256);
decision_codeword=zeros(128,128);

W_R_r(:,1:128)=rot90(data_ram,1);%��ʱ����ת 90 ��
W_R_r(:,129:256)=new_data;

for i=1:128
    [codeword,w]=r_decoder(W_R_r(i,:),gf_table,t);
    decision_codeword(i,:)=codeword(1:128);%��128������Ϊ���
    W_R_r(i,:)=W_R_r(i,:)+alpha*w;%��������Ϣ
end
data_ram=W_R_r(:,129:256);
decision_codeword=rot90(decision_codeword,-1);
data_out=rot90(W_R_r(:,1:128),-1);



