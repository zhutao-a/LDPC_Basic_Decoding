function ecode=lfsr_encoder(msg,N,K)%msg大小必须为239*239，生成系统扩展码，高次在前，此编码快于matlab自带的编码函数
gx=[1,0,1,1,0,1,1,1,1,0,1,1,0,0,0,1,1];%gx为生成多项式系数,注意高次在前
g=fliplr(gx);%为了使g1g2..gm-1与向量下标相对应，因此左右反转一下
ecode=zeros(1,N);%编码后码字
for j=1:239
    ecode(1,j)=msg(1,j);
end
for i=1:1%行编码
    r=zeros(1,16);%初始化需要添加的校验位
    u=ecode(i,1:K);%将第i行赋值给u
    d=zeros(1,16);%用于存储寄存器内的值,即上一轮的r
    for k=1:K%对第i行进行编码，生成校验位r,对应论文中的迭代公式
        temp=xor(d(16),u(k));%相当于计算(r[i+1,m-1]+ui)
        r(1)=temp*g(1);%r[i,0]=(r[i+1,m-1]+ui)*g0
        r(2)=xor(d(1),temp*g(2));%r[i,1]=(r[i+1,m-1]+ui)*g1+r[i+1,0]
        r(3)=xor(d(2),temp*g(3));%r[i,2]=(r[i+1,m-1]+ui)*g2+r[i+1,1]
        r(4)=xor(d(3),temp*g(4));
        r(5)=xor(d(4),temp*g(5));
        r(6)=xor(d(5),temp*g(6));
        r(7)=xor(d(6),temp*g(7));
        r(8)=xor(d(7),temp*g(8));
        r(9)=xor(d(8),temp*g(9));
        r(10)=xor(d(9),temp*g(10));
        r(11)=xor(d(10),temp*g(11));
        r(12)=xor(d(11),temp*g(12));
        r(13)=xor(d(12),temp*g(13));
        r(14)=xor(d(13),temp*g(14));
        r(15)=xor(d(14),temp*g(15));
        r(16)=xor(d(15),temp*g(16));%r[i,15]=(r[i+1,m-1]+ui)*g15++r[i+1,14]
        d=r;%存储前一轮迭代时的校验位
    end
    ecode(i,240:255)=fliplr(r);%将r16,r15...r1依次输出给校验位
    parity=mod(sum(ecode(i,1:255)),2);%求出第i行的奇偶校验位
    ecode(i,256)=parity;%奇偶校验位赋值
end
