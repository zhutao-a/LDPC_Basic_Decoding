function [itertimes,vHat] = decodeLogDomainSimple(rx, H,N0, iteration)
%MS��С���㷨
[M ,N] = size(H);		
Lci = (-4*rx./N0)';
LQi=zeros(1,N);
Lrji = zeros(M, N);
Lqij = H.*repmat(Lci, M, 1);
prodallofalphaij=zeros(M,1);
minofbetaij=zeros(M,1);
alphaij = sign(Lqij);  
betaij = abs(Lqij);
for n = 1:iteration                             %����iteration��
   fprintf('Iteration : %d\n', n);              %��ӡ��������
   itertimes=n;                                 %��ȡ��������
    for i = 1:M               %�ҵ�betaij������Сֵ��alphaij��0Ԫ�صĳ˻�
      c1 = find(H(i, :));   
      minofbetaij(i)= realmax;
      for l = 1:length(c1)          %�ҵ���index(j)�������Сbetaijֵ
         if betaij(i, c1(l)) < minofbetaij(i)
            minofbetaij(i) = betaij(i, c1(l));
         end        
      end % for l
      prodallofalphaij(i) = prod(alphaij(i, c1)); 
    end % for i 
    
   for i = 1:M                  %����Lrji
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

   for j = 1:N                      %����Lqij
      c1=find( H( :,j ) );                          %��index(j)�еķ�0Ԫ��
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


