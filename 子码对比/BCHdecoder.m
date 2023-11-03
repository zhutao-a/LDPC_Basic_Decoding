function [de_code,decode]=BCHdecoder(n_code,msg)%n_code为256*256大小矩阵
alpha=[0.25,0.5,0.75,1];
de_code=zeros(1,256);
gf_table=gf_table_generate();
t=error_pattern_generate(6);
for n=1:4%迭代次数为4
        [decision_codeword,w]=r_decoder(n_code(1,:),gf_table,t);
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
