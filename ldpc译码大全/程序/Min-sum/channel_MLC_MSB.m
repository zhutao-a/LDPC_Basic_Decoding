function [y,errorbit,p]=channel_MLC_MSB(u,e,H,P,rearranged_cols)
% 11 10 00 01

[m,n]=size(H);
p=0.0001*ones(1,n);
c2=round(rand(1,n-m));%������Ϣ
u2=ldpc_encode_G(c2,P,rearranged_cols);%�����ɺõ�P����
u_combine=[u;u2];%u��ΪMSB

uplus=u+u2;
position00=find(uplus==0);%�ҵ�00��λ��(MSB�Ӵ���ר��)
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