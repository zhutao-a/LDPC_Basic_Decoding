function ecode=lfsr_encoder(msg)%msg大小必须为113*113，生成系统扩展码，高次在前
ecode=zeros(128,128);%编码后码字
msg=gf(msg);

for i=1:113%行编码
    u= bchenc(msg(i,:),127,113);
    parity=mod(sum(double(u.x)),2);%求出第i行的奇偶校验位
    ecode(i,:)=[double(u.x),parity];%奇偶校验位赋值
end

for i=1:128%列编码
    g=ecode(1:113,i)';%将第i列赋值给g
    g=gf(g);
    u=bchenc(g,127,113);
    parity=mod(sum(double(u.x)),2);
    ecode(:,i)=[double(u.x),parity]';
end
