function [itertimes,vHat] = decodegeneration_serialBP(rx, H,N0, iteration)
%�����Ľ�����BP�㷨
[M ,N] = size(H);		
Lci = (-4*rx./N0)';
LQi=Lci;
EBN0=10*log10(2/N0);
yuzhi=4+EBN0;
gedai=1;
update=zeros(1,N);
LRi=zeros(1,N);
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


for n = 1:iteration                             %����iteration��
   fprintf('Iteration : %d\n', n);              %��ӡ��������
   itertimes=n;                                 %��ȡ��������
   for j=1:N
        c1=find( H( :,j ) );  
        LRi(j)=0;
        for k1=1:length(c1)
            if abs(Lrji(c1(k1),j))>LRi(j)
                LRi(j)=abs(Lrji(c1(k1),j));
            end
        end
    end
   [~,index]=sort(LRi,'descend');        %��������
   
   
   for j = 1:N                      %ÿ�θ���һ������   
       if update(index(j))~=0
          update(index(j))=update(index(j))-1;
          continue;
       end
       %ˮƽ����һ��
       prodOfalphaij =prodallofalphaij.*alphaij(:,index(j));%prodallOfalphaij��alphaij���з�0Ԫ�صĳ˻� m*1
       mm=minofbetaij;                                     %mm�ǳ�ȥindex(j)�е���Сֵ
       c1=find( H( :,index(j) ) );                          %��index(j)�еķ�0Ԫ��
       for k1=1:length(c1)                                   %��ȥindex(j)��betaij���з���Ԫ�ص���Сֵ m*1
           if mm( c1(k1) )==betaij( c1(k1) ,index(j) )%���index(j)�еĵ�c1(k)������Сֵ����Ҫ�滻
               mm( c1(k1) )=realmax;                
               c2=find( H( c1(k1),: ) );                     %�ҵ�c1(k)�еķ�0Ԫ��
               for k2=1:length(c2)
                   if c2(k2)~=index(j)                       %��ȥindex(j)��
                       if betaij(c1(k1),c2(k2))<mm( c1(k1) )
                           mm( c1(k1) )=betaij(c1(k1),c2(k2));
                       end
                   end
               end 
           end
       end
       Lrji(:,index(j)) = prodOfalphaij.*mm;       %����Lrji��index(j)��
      %��ֱ����һ��
      for k1 = 1:length(c1)         
         Lqij(c1(k1),index(j))= Lci( index(j) ) + sum( Lrji( c1, index(j) ) ) - Lrji( c1(k1), index(j) );
      end % for k
      for k1=1:length(c1)
          prodallofalphaij(c1(k1))=prodallofalphaij(c1(k1))*alphaij(c1(k1),index(j))*sign(Lqij(c1(k1),index(j)));
          alphaij( c1(k1),index(j) )= sign(Lqij( c1(k1),index(j) ) );  %���µ�������index(j)��
          betaij( c1(k1),index(j) ) = abs(Lqij( c1(k1),index(j) ) );  %���µ�������index(j)��
          if betaij(c1(k1),index(j))<mm(c1(k1))
              mm(c1(k1))=betaij(c1(k1),index(j));
          end
      end
      minofbetaij=mm;
      LQi(index(j)) = Lci(index(j)) + sum(Lrji(c1, index(j)));
      
      if abs(LQi(index(j)))>yuzhi
          update(index(j))=gedai;
      end
      
      if LQi(index(j)) < 0
         vHat(index(j)) = 1;
      else
         vHat(index(j)) = 0;
      end  
   end % for j
   
   
   if mod(H*vHat',2)==0
       break;
   end
end % for n


