function dataout=merge_select_8_to_4min(datain_a,datain_b)%前面是模拟重量，后面是索引
data_max=63;

step1_data0=zeros(1,2);
step1_data1=zeros(1,2);
step1_data2=zeros(1,2);
step1_data3=zeros(1,2);
step1_data4=zeros(1,2);
step1_data5=zeros(1,2);
step1_data6=zeros(1,2);

if(datain_a(1,1)==datain_b(1,1))
    step1_data0=datain_b(1,:);
    step1_data1(1)=data_max;step1_data1(2)=datain_a(1,2);
elseif(datain_a(1,1)<datain_b(1,1))
    step1_data0=datain_a(1,:);
    step1_data1=datain_b(1,:);
else
    step1_data0=datain_b(1,:);
    step1_data1=datain_a(1,:);
end

if(datain_a(2,1)==datain_b(2,1))
    step1_data2=datain_b(2,:);
    step1_data3(1)=data_max;step1_data3(2)=datain_a(2,2);
elseif(datain_a(2,1)<datain_b(2,1))
    step1_data2=datain_a(2,:);
    step1_data3=datain_b(2,:);
else
    step1_data2=datain_b(2,:);
    step1_data3=datain_a(2,:);
end

if(datain_a(3,1)==datain_b(3,1))
    step1_data4=datain_b(3,:);
    step1_data5(1)=data_max;step1_data5(2)=datain_a(3,2);
elseif(datain_a(3,1)<datain_b(3,1))
    step1_data4=datain_a(3,:);
    step1_data5=datain_b(3,:);
else
    step1_data4=datain_b(3,:);
    step1_data5=datain_a(3,:);
end

if(datain_a(4,1)<datain_b(4,1))
    step1_data6=datain_a(4,:);
else
    step1_data6=datain_b(4,:);
end


step2_data0=zeros(1,2);
step2_data1=zeros(1,2);
step2_data2=zeros(1,2);
step2_data3=zeros(1,2);
step2_data4=zeros(1,2);
step2_data5=zeros(1,2);

step2_data0=step1_data0;
step2_data3=step1_data3;
step2_data4=step1_data4;
if(step1_data1(1)==step1_data2(1))
    step2_data1=step1_data2;
    step2_data2(1)=data_max;step2_data2(2)=step1_data1(2);
elseif(step1_data1(1)<step1_data2(1))
    step2_data1=step1_data1;
    step2_data2=step1_data2;
else
    step2_data1=step1_data2;
    step2_data2=step1_data1;
end

if(step1_data5(1)<step1_data6(1))
    step2_data5=step1_data5;
else
    step2_data5=step1_data6;
end


step3_data0=zeros(1,2);
step3_data1=zeros(1,2);
step3_data2=zeros(1,2);
step3_data3=zeros(1,2);
step3_data4=zeros(1,2);
step3_data5=zeros(1,2);

step3_data0=step2_data0     ;
step3_data1=step2_data1     ;
step3_data4=step2_data4     ;
step3_data5=step2_data5     ;
if(step2_data2(1)==step2_data3(1))
    step3_data2=step2_data3;
    step3_data3(1)=data_max;step3_data3(2)=step2_data2(2);
elseif(step2_data2(1)<step2_data3(1))
    step3_data2=step2_data2;
    step3_data3=step2_data3;
else
    step3_data2=step2_data3;
    step3_data3=step2_data2;
end

step4_data0=zeros(1,2);
step4_data1=zeros(1,2);
step4_data2=zeros(1,2);
step4_data3=zeros(1,2);
step4_data4=zeros(1,2);

step4_data0=step3_data0     ;
step4_data1=step3_data1     ;
if(step3_data2(1)==step3_data4(1))
    step4_data2=step3_data4;
    step4_data3(1)=data_max;step4_data3(2)=step3_data2(2);
elseif(step3_data2(1)<step3_data4(1))
    step4_data2=step3_data2;
    step4_data3=step3_data4;
else
    step4_data2=step3_data4;
    step4_data3=step3_data2;
end

if(step3_data3(1)<step3_data5(1))
    step4_data4=step3_data3;
else
    step4_data4=step3_data5;
end

dataout=zeros(4,2);

dataout(1,:)=step4_data0;
dataout(2,:)=step4_data1;
dataout(3,:)=step4_data2;
if(step4_data3(1)<step4_data4(1))
    dataout(4,:)=step4_data3;
else
    dataout(4,:)=step4_data4;
end



