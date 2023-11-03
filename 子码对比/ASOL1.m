function uk=ASOL1(soft,L,y,p,sigma,uyima)
index = find(p);
softin = soft(index);
Infty =128;
N=length(y);
M=log2(N);
PM_temp=zeros(2*L,2);           %存放2L个码字串的判断位置，用于选出L个码字串的临时矩阵
PM_temp(1:2:2*L,1)=ones(L,1);   %把第一列奇数行的值设为1
LLR_matrix=zeros(M+1,N,L);
R_matrix=zeros(M+1,N,L);
Rx=zeros(M+1,N);
reserve_all=path_matrix(L);
Flag=log2(L);
u_matrix=zeros(L,N+1);  %该矩阵是一个（L*(N+1)）的二维矩阵，u_matrix的每一行的前N列存放一串保留路径对应的码字，u_matrix(:,N+1)则对应着候选路径的度量值
for i = 1:L
    LLR_matrix(1,:,i)=2.*y./sigma^2;
end
for j = 1:L
    for i=1:N
        if(p(i)==0)
            R_matrix(M+1,i,j)=Infty;
            Rx(M+1,i)=Infty;
        end
    end
end
Miter=3;
n=M;
%R_matrix=bitmapupdate(LLR_matrix,R_matrix,L,N);
for iter=1:Miter
%     for j = 1:L
%         R_matrix(:,:,j) = Rx;
%     end
    flag=zeros(1,L);
    PM_former=0;
    x=2;
    y=1;
    a=M;
    d=0;
    u=0;
    for j = 1:L
        for i=x:1:n+1
            for k=1:1:(N/2^(i-1))
                i1 = y+k-1+N/2^(i-1);
                LLR_matrix(i,y+k-1,j)=hanshu1(LLR_matrix(i-1,y+k-1,j),LLR_matrix(i-1,i1,j)+R_matrix(i,i1,j));
            end
        end
        LLR = LLR_matrix(i,y+k-1,j);
        u_matrix(j,N+1)=path_metric(y+k-1,u,PM_former,LLR,p);
    end
    for j = 1:L
        LLR_matrix(n+1,y+1,j)=hanshu1(LLR_matrix(n,y,j),R_matrix(n+1,y,j))+LLR_matrix(n,y+1,j);
        LLR = LLR_matrix(n+1,y+1,j);
        PM_former=u_matrix(j,N+1);
        u_matrix(j,N+1)=path_metric(y+1,u,PM_former,LLR,p);
    end
    y=2;
    while(d~=0||a~=1)
        for i = 1:L
            for j=1:1:N/2^a
                j1 = y-2^(n-a+1)+j+N/2^a;
                j2= y-2^(n-a+1)+j;
                R_matrix(a,j2,i)=hanshu1(R_matrix(a+1,j2,i),R_matrix(a+1,j1,i)+LLR_matrix(a,j1,i));
%                 Rx(a,j2)=hanshu1(Rx(a+1,j2),Rx(a+1,j1)+LLR_matrix(a,j1,i));
                R_matrix(a,j1,i)=hanshu1(R_matrix(a+1,j2,i),LLR_matrix(a,j2,i))+R_matrix(a+1,j1,i);
%                 Rx(a,j1)=hanshu1(Rx(a+1,j2),LLR_matrix(a,j2,i))+Rx(a+1,j1);
            end
        end
        d=rem(y,N/2^(a-2));
        if(d==0&&a==2)
            a=a-1;
        elseif d~=0
            for j = 1:L
                for i=1:1:N/2^(a-1)
                    LLR_matrix(a,y+i,j)=hanshu1(LLR_matrix(a-1,y+i-N/2^(a-1),j),R_matrix(a,y+i-N/2^(a-1),j))+LLR_matrix(a-1,y+i,j);
                end
            end
            y=y+1;
            x=a+1;
            for j = 1:L
                for i=x:1:n+1
                    for k=1:1:(N/2^(i-1))
                        LLR_matrix(i,y+k-1,j)=hanshu1(LLR_matrix(i-1,y+k-1,j),LLR_matrix(i-1,y+k-1+N/2^(i-1),j)+R_matrix(i,y+k-1+N/2^(i-1),j));
                    end
                    if i==n+1
                        if p(y+k-1)==0
                            u=0;
                            LLR = LLR_matrix(i,y+k-1,j);
                            PM_former=u_matrix(j,N+1);
                            u_matrix(j,N+1)=path_metric(y+k-1,u,PM_former,LLR,p);
                        else
                            flag(j)=flag(j)+1;
                            if flag(j)<=Flag
                                LLR = LLR_matrix(i,y+k-1,j);
                                u_matrix(:,y+k-1)=reserve_all(:,flag(j));
                                u=u_matrix(j,y+k-1);
                                PM_former=u_matrix(j,N+1);
                                u_matrix(j,N+1)=path_metric(y+k-1,u,PM_former,LLR,p);
                            else
                                LLR = LLR_matrix(i,y+k-1,j);
                                PM_former=u_matrix(j,N+1);
                                PM_temp(2*j-1,2)=path_metric(y+k-1,1,PM_former,LLR,p);%PM_temp矩阵奇数行存判定比特为1的路径测量值
                                PM_temp(2*j,2)=path_metric(y+k-1,0,PM_former,LLR,p);%PM_temp矩阵偶数行存判定比特为0的路径测量值
                            end
                        end
                    end
                end
            end
            if p(y)==1
                [u_matrix,R_matrix,LLR_matrix]=sort_update1(L,y,N,flag(j),Flag,PM_temp,u_matrix,R_matrix,LLR_matrix,Infty);
            end
            for j = 1:L
                LLR_matrix(n+1,y+1,j)=hanshu1(LLR_matrix(n,y,j),R_matrix(n+1,y,j))+LLR_matrix(n,y+1,j);
                if p(y+1)==0
                    u=0;
                    LLR = LLR_matrix(n+1,y+1,j);
                    PM_former=u_matrix(j,N+1);
                    u_matrix(j,N+1)=path_metric(y+1,u,PM_former,LLR,p);
                else
                    flag(j)=flag(j)+1;
                    if flag(j)<=Flag
                        LLR = LLR_matrix(n+1,y+1,j);
                        u_matrix(:,y+1)=reserve_all(:,flag(j));
                        u=u_matrix(j,y+1);
                        if u == 0
                            R_matrix(n+1,y+1,j) = Infty;
                        else
                            R_matrix(n+1,y+1,j) = 0;
                        end
                        PM_former=u_matrix(j,N+1);
                        u_matrix(j,N+1)=path_metric(y+1,u,PM_former,LLR,p);
                    else
                        LLR = LLR_matrix(n+1,y+1,j);
                        PM_former=u_matrix(j,N+1);
                        PM_temp(2*j-1,2)=path_metric(y+1,1,PM_former,LLR,p);%PM_temp矩阵奇数行存判定比特为1的路径测量值
                        PM_temp(2*j,2)=path_metric(y+1,0,PM_former,LLR,p);%PM_temp矩阵偶数行存判定比特为0的路径测量值
                    end
                end
            end
            if p(y+1)==1
                [u_matrix,R_matrix,LLR_matrix]=sort_update(L,y+1,N,flag,Flag,PM_temp,u_matrix,R_matrix,LLR_matrix,Infty);
            end
            y=y+1;
            a=M;
        else
            a=a-1;
        end
    end
    for j = 1:L
        uk = (u_matrix(j,index));
        errbits=length(find(uyima(1,:)~=uk));
%         softiter(j,:) = LLR_matrix(M+1,:,j);
        if errbits==0
            uc = uk;
            break
        end
    end
    if errbits==0
        break
    else
        uc = u_matrix(1,index);
    end
end
uk = uc;
end