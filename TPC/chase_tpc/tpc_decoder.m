function de_code=tpc_decoder(n_code,gf_table,t)%n_codeΪ256*256��С����
%[decision_codeword,w]=r_decoder(r,gf_table,t,beta)
beta=[0.5,0.75,1,1];
alpha=[0.25,0.25,0.5,1];
de_code=zeros(256,256);
for n=1:4%��������Ϊ4
    for i=1:256%���������
        [decision_codeword,w]=r_decoder(n_code(i,:),gf_table,t,beta(n));
        n_code(i,:)=n_code(i,:)+alpha(n)*w;
        de_code(i,:)=decision_codeword;
    end
    for i=1:256%���������
        temp=n_code(:,i)';%����i��תΪ��
        [decision_codeword,w]=r_decoder(temp,gf_table,t,beta(n));
        n_code(:,i)= n_code(:,i)+(alpha(n)*w)';
        de_code(:,i)=decision_codeword';  
    end
end


