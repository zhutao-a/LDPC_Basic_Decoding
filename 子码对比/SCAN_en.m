function decode=SCAN_en(n_code,u,y,p,sigma)%n_code为256*256大小矩阵
alpha=[0.25,0.5,0.75,1];
de_code=zeros(1,256);
for n=1:4%迭代次数为4
        [decision_codeword,w]=polarDecBP1(u,y,p,sigma);
        n_code(1,:)=n_code(1,:)+alpha(n)*w;
        de_code(1,:)=decision_codeword;
end
for j=1:256
    if(n_code(1,j)>=0)
        decode(1,j)=1;
    else
        decode(1,j)=0;
    end
end
err = length(find(decode~=msg));
end