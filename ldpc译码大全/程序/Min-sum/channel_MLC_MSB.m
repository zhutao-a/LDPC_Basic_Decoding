function [y,errorbit,p]=channel_MLC_MSB(u,e,H,P,rearranged_cols)
% 11 10 00 01

[m,n]=size(H);
p=0.0001*ones(1,n);
c2=round(rand(1,n-m));%生成信息
u2=ldpc_encode_G(c2,P,rearranged_cols);%用生成好的P编码
u_combine=[u;u2];%u作为MSB

uplus=u+u2;
position00=find(uplus==0);%找到00的位置(MSB加错误专用)
position00_len=length(position00);
error_bit_origin=randperm(position00_len);
errorbitposition=error_bit_origin(1:e);
errorbit=position00(errorbitposition);

for ii=1:e
    if u_combine(:,errorbit(ii))==[0;0]
        u_combine(:,errorbit(ii))=[1;0];
    end
end
y=u_combine(1,:); %MSB
for ii=1:n
    if u_combine(:,ii)==[1;0]
        p(ii)=8/3*e/n;
    else
        p(ii)=0;
    end
end