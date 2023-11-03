function [y,errorbit,p]=channel_part(u,e,H,~,~,accuracy)
% 11 10 00 01
[~,n]=size(H);
p=0.00001*ones(1,n);
y=u;

%accuracy=4;
error_origin=randperm(n);
errorbit=error_origin(1:e);
for jj=1:e
    y(errorbit(jj))=mod(y(errorbit(jj))+1,2);%加入错误
end

%按照精确度赋值p
p(error_origin(1:accuracy*e))=e/n;