function [itertimes,vHat] = decode_serialBP(rx, H,N0, iteration)
%串行BP算法
[M ,N] = size(H);		
Lci = (-4*rx./N0)';
LQi=Lci;
Lrji = zeros(M, N);
Lqij = H.*repmat(Lci, M, 1);
alphaij = sign(Lqij);  
betaij = abs(Lqij);
prodallofalphaij=zeros(M,1);
minofbetaij=zeros(M,1);
for i = 1:M               %找到betaij各行最小值与alphaij非0元素的乘积
  c1 = find(H(i, :));   
  minofbetaij(i)= realmax;
  for k1 = 1:length(c1)          %找到除index(j)列外的最小betaij值
     if betaij(i, c1(k1)) < minofbetaij(i)
        minofbetaij(i) = betaij(i, c1(k1));
     end        
  end % for l
  prodallofalphaij(i) = prod(alphaij(i, c1)); 
end % for i 


for n = 1:iteration                             %迭代iteration次
   fprintf('Iteration : %d\n', n);              %打印迭代次数
   itertimes=n;                                 %获取迭代次数
   
   for j = 1:N                      %每次更新一个比特   
       
       %水平更新一列
       prodOfalphaij =prodallofalphaij.*alphaij(:,j);%prodallOfalphaij是alphaij各行非0元素的乘积 m*1
       mm=minofbetaij;                                     %mm是除去index(j)列的最小值
       c1=find( H( :,j ) );                          %找index(j)列的非0元素
       for k1=1:length(c1)                                   %除去index(j)列betaij各行非零元素的最小值 m*1
           if mm( c1(k1) )==betaij( c1(k1) ,j )%如果index(j)列的第c1(k)行是最小值，需要替换
               mm( c1(k1) )=realmax;                
               c2=find( H( c1(k1),: ) );                     %找到c1(k)行的非0元素
               for k2=1:length(c2)
                   if c2(k2)~=j                       %除去index(j)列
                       if betaij(c1(k1),c2(k2))<mm( c1(k1) )
                           mm( c1(k1) )=betaij(c1(k1),c2(k2));
                       end
                   end
               end 
           end
       end
       Lrji(:,j) = prodOfalphaij.*mm;       %更新Lrji的index(j)列
      %垂直更新一列
      for k1 = 1:length(c1)         
         Lqij(c1(k1),j)= Lci( j ) + sum( Lrji( c1, j ) ) - Lrji( c1(k1), j );
      end % for k
      for k1=1:length(c1)
          prodallofalphaij(c1(k1))=prodallofalphaij(c1(k1))*alphaij(c1(k1),j)*sign(Lqij(c1(k1),j));
          alphaij( c1(k1),j )= sign(Lqij( c1(k1),j) );  %更新迭代过的index(j)列
          betaij( c1(k1),j ) = abs(Lqij( c1(k1),j ) );  %更新迭代过的index(j)列
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


