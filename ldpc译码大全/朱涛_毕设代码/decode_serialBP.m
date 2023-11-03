function [itertimes,vHat] = decode_serialBP(rx, H,N0, iteration)
%����BP�㷨
[M ,N] = size(H);		
Lci = (-4*rx./N0)';
LQi=Lci;
Lrji = zeros(M, N);
Lqij = H.*repmat(Lci, M, 1);
alphaij = sign(Lqij);  
betaij = abs(Lqij);
prodallofalphaij=zeros(M,1);
minofbetaij=zeros(M,1);
for i = 1:M               %�ҵ�betaij������Сֵ��alphaij��0Ԫ�صĳ˻�
  c1 = find(H(i, :));   
  minofbetaij(i)= realmax;
  for k1 = 1:length(c1)          %�ҵ���index(j)�������Сbetaijֵ
     if betaij(i, c1(k1)) < minofbetaij(i)
        minofbetaij(i) = betaij(i, c1(k1));
     end        
  end % for l
  prodallofalphaij(i) = prod(alphaij(i, c1)); 
end % for i 


for n = 1:iteration                             %����iteration��
   fprintf('Iteration : %d\n', n);              %��ӡ��������
   itertimes=n;                                 %��ȡ��������
   
   for j = 1:N                      %ÿ�θ���һ������   
       
       %ˮƽ����һ��
       prodOfalphaij =prodallofalphaij.*alphaij(:,j);%prodallOfalphaij��alphaij���з�0Ԫ�صĳ˻� m*1
       mm=minofbetaij;                                     %mm�ǳ�ȥindex(j)�е���Сֵ
       c1=find( H( :,j ) );                          %��index(j)�еķ�0Ԫ��
       for k1=1:length(c1)                                   %��ȥindex(j)��betaij���з���Ԫ�ص���Сֵ m*1
           if mm( c1(k1) )==betaij( c1(k1) ,j )%���index(j)�еĵ�c1(k)������Сֵ����Ҫ�滻
               mm( c1(k1) )=realmax;                
               c2=find( H( c1(k1),: ) );                     %�ҵ�c1(k)�еķ�0Ԫ��
               for k2=1:length(c2)
                   if c2(k2)~=j                       %��ȥindex(j)��
                       if betaij(c1(k1),c2(k2))<mm( c1(k1) )
                           mm( c1(k1) )=betaij(c1(k1),c2(k2));
                       end
                   end
               end 
           end
       end
       Lrji(:,j) = prodOfalphaij.*mm;       %����Lrji��index(j)��
      %��ֱ����һ��
      for k1 = 1:length(c1)         
         Lqij(c1(k1),j)= Lci( j ) + sum( Lrji( c1, j ) ) - Lrji( c1(k1), j );
      end % for k
      for k1=1:length(c1)
          prodallofalphaij(c1(k1))=prodallofalphaij(c1(k1))*alphaij(c1(k1),j)*sign(Lqij(c1(k1),j));
          alphaij( c1(k1),j )= sign(Lqij( c1(k1),j) );  %���µ�������index(j)��
          betaij( c1(k1),j ) = abs(Lqij( c1(k1),j ) );  %���µ�������index(j)��
          if betaij(c1(k1),j)<mm(c1(k1))
              mm(c1(k1))=betaij(c1(k1),j);
          end
      end
      minofbetaij=mm;
      LQi(j) = Lci(j) + sum(Lrji(c1, j));
      if LQi(j) < 0
         vHat(j) = 1;
      else
         vHat(j) = 0;
      end 
   end % for j
   
   if mod(H*vHat',2)==0
       break;
   end
end % for n


