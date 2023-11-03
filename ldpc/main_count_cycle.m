clear;
clear all;
tic;

load H;

dc_max=max(sum(H,2));

H0=zeros(size(H,1),dc_max);
cn=zeros(size(H,1),1);
for i=1:size(H,1)
    temp=find(H(i,:)==1);
    cn(i)=length(temp);
    H0(i,1:cn(i))=temp;
end

%H(i,j)指的是第i行第j个1的列的位置，cn(i)指的是H第i行1的数目
num_6_cycles = count_6_cycles(H0, cn);


toc;
