%���о�����
%���� H��У�����   y������������    ber��������   errorbit����������λ����Ϣ���������⻯��Ȼ��   p��������������Ϣ������
%Imax������������
%��� MM��������  cycle��ѭ������  
function [MM,cycle]=min_sum_decode(H,y,ber,errorbit,p,Imax)

I=1;%��������������
%Imax=20;%�涨����������

[m,n]=size(H);
%n=H��������/��Ϣ�ڵ���
%m=H��������/У��ڵ���

z=zeros(1,n);
r=zeros(1,n);
L=zeros(1,n);

M=zeros(m,n);
E=zeros(m,n);

for ii=1:n
    if y(ii)==1
        r(ii)=log(p(ii)/(1-p(ii)));
    else
        r(ii)=log((1-p(ii))/p(ii));
    end
end

%��ʼ��M����
for ii=1:n
    for jj=1:m
        M(jj,ii)=r(ii);
    end
end
M=(H.*M);

%����
while 1==1
  
    for jj=1:m


        for ii=1:n
            if H(jj,ii)==0
                E(jj,ii)=0;
            else
                Mtemp1=M(jj,:);
                Mtemp1(n)=0;
                position1=find(Mtemp1);
                Mtemp=zeros(1,length(position1));
                for flag1=1:length(position1)
                    Mtemp(flag1)=M(jj,position1(flag1));
                end                
                E(jj,ii)=prod(sign(Mtemp))*min(abs(Mtemp));
            end
        end
    end
    
    %������Ϣ�ڵ�,Test
    for ii=1:n
        L(ii)=r(ii)+sum(E(:,ii));
        if L(ii)<=0
            z(ii)=1;
        else
            z(ii)=0;
        end
    end
    

    HzT=mod((H*z')',2);
    
    if I==Imax || isempty(find(mod(HzT,2), 1))
        fprintf('finish at iteration %d\n',I);
        MM=z;
        cycle=I;
        return;
    end
    
    I=I+1;
    
    for ii=1:n
        for jj=1:m
            if E(jj,ii) ~= 0
                M(jj,ii)=r(ii)+sum(E(:,ii))-E(jj,ii);
            else
                M(jj,ii)=0;
            end
        end 
    end
    
end