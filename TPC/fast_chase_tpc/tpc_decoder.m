function [de_code,n_code]=tpc_decoder(n_code)%n_code为256*256大小矩阵
alpha=[0.25,0.5,0.75,1];
de_code=zeros(256,256);
gf_table=gf_table_generate();
t=error_pattern_generate(6);
for n=1:4%迭代次数为4
    for i=1:256%完成行译码
        [decision_codeword,w]=r_decoder(n_code(i,:),gf_table,t);
        n_code(i,:)=n_code(i,:)+alpha(n)*w;
        de_code(i,:)=decision_codeword;
    end
    for i=1:256%完成列译码
        temp=n_code(:,i)';%将第i列转为行
        [decision_codeword,w]=r_decoder(temp,gf_table,t);
        n_code(:,i)= n_code(:,i)+(alpha(n)*w)';
        de_code(:,i)=decision_codeword';  
    end
end


