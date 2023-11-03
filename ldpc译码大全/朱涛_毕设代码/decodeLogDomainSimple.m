function [itertimes,vHat] = decodeLogDomainSimple(rx, H,N0, iteration)
%MS最小和算法
[M ,N] = size(H);		
Lci = (-4*rx./N0)';
LQi=zeros(1,N);
Lrji = zeros(M, N);
Lqij = H.*repmat(Lci, M, 1);
prodallofalphaij=zeros(M,1);
minofbetaij=zeros(M,1);
alphaij = sign(Lqij);  
betaij = abs(Lqij);
for n = 1:iteration                             %迭代iteration次
   fprintf('Iteration : %d\n', n);              %打印迭代次数
   itertimes=n;                                 %获取迭代次数
    for i = 1:M               %找到betaij各行最小值与alphaij非0元素的乘积
      c1 = find(H(i, :));   
      minofbetaij(i)= realmax;
      for l = 1:length(c1)          %找到除index(j)列外的最小betaij值
         if betaij(i, c1(l)) < minofbetaij(i)
            minofbetaij(i) = betaij(i, c1(l));
         end        
      end % for l
      prodallofalphaij(i) = prod(alphaij(i, c1)); 
    end % for i 
    
   for i = 1:M                  %更新Lrji
      c1 = find(H(i, :));
      for k1=1:length(c1)
          if betaij(i, c1(k1))~=minofbetaij(i)
              Lrji(i,c1(k1))=prodallofalphaij(i)*alphaij(i, c1(k1))*minofbetaij(i);
          else
             mm=realmax;
             for l = 1:length(c1)
                if l ~= k1  
                   if betaij(i, c1(l)) < mm
                      mm = betaij(i, c1(l));
                   end
                end           
             end % for l
             Lrji(i,c1(k1))=prodallofalphaij(i)*alphaij(i, c1(k1))*mm;
          end
      end
   end % for i

   for j = 1:N                      %更新Lqij
      c1=find( H( :,j ) );                          %找index(j)列的非0元素
      for k1 = 1:length(c1)         
         Lqij(c1(k1),j)= Lci( j ) + sum( Lrji( c1, j ) ) - Lrji( c1(k1), j );
         alphaij(c1(k1),j) = sign(Lqij(c1(k1),j));
         betaij(c1(k1),j) = abs(Lqij(c1(k1),j));
      end % for k1     
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


