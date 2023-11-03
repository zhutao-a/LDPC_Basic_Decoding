function vHat = OLBP1Decoding(rx, H, iteration)
[M N] = size(H);
Qv = -rx';
Rcv = zeros(M,N);
tempcv = zeros(1,N);
%factor = 0.75;
for n = 1:iteration
   %fprintf('Iteration: %d\n',n);
   for i = 1:M
      col = find(H(i,:));
      for k = 1:length(col)
         tempcv(1,col(k)) = Qv(col(k)) - Rcv(i,col(k));
      end
      alpha = sign(tempcv);  
      beta  = abs(tempcv);
      signS = 1;min1 = 100000;min2 = 100000;index = 10000;
      for k = 1:length(col)
          signS = alpha(col(k)) * signS;
          if beta(col(k)) < min1
              min2 = min1;
              min1 = beta(col(k));
              index = col(k);end  
          if ((beta(col(k)) > min1) & (beta(col(k)) < min2)) min2 = beta(col(k));end    
      end
      
      
      for k = 1:length(col)
         if col(k) == index 
             
         Rcv(i,col(k)) = signS*alpha(col(k))*max((min2-0.1),0);
         else 
         Rcv(i,col(k)) = signS*alpha(col(k))*max((min1-0.1),0);
         
          end    
         Qv(col(k)) = tempcv(1,col(k)) + Rcv(i,col(k));
      end 
      for k = 1:N
         if Qv(k) < 0
            vHat(k) = 1;
         else
            vHat(k) = 0;end 
      end
   end  
    if rem(H*vHat', 2) == 0
       break ;
    else
        n=n+1 ;
  end 
end
fprintf('OLBP1Decoding is done...\n');