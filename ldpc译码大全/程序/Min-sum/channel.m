%ģ��flash���ɴ���Ĺ���
%���룺����u������λ��e
%�����������������y�����������λerrorbit������ÿһλ�����ʹ�����Ϣ������p
function [y,errorbit,p]=channel(u,e)

n=length(u);
errorbit=randperm(n);
errorbit=errorbit(1:e);

for jj=1:e
    u(errorbit(jj))=mod(u(errorbit(jj))+1,2);%�������
end

y=u;

p=ones(1,n);
p=p*e/n;
