function [de_code]=Min_decoding(re_code,EbNo,H,rows,cols)
% 最小和译码
delta=(EbNo/2)^0.5;
max_iter=50;

%%%%%%初始化%%%%%%%%%%%%%
Lc=2.*re_code./(EbNo/2);
Lg=zeros(rows,cols);
Lg=sparse(Lg);
alfa=zeros(rows,cols);
beta=zeros(rows,cols);
alfa=sparse(alfa);
beta=sparse(beta);
Lh=zeros(rows,cols);
Lh=sparse(Lh);
Lq=zeros(1,cols);
[i,j]=find(H==1);
for t=1:cols
    tt=find(j==t);
    Lg(i(tt),t)=Lc(t);
end
for inter=1:max_iter
     t=find(Lc>0|Lc==0);
     de_code(t)=0;
     tt=find(Lc<0);
     de_code(tt)=1;
    
    if mod(H*de_code.',2)==0
        disp('1')
        break
    end
    alfa=sign(Lg);
    beta=abs(Lg);

%%%%%%%%更新rmn(校验节点更新）%%%%%%%
for i=1:rows
    for j1=1:cols
        if H(i,j1)==1
            t=find(H(i,:)==1);
            [tr,tc]=size(t);
              k1=1:1:tc;
              del=find(t==j1);
              k1(del)=[];
              part=prod(alfa(i,t(k1)));
              part_a=min(beta(i,t(k1)));
              Lh(i,j1)=part*part_a;
          end   
    end
end

%%%%%%更新qmn(信息节点更新)%%%%%%%%%%%
for j1=1:cols
    for i=1:rows
        if H(i,j1)==1
            t=find(H(:,j1)==1);
            [tr,tc]=size(t);
            k1=1:1:tr;
            del=find(t==i);
            k1(del)=[];
            part0=sum(Lh(t(k1),j1));
            Lg(i,j1)=Lc(j1)+part0;
            end
        end
    end
for j1=1:cols
    for i=1:rows
        if H(i,j1)==1
             t=find(H(:,j1)==1);
            [tr,tc]=size(t);
             k1=1:1:tr;
             part_0=sum(Lh(t(k1),j1));
             Lq(j1)=Lc(j1)+part_0;
         end
    end
end
     t=find(Lq>0|Lq==0);
     de_code(t)=0;
     tt=find(Lq<0);
     de_code(tt)=1;


    if mod(H*de_code.',2)==0
        break
    end

end
 inter 