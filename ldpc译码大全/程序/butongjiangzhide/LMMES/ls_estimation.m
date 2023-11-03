function output=ls_estimation(input,pilot_inter,pilot_sequence,pilot_num);
[N,NL]=size(input);%这里已经取出循环前缀 应该变成为128*110
output=zeros(N,NL-pilot_num);%产生除去导频列的矩阵
 i=1;
 count=0;
  while i<=NL
      Hi=input(:,i)./pilot_sequence;%pilot_sequence为导频复数列 除以它之后得到了信道的估计值
      count=count+1;
      if  count*pilot_inter<=(NL-pilot_num)%pilot_inter=10;%导频符号间隔为10     NL-pilot_num=100
      for j=((count-1)*pilot_inter+1):count*pilot_inter
      output(:,j)=input(:,(i+j-(count-1)*pilot_inter))./Hi;%从第二列一直到第十一列每列收到的值除以那个信道估计值  就是估计发送的值
  end
else
    for j=((count-1)*pilot_inter+1):(NL-pilot_num)%为了防止导频加的不均匀最后一个导频之后的值的处理
      output(:,j)=input(:,(i+j-(count-1)*pilot_inter))./Hi;
  end
end
      i=i+pilot_inter+1;
  end