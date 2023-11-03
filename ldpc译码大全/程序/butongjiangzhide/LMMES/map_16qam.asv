function output=map_16qam(input)%完成一个ofdm块的16QAM映射
[N,NL]=size(input);%N为512  NL为100
 N=N/4;%N为128
 output=zeros(N,NL);%产生一个128行 100列的矩阵
  for j=1:NL
      for n=1:N
          for ic=1:4
              qam_input(ic)=input((n-1)*4+ic,j);  %每次取4个bit 
          end
          output(n,j)=qam16(qam_input);           %output每一列为一次FFT运算的信号，与一个ofdm符号结构相似
      end
   
  end   
