function x2=polarDecBP1(u,y,p,sigma)

%功能是完成接收序列译码
%输入L是路径搜索宽度，y是接收序列长度为N，p是位置矩阵，指示信息比特和固定比特的位置,sigma为信道高斯噪声的标准差
%输出x是译码得到的信息比特序列
alpha=[0.25,0.5,0.75,1];
Infty =128;
K = length(u);
N=length(y);
M=log2(N);
LLR_matrix=zeros(M+1,N);
R_matrix=zeros(M+1,N);
LLR_matrix(1,:)=2.*y./sigma^2;
x2=zeros(1,K);
b=zeros(1,256);
for i=1:256%硬判决序列赋值
    if LLR_matrix(1,i)<0
        b(i)=1;
    end
end
for i=1:N
    if(p(i)==0)
        R_matrix(M+1,i)=Infty;
    end
end
Miter=4;
uk=zeros(1,N);
K=length(uk);
n=M;
w=zeros(1,256);%初始化外信息
for iter=1:Miter
    LLR_matrix(1,:)=LLR_matrix(1,:)+alpha(iter)*w;
    x=2;
    y=1;
    a=M;
    d=0;
    for i=x:1:n+1
        for k=1:1:(N/2^(i-1))
            i1 = y+k-1+N/2^(i-1);
            LLR_matrix(i,y+k-1)=hanshu1(LLR_matrix(i-1,y+k-1),LLR_matrix(i-1,i1)+R_matrix(i,i1));
        end
    end
    LLR_matrix(n+1,y+1)=hanshu1(LLR_matrix(n,y),R_matrix(n+1,y))+LLR_matrix(n,y+1);
    y=2;
    while(d~=0||a~=1)
        for j=1:1:N/2^a
            j1 = y-2^(n-a+1)+j+N/2^a;
            j2= y-2^(n-a+1)+j;
            R_matrix(a,j2)=hanshu1(R_matrix(a+1,j2),R_matrix(a+1,j1)+LLR_matrix(a,j1));
            R_matrix(a,j1)=hanshu1(R_matrix(a+1,j2),LLR_matrix(a,j2))+R_matrix(a+1,j1);
        end
        d=rem(y,N/2^(a-2));
        if(d==0&&a==2)
            a=a-1;
        else if d~=0
                for i=1:1:N/2^(a-1)
                    LLR_matrix(a,y+i)=hanshu1(LLR_matrix(a-1,y+i-N/2^(a-1)),R_matrix(a,y+i-N/2^(a-1)))+LLR_matrix(a-1,y+i);
                end
                y=y+1;
                x=a+1;
                for i=x:1:n+1
                    for k=1:1:(N/2^(i-1))
                        LLR_matrix(i,y+k-1)=hanshu1(LLR_matrix(i-1,y+k-1),LLR_matrix(i-1,y+k-1+N/2^(i-1))+R_matrix(i,y+k-1+N/2^(i-1)));
                    end
                end
                LLR_matrix(n+1,y+1)=hanshu1(LLR_matrix(n,y),R_matrix(n+1,y))+LLR_matrix(n,y+1);
                y=y+1;
                a=M;
            else
                a=a-1;
            end
        end
    end
    for i=1:256%.求判决码字每个比特竞争码字，每个比特外信息
        if b(i)==uk(i)%不存在竞争码字
            w(i)=LLR_matrix(M+1,i)/6*(1-2*uk(i));
        else%存在竞争码字
            w(i)=LLR_matrix(M+1,i)*(1-2*uk(i))-LLR_matrix(1,i);
        end
    end
    j=1;
    for m=1:N                  %把信息位K位从译码序列中提取出来
        if sign(LLR_matrix(M+1,m))<=0
            uk(1,j)=1;
        else
            uk(1,j)=0;
        end
        j=j+1;
        
    end
    j=1;
    soft(iter,:) = LLR_matrix(M+1,:);
    for i=1:N
        if p(i)==1
            x2(j)=uk(1,i);
            j=j+1;
        end
    end
    errbit=length(find(x2~=u));
    if errbit==0
        soft(iter,:) = LLR_matrix(M+1,:);
        break
    end
end
end