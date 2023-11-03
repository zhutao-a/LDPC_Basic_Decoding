function ecode=lfsr_encoder(msg)%msg��С����Ϊ239*239������ϵͳ��չ�룬�ߴ���ǰ���˱������matlab�Դ��ı��뺯��
gx=[1,0,1,1,0,1,1,1,1,0,1,1,0,0,0,1,1];%gxΪ���ɶ���ʽϵ��,ע��ߴ���ǰ
g=fliplr(gx);%Ϊ��ʹg1g2..gm-1�������±����Ӧ��������ҷ�תһ��
ecode=zeros(256,256);%���������
for i=1:239%����Ϣλ��ֵ�����������
    for j=1:239
        ecode(i,j)=msg(i,j);
    end
end
for i=1:239%�б���
    r=zeros(1,16);%��ʼ����Ҫ��ӵ�У��λ
    u=ecode(i,1:239);%����i�и�ֵ��u
    d=zeros(1,16);%���ڴ洢�Ĵ����ڵ�ֵ,����һ�ֵ�r
    for k=1:239%�Ե�i�н��б��룬����У��λr,��Ӧ�����еĵ�����ʽ
        temp=xor(d(16),u(k));%�൱�ڼ���(r[i+1,m-1]+ui)
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
        d=r;%�洢ǰһ�ֵ���ʱ��У��λ
    end
    ecode(i,240:255)=fliplr(r);%��r16,r15...r1���������У��λ
    parity=mod(sum(ecode(i,1:255)),2);%�����i�е���żУ��λ
    ecode(i,256)=parity;%��żУ��λ��ֵ
end


for i=1:256%�б���
    r=zeros(1,16);%��ʼ����Ҫ��ӵ�У��λ
    u=ecode(1:239,i);%����i�и�ֵ��u
    d=zeros(1,16);%���ڴ洢�Ĵ����ڵ�ֵ,����һ�ֵ�r
    for k=1:239%�Ե�i�н��б��룬����У��λr,��Ӧ�����еĵ�����ʽ
        temp=xor(d(16),u(k));%�൱�ڼ���(r[i+1,m-1]+ui)
        r(1)=temp*g(1);%r[i,0]=(r[i+1,m-1]+ui)*g0
        r(2)=xor(d(1),temp*g(2));
        r(3)=xor(d(2),temp*g(3));
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
        r(16)=xor(d(15),temp*g(16));
        d=r;%�洢ǰһ�ֵ���ʱ��У��λ
    end
    ecode(240:255,i)=flipud(r');%��r16,r15...r1���������У��λ
    parity=mod(sum(ecode(1:255,i)),2);
    ecode(256,i)=parity;
end
