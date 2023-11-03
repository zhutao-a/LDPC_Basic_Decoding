function analog_weight_index_out=sort_4(analog_weight_index_in)%前面是模拟重量，后面是索引
data_max=63;

step1_data0=zeros(1,2);
step1_data1=zeros(1,2);
step1_data2=zeros(1,2);
step1_data3=zeros(1,2);

if(analog_weight_index_in(1,1)==analog_weight_index_in(2,1))
    step1_data0=analog_weight_index_in(2,:);
    step1_data1(1)=data_max;step1_data1(2)=analog_weight_index_in(1,2);
elseif(analog_weight_index_in(1,1)<analog_weight_index_in(2,1))
    step1_data0=analog_weight_index_in(1,:);
    step1_data1=analog_weight_index_in(2,:);
else
    step1_data0=analog_weight_index_in(2,:);
    step1_data1=analog_weight_index_in(1,:);
end

if(analog_weight_index_in(3,1)==analog_weight_index_in(4,1))
    step1_data2=analog_weight_index_in(4,:);
    step1_data3(1)=data_max;step1_data3(2)=analog_weight_index_in(3,2);
elseif(analog_weight_index_in(3,1)<analog_weight_index_in(4,1))
    step1_data2=analog_weight_index_in(3,:);
    step1_data3=analog_weight_index_in(4,:);
else
    step1_data2=analog_weight_index_in(4,:);
    step1_data3=analog_weight_index_in(3,:);
end       
       

step2_data0=zeros(1,2);
step2_data1=zeros(1,2);
step2_data2=zeros(1,2);
step2_data3=zeros(1,2);

if(step1_data0(1)==step1_data2(1))
    step2_data0=step1_data2;
    step2_data1(1)=data_max;step2_data1(2)=step1_data0(2);
elseif(step1_data0(1)<step1_data2(1))
    step2_data0=step1_data0;
    step2_data1=step1_data2;
else
    step2_data0=step1_data2;
    step2_data1=step1_data0;
end   

if(step1_data1(1)==step1_data3(1))
    step2_data2=step1_data3;
    step2_data3(1)=data_max;step2_data3(2)=step1_data1(2);
elseif(step1_data1(1)<step1_data3(1))
    step2_data2=step1_data1;
    step2_data3=step1_data3;
else
    step2_data2=step1_data3;
    step2_data3=step1_data1;
end   


step3_data0=zeros(1,2);
step3_data1=zeros(1,2);
step3_data2=zeros(1,2);
step3_data3=zeros(1,2);

step3_data0=step2_data0;
step3_data3=step2_data3;
if(step2_data1(1)==step2_data2(1))
    step3_data1=step2_data2;
    step3_data2(1)=data_max;step3_data2(2)=step2_data1(2);
elseif(step2_data1(1)<step2_data2(1))
    step3_data1=step2_data1;
    step3_data2=step2_data2;
else
    step3_data1=step2_data2;
    step3_data2=step2_data1;
end   

analog_weight_index_out=zeros(4,2);

analog_weight_index_out(1,:)=step3_data0;
analog_weight_index_out(2,:)=step3_data1;
if(step3_data2(1)==step3_data3(1))
    analog_weight_index_out(3,:)=step3_data3;
    analog_weight_index_out(4,1)=data_max;analog_weight_index_out(4,2)=step3_data2(2);
elseif(step3_data2(1)<step3_data3(1))
    analog_weight_index_out(3,:)=step3_data2;
    analog_weight_index_out(4,:)=step3_data3;
else
    analog_weight_index_out(3,:)=step3_data3;
    analog_weight_index_out(4,:)=step3_data2;
end  



