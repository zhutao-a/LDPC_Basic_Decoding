function[L_R,L_Q]=min_sum_decode(infor_V,V_infor,decode_in_LLR,L_Q)

%��С���㷨

for  index_1=1:size(infor_V,1) %��Ϣ�ڵ�  
    for index_2=1:size(infor_V,2)%�����ڵ���±�

        if infor_V(index_1,index_2)==0
            break;
        end
        %��ʣ���������Ϣ�ĳ˻�
        mid_var3=1;
        for  mid_var1=1:size(infor_V,2)
             if infor_V(index_1,mid_var1)==0
                break;
             end 
            if mid_var1~=index_2
                for mid1_var1=1:size(V_infor,2)%��Ϣ�ڵ�            
                   if V_infor(infor_V(index_1,mid_var1),mid1_var1)==index_1
                      gg1=mid1_var1;
                   end 
               end     
               mid_var3=mid_var3*sign( L_Q(gg1,infor_V(index_1,mid_var1)));%�������ĳ˻�
            end   
        end
        %���ʣ���������Ϣ����С���Ǹ�
        count=0;%mid_var5=zeros(1,size(infor_V,2)-1);
        for mid_var2=1:size(infor_V,2)
            if mid_var2~=index_2
                count=count+1;  
                 if infor_V(index_1,mid_var2)==0
                    break;
                 end
                 for mid1_var1=1:size(V_infor,2)%��Ϣ�ڵ�                   
                    if V_infor(infor_V(index_1,mid_var2),mid1_var1)==index_1
                       gg2=mid1_var1;
                    end 
                 end                  %��Ϣ�ڵ�      �����ڵ�
              mid_var5(count)=abs(L_Q(gg2,infor_V(index_1,mid_var2)));%����������Сֵ
            end   
        end
        %   ��Ϣ�ڵ�   �����ڵ�
        L_R(index_1,index_2)=0.75*min(mid_var5)*mid_var3;
    end
end  
% ��L_Q��ֵ
for index_3=1:size(V_infor,1)%�����ڵ�  ��
    for index_4=1:size(V_infor,2)%��Ϣ�ڵ�  ��
        mid_var8=0;
        for mid_var6=1:size(V_infor,2)
            if mid_var6~=index_4   
                 for mid2_var2=1:size(infor_V,2)%�����ڵ�
                     
                       if infor_V(V_infor(index_3,mid_var6),mid2_var2)==index_3%���� ����  ����                     
                            if infor_V(V_infor(index_3,mid_var6),mid2_var2)==0
                                break;
                            end    
                           
                           gg3=mid2_var2;
                       end
                  end   
                %                               ��Ϣ�ڵ�     �����ڵ� 
                mid_var8=mid_var8+L_R(V_infor(index_3,mid_var6),gg3);
            end
        end
        %   ��Ϣ�ڵ� �����ڵ�                        �����ڵ�
        L_Q(index_4,index_3)=mid_var8+decode_in_LLR(index_3);
    end
end




 