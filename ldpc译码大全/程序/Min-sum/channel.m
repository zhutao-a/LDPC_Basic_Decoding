%模拟flash发成错误的过程
%输入：码字u，错误位数e
%输出：加入错误的数组y，发生错误的位errorbit，包含每一位错误率估计信息的数组p
function [y,errorbit,p]=channel(u,e)

n=length(u);
errorbit=randperm(n);
errorbit=errorbit(1:e);

for jj=1:e
    u(errorbit(jj))=mod(u(errorbit(jj))+1,2);%加入错误
end

y=u;

p=ones(1,n);
p=p*e/n;
