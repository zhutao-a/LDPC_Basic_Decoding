%ģ��flash���ɴ���Ĺ���
%���룺����u������λ��e
%�����������������y�����������λerrorbit������ÿһλ�����ʹ�����Ϣ������p

function [y,errorbit,p]=channel_MLC(u,e,H,P,rearranged_cols)
% 11 10 00 01
[m,n]=size(H);
p=ones(1,n);
c2=round(rand(1,n-m));%������Ϣ
u2=ldpc_encode_G(c2,P,rearranged_cols);%�����ɺõ�P����
u_combine=[u2;u];%u��ΪLSB
errorbit=[];
uplus=u+u2;
%�ҵ�01��λ��
position01=[];
flag=1;
for ii=1:n
    if u_combine(:,ii)==[0;1]
        position01(flag)=ii;
        flag=flag+1;
    end
end
position01_len=length(position01);
error_bit_origin01=randperm(position01_len);
errorbitposition01=error_bit_origin01(1:ceil(10*e/11));
errorbit01=position01(errorbitposition01);

%�ҵ�10��λ��
position10=[];
flag=1;
for ii=1:n
    if u_combine(:,ii)==[1;0]
        position10(flag)=ii;
        flag=flag+1;
    end
end
position10_len=length(position10);
error_bit_origin10=randperm(position10_len);
errorbitposition10=error_bit_origin10(1:ceil(1*e/11));
errorbit10=position10(errorbitposition10);
errorbit=[errorbit01,errorbit10];

for ii=1:length(errorbit)
    if u_combine(:,errorbit(ii))==[0;1]
        u_combine(:,errorbit(ii))=[0;0];
    elseif u_combine(:,errorbit(ii))==[1;0]
        u_combine(:,errorbit(ii))=[1;1];
    end
end

y=u_combine(2,:); %LSB
for ii=1:n
    if u_combine(:,ii)==[0;0]
        p(ii)=8/3*10/11*e/n;
    elseif u_combine(:,ii)==[1;1]
        p(ii)=8/3*1/11*e/n;
    else
        p(ii)=0.00001;
    end
end