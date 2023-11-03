function dataout=select_8_to_6min(data)%输入data大小(2,8)    矩阵(1,8)值(2,8)为索引
%从大到小输出
step1_data=zeros(8,2); 
if(data(1,1)>=data(2,1))
    step1_data(1,:)=data(1,:);
    step1_data(2,:)=data(2,:);
else
    step1_data(1,:)=data(2,:);
    step1_data(2,:)=data(1,:);
end
if(data(3,1)>=data(4,1))
    step1_data(3,:)=data(3,:);
    step1_data(4,:)=data(4,:);
else
    step1_data(3,:)=data(4,:);
    step1_data(4,:)=data(3,:);
end
if(data(5,1)>=data(6,1))
    step1_data(5,:)=data(5,:);
    step1_data(6,:)=data(6,:);
else
    step1_data(5,:)=data(6,:);
    step1_data(6,:)=data(5,:);
end
if(data(7,1)>=data(8,1))
    step1_data(7,:)=data(7,:);
    step1_data(8,:)=data(8,:);
else
    step1_data(7,:)=data(8,:);
    step1_data(8,:)=data(7,:);
end

step2_data=zeros(8,2); 
if(step1_data(1,1)>=step1_data(3,1))
    step2_data(1,:)=step1_data(1,:);
    step2_data(2,:)=step1_data(3,:);
else
    step2_data(1,:)=step1_data(3,:);
    step2_data(2,:)=step1_data(1,:);
end
if(step1_data(2,1)>=step1_data(4,1))
    step2_data(3,:)=step1_data(2,:);
    step2_data(4,:)=step1_data(4,:);
else
    step2_data(3,:)=step1_data(4,:);
    step2_data(4,:)=step1_data(2,:);
end
if(step1_data(5,1)>=step1_data(7,1))
    step2_data(5,:)=step1_data(5,:);
    step2_data(6,:)=step1_data(7,:);
else
    step2_data(5,:)=step1_data(7,:);
    step2_data(6,:)=step1_data(5,:);
end
if(step1_data(6,1)>=step1_data(8,1))
    step2_data(7,:)=step1_data(6,:);
    step2_data(8,:)=step1_data(8,:);
else
    step2_data(7,:)=step1_data(8,:);
    step2_data(8,:)=step1_data(6,:);
end

step3_data=zeros(8,2); 
step3_data(1,:)=step2_data(1,:);
if(step2_data(2,1)>=step2_data(3,1))
    step3_data(2,:)=step2_data(2,:);
    step3_data(3,:)=step2_data(3,:);
else
    step3_data(2,:)=step2_data(3,:);
    step3_data(3,:)=step2_data(2,:);
end
step3_data(4,:)=step2_data(4,:);
step3_data(5,:)=step2_data(5,:);
if(step2_data(6,1)>=step2_data(7,1))
    step3_data(6,:)=step2_data(6,:);
    step3_data(7,:)=step2_data(7,:);
else
    step3_data(6,:)=step2_data(7,:);
    step3_data(7,:)=step2_data(6,:);
end
step3_data(8,:)=step2_data(8,:);

step4_data=zeros(7,2); 
if(step3_data(1,1)>=step3_data(5,1))
    step4_data(1,:)=step3_data(5,:);
else
    step4_data(1,:)=step3_data(1,:);
end
if(step3_data(3,1)>=step3_data(7,1))
    step4_data(2,:)=step3_data(3,:);
    step4_data(3,:)=step3_data(7,:);
else
    step4_data(2,:)=step3_data(7,:);
    step4_data(3,:)=step3_data(3,:);
end
if(step3_data(2,1)>=step3_data(6,1))
    step4_data(4,:)=step3_data(2,:);
    step4_data(5,:)=step3_data(6,:);
else
    step4_data(4,:)=step3_data(6,:);
    step4_data(5,:)=step3_data(2,:);
end
if(step3_data(4,1)>=step3_data(8,1))
    step4_data(6,:)=step3_data(4,:);
    step4_data(7,:)=step3_data(8,:);
else
    step4_data(6,:)=step3_data(8,:);
    step4_data(7,:)=step3_data(4,:);
end

step5_data=zeros(7,2); 
if(step4_data(1,1)>=step4_data(2,1))
    step5_data(1,:)=step4_data(1,:);
    step5_data(2,:)=step4_data(2,:);
else
    step5_data(1,:)=step4_data(2,:);
    step5_data(2,:)=step4_data(1,:);
end
step5_data(3,:)=step4_data(3,:);
step5_data(4,:)=step4_data(4,:);
if(step4_data(5,1)>=step4_data(6,1))
    step5_data(5,:)=step4_data(5,:);
    step5_data(6,:)=step4_data(6,:);
else
    step5_data(5,:)=step4_data(6,:);
    step5_data(6,:)=step4_data(5,:);
end
step5_data(7,:)=step4_data(7,:);

dataout=zeros(6,2);
if(step5_data(1,1)>=step5_data(4,1))
    dataout(1,:)=step5_data(4,:);
else
    dataout(1,:)=step5_data(1,:);
end
if(step5_data(2,1)>=step5_data(5,1))
    dataout(2,:)=step5_data(2,:);
    dataout(3,:)=step5_data(5,:);
else
    dataout(2,:)=step5_data(5,:);
    dataout(3,:)=step5_data(2,:);
end
if(step5_data(3,1)>=step5_data(6,1))
    dataout(4,:)=step5_data(3,:);
    dataout(5,:)=step5_data(6,:);
else
    dataout(4,:)=step5_data(6,:);
    dataout(5,:)=step5_data(3,:);
end
dataout(6,:)=step5_data(7,:);
















