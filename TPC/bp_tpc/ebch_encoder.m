%扩展ebch编码器,bch:n=2^m-1,k=n-mt
%msg为待编码序列，size(msg)=[1,k]，高次幂在前
%gx为生成多项式，size(gx)=[1,mt+1]，高次幂在前
%原理参考:reference/BCH编译码算法基础
%此工程m=8,t=2,k=255-16=239
function ecode=ebch_encoder(msg)
gx=[1,0,1,1,0,1,1,1,1,0,1,1,0,0,0,1,1];%高次幂在前，注意gx(2)才开始对应gx(mt-1)
k=length(msg);%消息序列长度
m=length(gx);%校验位长度
n=k+m;
ecode=zeros(1,n);
ecode(1:k)=msg;
p_current=zeros(1,m-1);%当前迭代的校验位，高次幂在前
p_last=zeros(1,m-1);%上一轮迭代的校验位，高次幂在前

%利用k次迭代求解出bch的校验位
for i=1:239
    temp=xor(p_last(1),msg(i));%相当于计算(r[i+1,m-1]+ui)
    
    p_current(1)=xor(temp*gx(2),p_last(2));%r[i,mt-1]=(r[i+1,mt-1]+ui) * g(mt-1) + r[i+1,mt-2]
    p_current(2)=xor(temp*gx(3),p_last(3));%r[i,mt-2]=(r[i+1,mt-1]+ui) * g(mt-2) + r[i+1,mt-3]
    p_current(3)=xor(temp*gx(4),p_last(4));
    p_current(4)=xor(temp*gx(5),p_last(5));
    p_current(5)=xor(temp*gx(6),p_last(6));
    p_current(6)=xor(temp*gx(7),p_last(7));
    p_current(7)=xor(temp*gx(8),p_last(8));
    p_current(8)=xor(temp*gx(9),p_last(9));
    p_current(9)=xor(temp*gx(10),p_last(10));
    p_current(10)=xor(temp*gx(11),p_last(11));
    p_current(11)=xor(temp*gx(12),p_last(12));
    p_current(12)=xor(temp*gx(13),p_last(13));
    p_current(13)=xor(temp*gx(14),p_last(14));
    p_current(14)=xor(temp*gx(15),p_last(15));
    p_current(15)=xor(temp*gx(16),p_last(16));%r[i,1]=(r[i+1,mt-1]+ui) * g1 + r[i+1,0]
    p_current(16)=temp*gx(17);%r[i,0]=(r[i+1,mt-1]+ui) * g0

    p_last=p_current;%存储前一轮迭代时的校验位
end
ecode(240:255)=p_current;%添加校验位，高次幂在前
ecode(256)=mod(sum(ecode(1:255)),2);%添加奇偶校验位


