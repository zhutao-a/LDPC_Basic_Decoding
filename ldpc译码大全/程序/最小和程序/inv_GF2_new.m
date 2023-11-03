function [Ainv,B]=inv_GF2_new(A)
%clear all
%close all
%clc
%A=[0 1 1;1 1 1; 1 0 1];
%load HA.mat
%H1=HA(1:35*127,1:35*127);
%A=H1;
%clear H1;
%clear HA;
dim=size(A); 
rows=dim(1);
%Ainv=zeros(rows,rows);
Btmp=zeros(1,2*rows);
I=eye(rows);
B=[A I];
clear I;
for i=1:rows
    g=B(:,i);
    p=find(g);
    for j=1:size(p,1)
        if p(j)>=i
            ptmp=p(j);
            break;
        end%end if
    end%end for j
    Btmp=B(i,:);
    B(i,:)=B(ptmp,:);
    B(ptmp,:)=Btmp;
    g=B(:,i);
    p=find(g);

    for j=1:size(p,1)
        if p(j)>i
        B(p(j),:)=mod(B(p(j),:)+B(i,:),2);
        end%end if
    end %end for j
%      fprintf('i1=%d\n\n',i);
end%end for i
%C=B;%CӦ��Ϊһ������Ǿ���?%clear p;
%clear Btmp;
%clear g;
for i=1:rows-1
    x=rows-i+1;
    p=find(B(:,x));
    for j=1:size(p,1)-1
        B(p(j),:)=mod(B(p(j),:)+B(x,:),2);
    end
%     fprintf('i2=%d\n\n',i);
end
Ainv=B(1:rows,rows+1:rows*2);
