function de_code=tpc_decoder(n_code)%n_code为128*128大小矩阵
alpha=[0.25,0.5,0.75,1];
de_code=zeros(128,128);
for n=1:4%迭代次数为4
    for i=1:128%完成行译码
        [decision_codeword,w]=r_decoder(n_code(i,:));
        n_code(i,:)=n_code(i,:)+alpha(n)*w;
        de_code(i,:)=decision_codeword;
    end
    for i=1:128%完成列译码
        temp=n_code(:,i)';%将第i列转为行
        [decision_codeword,w]=r_decoder(temp);
        n_code(:,i)= n_code(:,i)+(alpha(n)*w)';
        de_code(:,i)=decision_codeword';  
    end
end


