 function x=input_b(N,NL,bit_per_carrier)%N为一个ofdm符号中的子符号个数，也就是没有加入CP的符号个数，就相当于子载波个数，但是这里不是BIT数，NL为一次仿真所包含的ofdm符号数
    for i=1:NL    %生成了一个有NL列的矩阵INPUT也就是OFDM的符号个数，相当于每列就是子载波个数乘以每个子符号的比特数  应该生成的是一个 128*4 行 100列的矩阵
         input_0=rand(1,bit_per_carrier*N);    %输入的二进制数据序列
         for j=1:bit_per_carrier*N
              if input_0(j)>0.5
                 input(j,i)=1;
               else 
                  input(j,i)=0;
              end
         end
     end
     x=input;
    