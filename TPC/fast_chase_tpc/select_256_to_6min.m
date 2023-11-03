function LRP_index=select_256_to_6min(abs_r)
data_ram_max=realmax;%存在ram里面的最大值
data=zeros(256,2);
for i=1:255%添加上与硬件相同的索引
    data(i,1)=abs_r(i);
    data(i,2)=256-i;
end
data(256,1)=data_ram_max;
data(256,2)=0;

lay1_out=zeros(192,2);
for i=1:32
       data_out=select_8_to_6min(flipud(data((8*i-7):8*i,:)));
       lay1_out((6*i-5):6*i,:)=flipud(data_out);
end

lay2_out=zeros(96,2);
for i=1:16
        data_out=select_12_to_6min(flipud(lay1_out((12*i-11):12*i,:)));
        lay2_out((6*i-5):6*i,:)=flipud(data_out);
end

lay3_out=zeros(48,2);
for i=1:8
        data_out=select_12_to_6min(flipud(lay2_out((12*i-11):12*i,:)));
        lay3_out((6*i-5):6*i,:)=flipud(data_out);
end

lay4_out=zeros(24,2);
for i=1:4
        data_out=select_12_to_6min(flipud(lay3_out((12*i-11):12*i,:)));
        lay4_out((6*i-5):6*i,:)=flipud(data_out);
end

lay5_out=zeros(12,2);

for i=1:2
        data_out=select_12_to_6min(flipud(lay4_out((12*i-11):12*i,:)));
        lay5_out((6*i-5):6*i,:)=flipud(data_out);
end

data_out=select_12_to_6min(flipud(lay5_out));
LRP_index=data_out(:,2);





