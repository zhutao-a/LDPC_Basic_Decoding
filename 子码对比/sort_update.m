function [u_matrix,R_matrix,LLR_matrix]=sort_update(L,y,N,flag,Flag,PM_temp,u_matrix,R_matrix,LLR_matrix,Infty)
M=log2(N);
if flag(1)>Flag
    [a,b]=sort(PM_temp(:,2),'descend');
    temp=zeros(L,y+1);%zeros(0,i+1)
    tempR = zeros(M+1,N,L);
    LLR_temp = zeros(M+1,N,L);
    for j=1:L                                            %这个循坏用于从2L个概率值中选取较大的L个
        if  mod(b(j),2)==1                               %奇数表示最后一位是1，tempcode的i+1位是该路径的pm
            temp(j,:)=[u_matrix((b(j)+1)/2,1:y-1),1,a(j)]; %找出排序后对应u_matrix里的的第几行码子
            tempR(:,:,j)=R_matrix(:,:,(b(j)+1)/2);
            LLR_temp(:,:,j)=LLR_matrix(:,:,(b(j)+1)/2);
        else                                              %偶数表示最后一位是0 ，tempcode的i+1位是该路径的pm
            temp(j,:)=[u_matrix(b(j)/2,1:y-1),0,a(j)];
            tempR(:,:,j)=R_matrix(:,:,(b(j))/2);
            LLR_temp(:,:,j)=LLR_matrix(:,:,(b(j))/2);
        end
        u=temp(j,y);
        if u == 0
            tempR(M+1,y,j) = Infty;
        else
            tempR(M+1,y,j) = 0;
        end
    end
    Rx(M+1,y)=0;
    u_matrix(:,1:y)=temp(:,1:y);
    u_matrix(:,N+1)=temp(:,y+1);
    R_matrix = tempR;
    LLR_matrix = LLR_temp;
end
end