%软判决译码
%输入 H：校验矩阵   y：读出的数组    ber：错误率   errorbit：错误所在位的信息，用来特殊化似然比   p：包含错误率信息的数组
%Imax：最大迭代次数
%输出 MM：纠错结果  cycle：循环次数  
function [MM,cycle]=min_sum_decode(H,y,ber,errorbit,p,Imax)

I=1;%迭代次数计数器
%Imax=20;%规定最大迭代次数

[m,n]=size(H);
%n=H矩阵列数/信息节点数
%m=H矩阵行数/校验节点数

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

%初始化M矩阵
for ii=1:n
    for jj=1:m
        M(jj,ii)=r(ii);
    end
end
M=(H.*M);

%迭代
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
    
    %更新信息节点,Test
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