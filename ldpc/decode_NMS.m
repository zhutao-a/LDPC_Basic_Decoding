function [hard_decision,rx_update] = decode_NMS(rx,r0,alpha,H,iter)
%function [vHat,n1] = decode_NMS(rx, H2, iteration)
% Simplified log-domain sum product algorithm LDPC decoder
%  rx        : Received signal vector (column vector)
%  H         : LDPC matrix
%  iteration : Number of iteration
%  vHat      : Decoded vector (0/1) 
% Copyright Bagawan S. Nugroho, 2007 
% http://bsnugroho.googlepages.com
[M,N] = size(H);
rx_update=zeros(1,length(rx));
hard_decision=zeros(1,length(rx));

Lqij = H.*repmat(rx, M, 1);
Lrji = zeros(M, N);
for n=1:iter 
   alphaij = sign(Lqij);  
   betaij = abs(Lqij);
   
   for i = 1:M
      c1 = find(H(i, :));
      for k = 1:length(c1)
         minOfbetaij = realmax;
         for l = 1:length(c1)
            if l ~= k  
               if betaij(i, c1(l)) < minOfbetaij
                  minOfbetaij = betaij(i, c1(l));
               end
            end           
         end 
         prodOfalphaij = prod(alphaij(i, c1))*alphaij(i, c1(k)); 
         Lrji(i, c1(k)) = alpha*prodOfalphaij*minOfbetaij;
      end 
   end

   for j = 1:N
      r1 = find(H(:, j));
      for k = 1:length(r1)         
         Lqij(r1(k), j) = r0(j) + sum(Lrji(r1, j)) - Lrji(r1(k), j);
      end
      rx_update(j) = r0(j) + sum(Lrji(r1, j));
      if rx_update(j) < 0
         hard_decision(j) = 1;
      else
         hard_decision(j) = 0;
      end       
   end

end


