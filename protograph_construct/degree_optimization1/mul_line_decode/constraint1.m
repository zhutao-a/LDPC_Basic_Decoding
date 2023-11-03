function [w_len,weight]=constraint1(group)
%group的大小为(4,368)
weight=zeros(1,368);
for i=1:368
    weight(i)=sum(group(:,i));
end
w_len=zeros(2,5);%重量为0，1，2，3，4
w_len(1,1)=0;
w_len(1,2)=1;
w_len(1,3)=2;
w_len(1,4)=3;
w_len(1,5)=4;

w_len(2,1)=length(find(weight==0));
w_len(2,2)=length(find(weight==1));
w_len(2,3)=length(find(weight==2));
w_len(2,4)=length(find(weight==3));
w_len(2,5)=length(find(weight==4));



