function ecode=lfsr_encoder(msg)%msg��С����Ϊ113*113������ϵͳ��չ�룬�ߴ���ǰ
ecode=zeros(128,128);%���������
msg=gf(msg);

for i=1:113%�б���
    u= bchenc(msg(i,:),127,113);
    parity=mod(sum(double(u.x)),2);%�����i�е���żУ��λ
    ecode(i,:)=[double(u.x),parity];%��żУ��λ��ֵ
end

for i=1:128%�б���
    g=ecode(1:113,i)';%����i�и�ֵ��g
    g=gf(g);
    u=bchenc(g,127,113);
    parity=mod(sum(double(u.x)),2);
    ecode(:,i)=[double(u.x),parity]';
end
