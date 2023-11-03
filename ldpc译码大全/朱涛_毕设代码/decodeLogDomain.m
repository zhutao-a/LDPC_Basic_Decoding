function [itertimes,vHat] = decodeLogDomain(rx, H,N0, iteration)
%LLR_BP算法
[M,N] = size(H);
Lci = (-4*rx./N0)';
LQi=Lci;
Lrji = zeros(M, N);
Lqij = H.*repmat(Lci, M, 1);
for n = 1:iteration
   fprintf('Iteration : %d\n', n);
   itertimes=n;                                 %获取迭代次数 
    for i= 1:M
      c1= find(H(i,:));    %校验节点m相邻的变量节点
      for k1= 1:length(c1)
         aa = c1;
         aa(k1) = [];
         Lrji(i,c1(k1)) = 2*atanh( prod( tanh(Lqij(i,aa)/2) ) );
      end
    end
   for j = 1:N   
      r1 = find(H(:,j));
      for k1 = 1:length(r1)        
         Lqij(r1(k1),j) = Lci(j) + sum(Lrji(r1, j)) - Lrji(r1(k1), j);
      end % for k
      LQi(j)= Lci(j) + sum(Lrji(r1, j));
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
