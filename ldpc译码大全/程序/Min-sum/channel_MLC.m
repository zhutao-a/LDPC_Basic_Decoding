%模拟flash发成错误的过程
%输入：码字u，错误位数e
%输出：加入错误的数组y，发生错误的位errorbit，包含每一位错误率估计信息的数组p

function [y,errorbit,p]=channel_MLC(u,e,H,P,rearranged_cols)
% 11 10 00 01
[m,n]=size(H);
p=ones(1,n);
c2=round(rand(1,n-m));%生成信息
u2=ldpc_encode_G(c2,P,rearranged_cols);%用生成好的P编码
u_combine=[u2;u];%u作为LSB
errorbit=[];
uplus=u+u2;
%找到01的位置
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

%找到10的位置
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