%function [G]=getG(m,n)
function [G]=getG(m,n)
m=512;n=1024;
H=getH(m,n);
[G,valid]=H2G(H); 
while valid==0                   %valid��ΪУ������Ƿ�Ϊ���ȵı�־,��Ϊ������(valid=0),�򷵻���������1A�������
H=getH(m,n);                     %����У�����H
[G,valid]=H2G(H);                %��У�����Hת��Ϊ���ɾ���G
end

t=mod(G*H,2);
[i.j]=find(t);

save G
