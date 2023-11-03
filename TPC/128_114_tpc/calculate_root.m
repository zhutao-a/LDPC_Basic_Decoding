function [error_number,error1,error2]=calculate_root(S_1,S_3)%b=239信息+16校验+1奇偶,高次幂在前
%此函数求出的错误位置指的是b中的位置，例：一个错误a^234，则error1=255-234=11
%无法解出error_number=3，error1=0，error2=[0,0]
%一个错误error_number=1，error1=位置，error2=[0,0]
%两个错误error_number=2，error1=0，error2=[位置1,位置2]
error1=0;
error2=[0,0];
gf_table=gf_table_generate();%查找表
for i=1:256%求出S1的幂
    if isequal(S_1,gf_table(i,:))
        m1=i-1;%求出S1对应元素的幂
        break;
    end
end
if m1==255  %S1==0时即（S1）^3==0,m1multiply3表示（S1)^3的幂
    m1multiply3=255;%（S1）^3对应元素幂为0
else        %S1~=0时
    m1multiply3=mod(3*m1,255);%（S1）^3对应元素幂
end
S1_power3=gf_table(m1multiply3+1,:);%（S1）^3对应元素的二进制序列
temp=mod(S_3+S1_power3,2);%计算出(S1)^3+S3的二进制序列
zero_8=[0,0,0,0,0,0,0,0];
if ( isequal(S_1,zero_8) )&&( isequal(temp,zero_8) )%S1=0and(S1)^3+S3=0,没有出错
    error_number=0;
elseif (isequal(S_1,zero_8))&&( ~isequal(temp,zero_8) )%S1=0,S3+(S1)^3~=0,无法解出错误
    error_number=3;
elseif (~isequal(S_1,zero_8) )&&(isequal(temp,zero_8) )%S1~=0,S3+(S1)^3=0,有一个错误
    error_number=1;%此时错误位置beta1=a^j1=S1=sigma1=a^m1,即错误位置幂就是j1=m1
    error1=255-m1;
else%S1~=0,S3+(S1)^3~=0,两错误或解不出,错误位置多项式sigma2*x^2+sigma1*x=1
    %错误位置多项式变为(x')^2+x'=u,其中u=sigma2/(sigma1)^2 x=x'*(sigma1/sigma2) sigma1=S1 sigma2=[(S1)^3+S3]/S1
    for i=1:255%计算出(S1)^3+S3对应的幂
        if isequal(temp,gf_table(i,:))
             temp_power=i-1;
             break;
        end
    end
    u_power=mod(temp_power-m1multiply3,255);%计算出u的幂
    u=gf_table(u_power+1,:);%u的二进制表示，低次幂在前
    if u(6)==0%a^5对应系数为0，表明方程有解，有两错误位置
        error_number=2;
        y=[gf_table(85+1,:);gf_table(11+1,:);gf_table(22+1,:);gf_table(18+1,:);
           gf_table(44+1,:);gf_table(255+1,:);gf_table(36+1,:);gf_table(54+1,:)];%预先设定的y
       u_root1=zeros(1,8);
       for i=1:8%计算出变化错误位置多项式第一个根的二进制序列
            u_root1=mod(u_root1+u(i)*y(i,:),2);
       end
       u_root2=mod(u_root1+ gf_table(1,:),2);%计算出变化错误位置多项式第二个根的二进制序列;
       for i=1:255%求出u_root1，u_root2对应的幂
           if isequal(u_root1,gf_table(i,:))
               u_root1_power=i-1;
           end
           if isequal(u_root2,gf_table(i,:))
               u_root2_power=i-1;
           end
       end
       root1_power=mod(2*m1+u_root1_power-temp_power,255);%求出实际错误位置多项式根root1的幂(0->254)
       root2_power=mod(2*m1+u_root2_power-temp_power,255);%求出实际错误位置多项式根root2的幂
       error2=[255-mod(255-root1_power,255),255-mod(255-root2_power,255)];
    else%a^5对应系数为1，无法解码
    error_number=3;
    end    
end

