function output=ls_estimation(input,pilot_inter,pilot_sequence,pilot_num);
[N,NL]=size(input);%�����Ѿ�ȡ��ѭ��ǰ׺ Ӧ�ñ��Ϊ128*110
output=zeros(N,NL-pilot_num);%������ȥ��Ƶ�еľ���
 i=1;
 count=0;
  while i<=NL
      Hi=input(:,i)./pilot_sequence;%pilot_sequenceΪ��Ƶ������ ������֮��õ����ŵ��Ĺ���ֵ
      count=count+1;
      if  count*pilot_inter<=(NL-pilot_num)%pilot_inter=10;%��Ƶ���ż��Ϊ10     NL-pilot_num=100
      for j=((count-1)*pilot_inter+1):count*pilot_inter
      output(:,j)=input(:,(i+j-(count-1)*pilot_inter))./Hi;%�ӵڶ���һֱ����ʮһ��ÿ���յ���ֵ�����Ǹ��ŵ�����ֵ  ���ǹ��Ʒ��͵�ֵ
  end
else
    for j=((count-1)*pilot_inter+1):(NL-pilot_num)%Ϊ�˷�ֹ��Ƶ�ӵĲ��������һ����Ƶ֮���ֵ�Ĵ���
      output(:,j)=input(:,(i+j-(count-1)*pilot_inter))./Hi;
  end
end
      i=i+pilot_inter+1;
  end