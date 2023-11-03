function[infor_R_0,infor_R_1,infor_Q,kk0,kk1,qq,pp]=BP_ldpc_decoder(infor_V,V_infor,row_weight,infor_Q,LDPC_prior_0, LDPC_prior_1,NumOfFrame )
% ==============================================================================================
% functions   ������BP�㷨��LDPC���롣������Ϣ��LDPC_prior
% qian chen
% =========================================================================
% =====================
%infor_R_0��ʾ��Ϣ�ڵ�������ڵ㴫����Ϣ
%infor_Q_0��ʾ�����ڵ�����Ϣ�ڵ㴫����Ϣ
%��ʼ������
%��ʼ����Ϣ�ڵ�������ڵ㴫����Ϣ
% infor_R_0=zeros(size(infor_V,1),size(V_infor,1));
% infor_R_1=zeros(size(infor_V,1),size(V_infor,1));
%��Ϣ�ڵ�������ڵ㴫����Ϣ
%������ѭ�����̣���һ��ѭ������Ϣ�ڵ㣬�ڶ���ѭ���Ǳ����ڵ㣬���infor_VȡֵΪ��������ѭ����������ѭ���Ǳ����ڵ���±꣬��Ϊ��ȥ
%�ڶ���ѭ���ı����ڵ�ʣ�µı����ڵ㣬Ȼ����㼸λ�ĸ����룬���ε�LDPC��������ǲ������Ҫ�������еĿ����ԣ��ҵ�����Ҫ��Ķ�������
%����������ŵ���ż�������Ϊ1�����������Ϊ0.�����Ƚ����׽�������Ҫ�Ķ����ơ�Ȼ�����R_0������g��Ϊ�м��������������ÿ���еĶ�����
%����1��ֵ��Q_0����ĵ�һ��������ȡ�����Ӧ��Q_0��ֵ��ͬ������R_1.

              %���ȼ��� R
 for index_1=1:size(infor_V,1)%��Ϣ�ڵ���±� ��
   for index_2=1:size(infor_V,2)%�����ڵ�ĸ���  ��
       if infor_V(index_1,index_2)==0
           break;
       end
       count=0;
       for mid_var=1:size(infor_V,2)
           if mid_var~=index_2
               count=count+1; 
               mid_var3(count)=mid_var;%��������ı����ڵ��λ��
           end
       end 
       %��������Ϊ2
      [Gray_code]=Graycode(row_weight(index_1)-1);%��ÿ���б����ڵ������һ�Ķ�����
      mid_var9=0;  mid_var10=0;  
      for i=1:2^(row_weight(index_1)-1)%���������(�д���ÿ���ѵ�ȡֵ )
          %����Ϊ2ʱ�Ĵ���ͬʱҲΪ���ش���2��׼��
          mid_var0(i,1)=Gray_code(i,1);%���������i�еĵ�һ�и�ֵ��  mid_var0(i,1)
          %���ش��ڵ���3ʱ
          if row_weight(index_1)-1>=2
              for j=2:row_weight(index_1)-1%�������ÿ�У��ӵڶ��п�ʼ��
                  mid_var0(i,1)=xor(mid_var0(i,1),Gray_code(i,j));%һ��������Ԫ�ؽ������
              end
          end
          
          if  mid_var0(i,1)==0%����һ�����Ϊ��Ļ����򽫱����ڵ����Ϣ��ˣ�Ȼ�󸳸���Ϣ�ڵ� 
              mid_var1=1;
              for  hh=1:row_weight(index_1)-1  
                  
                   for mid1_var1=1:size(V_infor,2)%��Ϣ�ڵ�
                       if V_infor(infor_V(index_1,mid_var3(hh)),mid1_var1)==index_1
                           gg1=mid1_var1;
                       end 
                   end                %    ������ȡֵ     �������±�                   ��Ϣ���±�                              
                   mid_var1=mid_var1*infor_Q(Gray_code(i,hh)+1,infor_V(index_1,mid_var3(hh)),gg1);  
              end
                          %��Ϣ�ڵ��±�   �����ڵ��±�
                 mid_var9=mid_var9+mid_var1;         
%               infor_R_0(index_1,infor_V(index_1,index_2))=infor_R_0(index_1,infor_V(index_1,index_2))+mid_var1;
          else
               mid_var2=1;       
                for  ff=1:row_weight(index_1)-1
                     for mid1_var1=1:size(V_infor,2)%��Ϣ�ڵ�
                       if V_infor(infor_V(index_1,mid_var3(ff)),mid1_var1)==index_1
                           gg2=mid1_var1;
                       end 
                    end
                                           %       ������ȡֵ     �������±�                  ��Ϣ���±�                              
                     mid_var2=mid_var2*infor_Q(Gray_code(i,ff)+1,infor_V(index_1,mid_var3(ff)),gg2) ; 
                 end
               mid_var10=mid_var10+mid_var2;
%                infor_R_1(index_1,infor_V(index_1,index_2))=infor_R_1(index_1,infor_V(index_1,index_2))+mid_var2;
          end          
      end     
                    %��Ϣ�ڵ�    �����ڵ�
         infor_R_0(index_1,index_2)=mid_var9;
         infor_R_1(index_1,index_2)=mid_var10;
         
   end
end
%��������ڵ㵽��Ϣ�ڵ㴫�ݵ���Ϣ
for  index_3=1:size(V_infor,1)%�����ڵ���±�V_infor������
     for index_4=1:size(V_infor,2)%��Ϣ�ڵ�ĸ���%  V_infor������
          if V_infor(index_3,2)==0 
               infor_Q(1,index_3,V_infor(index_3,index_4))= (LDPC_prior_0(index_3)+eps)/(LDPC_prior_0(index_3)+LDPC_prior_1(index_3)+eps);%��һ��
               infor_Q(2,index_3,V_infor(index_3,index_4))= (LDPC_prior_1(index_3)+eps)/(LDPC_prior_0(index_3)+LDPC_prior_1(index_3)+eps);
             break;
          end 
             if V_infor(index_3,index_4)==0  
                 break;
              end 
          qq=1;pp=1; 
          for mid_var4=1:size(V_infor,2) %��Ϣ�ڵ�ĸ���
              if V_infor(index_3,mid_var4)==0  
                 break;
              end 
              if  mid_var4~=index_4  
                  
                   for mid2_var2=1:size(infor_V,2)%�����ڵ�
                       if infor_V(V_infor(index_3,mid_var4),mid2_var2)==index_3%���� ����  ����
                           gg3=mid2_var2;
                       end
                 end
                                  %  ��Ϣ�ڵ�            �����ڵ�         
                qq=qq*infor_R_0(V_infor(index_3,mid_var4),gg3);
                pp=pp*infor_R_1(V_infor(index_3,mid_var4),gg3); 
                
              end
          end
          qq=qq*LDPC_prior_0(index_3);
          pp=pp*LDPC_prior_1(index_3);
           %������ȡֵ �������±�    ��Ϣ���±�
          infor_Q(1,index_3,index_4)= (qq+eps)/(qq+pp+eps);%��һ��
          infor_Q(2,index_3,index_4)= (pp+eps)/(qq+pp+eps);
          
          kk0(index_3,index_4)=(qq+eps)/(qq+pp+eps);%��һ��
          kk1(index_3,index_4)=(pp+eps)/(qq+pp+eps);
          
     end
end

          

