 function x=input_b(N,NL,bit_per_carrier)%NΪһ��ofdm�����е��ӷ��Ÿ�����Ҳ����û�м���CP�ķ��Ÿ��������൱�����ز��������������ﲻ��BIT����NLΪһ�η�����������ofdm������
    for i=1:NL    %������һ����NL�еľ���INPUTҲ����OFDM�ķ��Ÿ������൱��ÿ�о������ز���������ÿ���ӷ��ŵı�����  Ӧ�����ɵ���һ�� 128*4 �� 100�еľ���
         input_0=rand(1,bit_per_carrier*N);    %����Ķ�������������
         for j=1:bit_per_carrier*N
              if input_0(j)>0.5
                 input(j,i)=1;
               else 
                  input(j,i)=0;
              end
         end
     end
     x=input;
    