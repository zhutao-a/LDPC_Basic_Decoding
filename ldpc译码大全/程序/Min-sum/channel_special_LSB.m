function [y,errorbit,p]=channel_special_LSB(u,e)
load('P440x8632(8192).mat');
load('rearranged_cols440x8632.mat');
n=length(u);
p=ones(1,n);
%测试LSB
dataname='第20000次擦除单页数据.xlsx';
ypart=xlsread(dataname,'B24578:B32769');
ypart=ypart';
ur=reorder_bits_reverse(u,rearranged_cols);
y=[ur(1:440),ypart];

y2part=xlsread(dataname,'D24578:D32769');
y2part=y2part';
c2=xlsread(dataname,'C24578:C32769');
c2=c2';
u2=ldpc_encode_G(c2,P,rearranged_cols);
u2r=reorder_bits_reverse(u2,rearranged_cols);
y2=[u2r(1:440),y2part];

y_combine=[y2;y];
for ii=1:n
    if y_combine(:,ii)==[0;0]
        p(ii)=e/n;
    elseif y_combine(:,ii)==[1;1]
        p(ii)=e/n;
    else
        p(ii)=0.00001;
    end
end
errorbit=1;
y= reorder_bits(y,rearranged_cols);
p= reorder_bits(p,rearranged_cols);
