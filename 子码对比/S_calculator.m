function S_k=S_calculator(b,k,gf_table)%计算校正子，S_k表示对应的二进制序列,b表示硬盘决后的码字，高次幂在前
l_b=length(b);%l_b=256
r=b(1:l_b-1);%除去最后一位奇偶校验位
l_r=l_b-1;%l_r=255
temp=zeros(1,l_r);
%temp=k0+k1*a^1+k2*a^2+...+(kl_r-1)*a^(l_r-1)

for i=1:l_r   %将校正子大于l_r次幂的部分模l_r从而降幂，temp低幂在前，高幂在后（注意r是高次在前）
    if r(i)==1%从左往右，此时高次幂在前
        j=mod((l_r-i)*k,l_r);%r高次在前，其幂为l_r-i,求出mod l_r后剩余的幂次j(注意区分gf域的幂与多项式的幂)
        temp(j+1)=xor(temp(j+1),1);%第一项为幂0项，所以幂j处在j+1
    end
end

S_k=zeros(1,log2(l_r+1));%S_k=[0,0,0,0,0,0,0,0]

for i=1:l_r%将temp里面各次幂的加法利用查找表转为gf域内的一个元素,即S_k二进制序列
    if temp(i)==1 %存在a^(i-1)这一项
        S_k=mod(S_k+gf_table(i,:),2);
    end
end







