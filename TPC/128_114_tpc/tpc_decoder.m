function de_code=tpc_decoder(n_code)%n_codeΪ128*128��С����
alpha=[0.25,0.5,0.75,1];
de_code=zeros(128,128);
for n=1:4%��������Ϊ4
    for i=1:128%���������
        [decision_codeword,w]=r_decoder(n_code(i,:));
        n_code(i,:)=n_code(i,:)+alpha(n)*w;
        de_code(i,:)=decision_codeword;
    end
    for i=1:128%���������
        temp=n_code(:,i)';%����i��תΪ��
        [decision_codeword,w]=r_decoder(temp);
        n_code(:,i)= n_code(:,i)+(alpha(n)*w)';
        de_code(:,i)=decision_codeword';  
    end
end


