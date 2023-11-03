function [candidate_codeword_4,analog_weight_4]=select_32_to_4min(candidate_codeword,m,flag)
data_max=63;
m=flipud(m);
flag=flipud(flag);
analog_weight_index=zeros(32,2);%前面是模拟重量，后面是索引,32为第一行
for i=1:32
    analog_weight_index(i,2)=i;
    if(flag(i)==0)
        analog_weight_index(i,1)=data_max;  
    else
        analog_weight_index(i,1)=m(i);  
    end
end
step0_w_index=zeros(32,2);
for i=1:8
    step0_w_index((i-1)*4+1:i*4,:)=sort_4(analog_weight_index((i-1)*4+1:i*4,:));
end

step1_w_index=zeros(16,2);
for i=1:4
    step1_w_index((i-1)*4+1:i*4,:)=merge_select_8_to_4min(step0_w_index((i-1)*8+1:(i-1)*8+4,:),step0_w_index((i-1)*8+5:(i-1)*8+8,:));
end

step2_w_index=zeros(8,2);
for i=1:2
    step2_w_index((i-1)*4+1:i*4,:)=merge_select_8_to_4min(step1_w_index((i-1)*8+1:(i-1)*8+4,:),step1_w_index((i-1)*8+5:(i-1)*8+8,:));
end

w_index=zeros(4,2);
w_index(1:4,:)=merge_select_8_to_4min(step2_w_index(1:4,:),step2_w_index(5:8,:));

codeword=zeros(4,256);
codeword(1,:)=candidate_codeword(33-w_index(1,2),:);
codeword(2,:)=candidate_codeword(33-w_index(2,2),:);
codeword(3,:)=candidate_codeword(33-w_index(3,2),:);
codeword(4,:)=candidate_codeword(33-w_index(4,2),:);

candidate_codeword_4=zeros(4,256);
analog_weight_4=zeros(4,1);
if(w_index(1,1)==data_max)
    candidate_codeword_4(1,:)=codeword(1,:);
    candidate_codeword_4(2,:)=codeword(1,:);
    candidate_codeword_4(3,:)=codeword(1,:);
    candidate_codeword_4(4,:)=codeword(1,:);
    analog_weight_4(1)=w_index(1,1);
    analog_weight_4(2)=w_index(1,1);
    analog_weight_4(3)=w_index(1,1);
    analog_weight_4(4)=w_index(1,1); 
elseif(w_index(2,1)==data_max)
    candidate_codeword_4(1,:)=codeword(1,:);
    candidate_codeword_4(2,:)=codeword(1,:);
    candidate_codeword_4(3,:)=codeword(1,:);
    candidate_codeword_4(4,:)=codeword(1,:);
    analog_weight_4(1)=w_index(1,1);
    analog_weight_4(2)=w_index(1,1);
    analog_weight_4(3)=w_index(1,1);
    analog_weight_4(4)=w_index(1,1); 
elseif(w_index(3,1)==data_max)
    candidate_codeword_4(1,:)=codeword(1,:);
    candidate_codeword_4(2,:)=codeword(2,:);
    candidate_codeword_4(3,:)=codeword(2,:);
    candidate_codeword_4(4,:)=codeword(2,:);
    analog_weight_4(1)=w_index(1,1);
    analog_weight_4(2)=w_index(2,1);
    analog_weight_4(3)=w_index(2,1);
    analog_weight_4(4)=w_index(2,1); 
elseif(w_index(4,1)==data_max)
    candidate_codeword_4(1,:)=codeword(1,:);
    candidate_codeword_4(2,:)=codeword(2,:);
    candidate_codeword_4(3,:)=codeword(3,:);
    candidate_codeword_4(4,:)=codeword(3,:);
    analog_weight_4(1)=w_index(1,1);
    analog_weight_4(2)=w_index(2,1);
    analog_weight_4(3)=w_index(3,1);
    analog_weight_4(4)=w_index(3,1); 
else
    candidate_codeword_4(1,:)=codeword(1,:);
    candidate_codeword_4(2,:)=codeword(2,:);
    candidate_codeword_4(3,:)=codeword(3,:);
    candidate_codeword_4(4,:)=codeword(4,:);
    analog_weight_4(1)=w_index(1,1);
    analog_weight_4(2)=w_index(2,1);
    analog_weight_4(3)=w_index(3,1);
    analog_weight_4(4)=w_index(4,1); 
end









