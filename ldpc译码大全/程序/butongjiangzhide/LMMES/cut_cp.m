function output=cut_cp(input,cp_length)    %cp_length��ѭ��ǰ׺�ĳ���
        [m,n]=size(input);
         output=zeros(m-cp_length,n);
         %����ѭ��Ϊ���в���ѭ��ǰ׺
         for j=1:n
             output(1:(m-cp_length),j)=input((cp_length+1:m),j);
             
         end