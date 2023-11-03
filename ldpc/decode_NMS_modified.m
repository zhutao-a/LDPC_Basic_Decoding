function [hard_decision,rx_update] = decode_NMS_modified(rx,r0,alpha,H,iter)
[M,N] = size(H);
rx_update=rx;
hard_decision=(rx<0);
error=sum(hard_decision);
sign_flag=zeros(1,N);
Lqij = H.*repmat(rx, M, 1);
Lrji = zeros(M, N);
for n=1:iter 
   flag=1-2*mod(hard_decision*H',2);
   for i=1:N
       c1=find(H(:,i));
       sign_flag(i)=sum(flag(c1));
   end
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
         if(sign_flag(c1(k))>0)%保持符号不变
             prodOfalphaij=sign(rx_update(c1(k)));
         else%符号改变
             prodOfalphaij=-1*sign(rx_update(c1(k)));
         end
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


