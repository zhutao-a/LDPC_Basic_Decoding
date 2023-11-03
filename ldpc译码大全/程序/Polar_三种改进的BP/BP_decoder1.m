function [ output ] = BP_decoder1( input,tmp1,N)

max_iter =60;
n=log2(N);
L=zeros(N,n+1);
R=zeros(N,n+1);
C=zeros(N,n+1);
lamida=1;
LLR_F=log(lamida/(1-lamida));
LLR_I=0;
info_bit_index=find(tmp1==1);
fre_bit_index=find(tmp1==0);
R(fre_bit_index,1)=inf;
R(info_bit_index,1)=0;
L(:,n+1)=input;
C(fre_bit_index,1)=LLR_F;
C(info_bit_index,1)=LLR_I;
for iter = 1:max_iter
%         R(fre_bit_index,1)=R(fre_bit_index,1)+C(fre_bit_index,1);
%         R(info_bit_index,1)=R(info_bit_index,1)+C(info_bit_index,1);
        for i=n:-1:1
            for j=1:N/2
                L(j,i)=fun_g(L(2*j-1,i+1),L(2*j,i+1)+R(j+N/2,i));
                L(j+N/2,i)=fun_g(R(j,i),L(2*j-1,i+1))+L(2*j,i+1);
            end
        end
        for i=1:n
            for j=1:N/2
                R(2*j-1,i+1)=fun_g(R(j,i),R(j+N/2,i)+L(2*j,i+1));
                R(2*j,i+1)=fun_g(R(j,i),L(2*j-1,i+1))+R(j+N/2,i);
            end
        end
end
output=L(:,1);
for i=1:N
    if find(info_bit_index==i)
        if output(i)>=0
            output(i)=0;
        else
            output(i)=1;
        end
    else
        output(i)=0;
    end
end
end