function output=insert_cp(input,cp_length)%Ϊofdm���ſ����ѭ��ǰ׺��cp_lengthΪѭ��ǰ׺����
         [m,n]=size(input);%���뵼Ƶ�Ժ�ľ���Ϊ128*110
         output=zeros(m+cp_length,n);%��������144*110
         %����ѭ��Ϊ���в���ѭ��ǰ׺
         for j=1:n
             output(1:cp_length,j)=input((m-cp_length+1):m,j);
             output((cp_length+1):(m+cp_length),j)=input(:,j);
         end
         
             
