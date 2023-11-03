function[infor_R_0,infor_R_1,infor_Q,kk0,kk1,qq,pp]=BP_ldpc_decoder(infor_V,V_infor,row_weight,infor_Q,LDPC_prior_0, LDPC_prior_1,NumOfFrame )
% ==============================================================================================
% functions   ：基于BP算法的LDPC译码。先验信息是LDPC_prior
% qian chen
% =========================================================================
% =====================
%infor_R_0表示信息节点向变量节点传递信息
%infor_Q_0表示变量节点向信息节点传递信息
%初始化数组
%初始化信息节点向变量节点传递信息
% infor_R_0=zeros(size(infor_V,1),size(V_infor,1));
% infor_R_1=zeros(size(infor_V,1),size(V_infor,1));
%信息节点向变量节点传递信息
%整个的循环过程：第一层循环是信息节点，第二层循环是变量节点，如果infor_V取值为零则跳出循环，第三层循环是变量节点的下标，是为除去
%第二层循环的变量节点剩下的变量节点，然后计算几位的格雷码，本次的LDPC码的译码是采样异或，要遍历所有的可能性，找到符合要求的二进制数
%，格雷码的优点是偶数行异或为1，奇数行异或为0.这样比较容易将挑出需要的二进制。然后计算R_0，利用g作为中间变量，将格雷码每行中的二进制
%数加1后赋值给Q_0数组的第一个变量，取出相对应的Q_0的值。同样计算R_1.

              %首先计算 R
 for index_1=1:size(infor_V,1)%信息节点的下标 行
   for index_2=1:size(infor_V,2)%变量节点的个数  列
       if infor_V(index_1,index_2)==0
           break;
       end
       count=0;
       for mid_var=1:size(infor_V,2)
           if mid_var~=index_2
               count=count+1; 
               mid_var3(count)=mid_var;%获得其他的变量节点的位置
           end
       end 
       %行重至少为2
      [Gray_code]=Graycode(row_weight(index_1)-1);%求每行中变量节点个数减一的二进制
      mid_var9=0;  mid_var10=0;  
      for i=1:2^(row_weight(index_1)-1)%格雷码的行(行代表每个Ｑ的取值 )
          %行重为2时的处理，同时也为行重大于2做准备
          mid_var0(i,1)=Gray_code(i,1);%将格雷码的i行的第一列赋值给  mid_var0(i,1)
          %行重大于等于3时
          if row_weight(index_1)-1>=2
              for j=2:row_weight(index_1)-1%格雷码的每列（从第二列开始）
                  mid_var0(i,1)=xor(mid_var0(i,1),Gray_code(i,j));%一行中所有元素进行异或
              end
          end
          
          if  mid_var0(i,1)==0%若这一行异或为零的话，则将变量节点的信息相乘，然后赋给信息节点 
              mid_var1=1;
              for  hh=1:row_weight(index_1)-1  
                  
                   for mid1_var1=1:size(V_infor,2)%信息节点
                       if V_infor(infor_V(index_1,mid_var3(hh)),mid1_var1)==index_1
                           gg1=mid1_var1;
                       end 
                   end                %    变量的取值     变量的下标                   信息的下标                              
                   mid_var1=mid_var1*infor_Q(Gray_code(i,hh)+1,infor_V(index_1,mid_var3(hh)),gg1);  
              end
                          %信息节点下标   变量节点下标
                 mid_var9=mid_var9+mid_var1;         
%               infor_R_0(index_1,infor_V(index_1,index_2))=infor_R_0(index_1,infor_V(index_1,index_2))+mid_var1;
          else
               mid_var2=1;       
                for  ff=1:row_weight(index_1)-1
                     for mid1_var1=1:size(V_infor,2)%信息节点
                       if V_infor(infor_V(index_1,mid_var3(ff)),mid1_var1)==index_1
                           gg2=mid1_var1;
                       end 
                    end
                                           %       变量的取值     变量的下标                  信息的下标                              
                     mid_var2=mid_var2*infor_Q(Gray_code(i,ff)+1,infor_V(index_1,mid_var3(ff)),gg2) ; 
                 end
               mid_var10=mid_var10+mid_var2;
%                infor_R_1(index_1,infor_V(index_1,index_2))=infor_R_1(index_1,infor_V(index_1,index_2))+mid_var2;
          end          
      end     
                    %信息节点    变量节点
         infor_R_0(index_1,index_2)=mid_var9;
         infor_R_1(index_1,index_2)=mid_var10;
         
   end
end
%计算变量节点到信息节点传递的信息
for  index_3=1:size(V_infor,1)%变量节点的下标V_infor的行数
     for index_4=1:size(V_infor,2)%信息节点的个数%  V_infor的列数
          if V_infor(index_3,2)==0 
               infor_Q(1,index_3,V_infor(index_3,index_4))= (LDPC_prior_0(index_3)+eps)/(LDPC_prior_0(index_3)+LDPC_prior_1(index_3)+eps);%归一化
               infor_Q(2,index_3,V_infor(index_3,index_4))= (LDPC_prior_1(index_3)+eps)/(LDPC_prior_0(index_3)+LDPC_prior_1(index_3)+eps);
             break;
          end 
             if V_infor(index_3,index_4)==0  
                 break;
              end 
          qq=1;pp=1; 
          for mid_var4=1:size(V_infor,2) %信息节点的个数
              if V_infor(index_3,mid_var4)==0  
                 break;
              end 
              if  mid_var4~=index_4  
                  
                   for mid2_var2=1:size(infor_V,2)%变量节点
                       if infor_V(V_infor(index_3,mid_var4),mid2_var2)==index_3%函数 变量  变量
                           gg3=mid2_var2;
                       end
                 end
                                  %  信息节点            变量节点         
                qq=qq*infor_R_0(V_infor(index_3,mid_var4),gg3);
                pp=pp*infor_R_1(V_infor(index_3,mid_var4),gg3); 
                
              end
          end
          qq=qq*LDPC_prior_0(index_3);
          pp=pp*LDPC_prior_1(index_3);
           %变量的取值 变量的下标    信息的下标
          infor_Q(1,index_3,index_4)= (qq+eps)/(qq+pp+eps);%归一化
          infor_Q(2,index_3,index_4)= (pp+eps)/(qq+pp+eps);
          
          kk0(index_3,index_4)=(qq+eps)/(qq+pp+eps);%归一化
          kk1(index_3,index_4)=(pp+eps)/(qq+pp+eps);
          
     end
end

          

