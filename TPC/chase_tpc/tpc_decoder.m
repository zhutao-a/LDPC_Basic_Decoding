function de_code=tpc_decoder(n_code,gf_table,t)%n_code为256*256大小矩阵
%[decision_codeword,w]=r_decoder(r,gf_table,t,beta)
beta=[0.5,0.75,1,1];
alpha=[0.25,0.25,0.5,1];
de_code=zeros(256,256);
for n=1:4%迭代次数为4
    for i=1:256%完成行译码
        [decision_codeword,w]=r_decoder(n_code(i,:),gf_table,t,beta(n));
        n_code(i,:)=n_code(i,:)+alpha(n)*w;
        de_code(i,:)=decision_codeword;
    end
    for i=1:256%完成列译码
        temp=n_code(:,i)';%将第i列转为行
        [decision_codeword,w]=r_decoder(temp,gf_table,t,beta(n));
        n_code(:,i)= n_code(:,i)+(alpha(n)*w)';
        de_code(:,i)=decision_codeword';  
    end
end


