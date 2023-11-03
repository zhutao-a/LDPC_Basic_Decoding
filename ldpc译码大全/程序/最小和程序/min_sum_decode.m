function[L_R,L_Q]=min_sum_decode(infor_V,V_infor,decode_in_LLR,L_Q)

%最小和算法

for  index_1=1:size(infor_V,1) %信息节点  
    for index_2=1:size(infor_V,2)%变量节点的下标

        if infor_V(index_1,index_2)==0
            break;
        end
        %求剩余变量到信息的乘积
        mid_var3=1;
        for  mid_var1=1:size(infor_V,2)
             if infor_V(index_1,mid_var1)==0
                break;
             end 
            if mid_var1~=index_2
                for mid1_var1=1:size(V_infor,2)%信息节点            
                   if V_infor(infor_V(index_1,mid_var1),mid1_var1)==index_1
                      gg1=mid1_var1;
                   end 
               end     
               mid_var3=mid_var3*sign( L_Q(gg1,infor_V(index_1,mid_var1)));%最后求出的乘积
            end   
        end
        %求出剩余变量到信息的最小的那个
        count=0;%mid_var5=zeros(1,size(infor_V,2)-1);
        for mid_var2=1:size(infor_V,2)
            if mid_var2~=index_2
                count=count+1;  
                 if infor_V(index_1,mid_var2)==0
                    break;
                 end
                 for mid1_var1=1:size(V_infor,2)%信息节点                   
                    if V_infor(infor_V(index_1,mid_var2),mid1_var1)==index_1
                       gg2=mid1_var1;
                    end 
                 end                  %信息节点      变量节点
              mid_var5(count)=abs(L_Q(gg2,infor_V(index_1,mid_var2)));%最后求出的最小值
            end   
        end
        %   信息节点   变量节点
        L_R(index_1,index_2)=0.75*min(mid_var5)*mid_var3;
    end
end  
% 求L_Q的值
for index_3=1:size(V_infor,1)%变量节点  行
    for index_4=1:size(V_infor,2)%信息节点  列
        mid_var8=0;
        for mid_var6=1:size(V_infor,2)
            if mid_var6~=index_4   
                 for mid2_var2=1:size(infor_V,2)%变量节点
                     
                       if infor_V(V_infor(index_3,mid_var6),mid2_var2)==index_3%函数 变量  变量                     
                            if infor_V(V_infor(index_3,mid_var6),mid2_var2)==0
                                break;
                            end    
                           
                           gg3=mid2_var2;
                       end
                  end   
                %                               信息节点     变量节点 
                mid_var8=mid_var8+L_R(V_infor(index_3,mid_var6),gg3);
            end
        end
        %   信息节点 变量节点                        变量节点
        L_Q(index_4,index_3)=mid_var8+decode_in_LLR(index_3);
    end
end




 