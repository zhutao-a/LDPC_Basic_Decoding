function vHat = decode_OMS(rx, H, iteration)
% Simplified log-domain sum product algorithm LDPC decoder
%
%  rx        : Received signal vector (column vector)
%  H         : LDPC matrix
%  iteration : Number of iteration
%
%  vHat      : Decoded vector (0/1) 
%
%
% Copyright Bagawan S. Nugroho, 2007 
% http://bsnugroho.googlepages.com

[M N] = size(H);

% Prior log-likelihood (simplified). Minus sign is used for 0/1 to -1/1 mapping
Lci = -rx';

% Initialization
Lrji = zeros(M, N);
%Pibetaij = zeros(M, N);

% Asscociate the L(ci) matrix with non-zero elements of H
Lqij = H.*repmat(Lci, M, 1);

n=0;
while n <iteration
   
   fprintf('Iteration : %d\n', n);
   
   % Get the sign and magnitude of L(qij)   
   alphaij = sign(Lqij);  
   betaij = abs(Lqij);

   % ----- Horizontal step -----
   for i = 1:M
      
      % Find non-zeros in the column
      c1 = find(H(i, :));
      
      % Get the minimum of betaij
      for k = 1:length(c1)
         
         % Minimum of betaij\c1(k)
         minOfbetaij = realmax;
         for l = 1:length(c1)
            if l ~= k  
               if betaij(i, c1(l)) < minOfbetaij
                  minOfbetaij = betaij(i, c1(l));
               end
            end           
         end % for l
                 
         % Multiplication alphaij\c1(k) (use '*' since alphaij are -1/1s)
         prodOfalphaij = prod(alphaij(i, c1))*alphaij(i, c1(k)); 
         
          Lrji(i, c1(k)) = prodOfalphaij*max(minOfbetaij-0.1,0);
          %else
         
         % Update L(rji)
         %if minOfbetaij> 1.25
         %Lrji(i, c1(k)) = prodOfalphaij*(minOfbetaij-1.25);%原有的是0.2结果的趋势不正确，改成1.25正确
         %else
           %Lrji(i, c1(k)) =0;%原有的
            %  Lrji(i, c1(k)) =prodOfalphaij*minOfbetaij；
          %if  minOfbetaij> 0.1
             
              %Lrji(i, c1(k)) =0;
              %Lrji(i, c1(k)) = prodOfalphaij*(0.2-minOfbetaij);
         %end
      
      end % for k
      
   end % for i

   % ------ Vertical step ------
   for j = 1:N

      % Find non-zero in the row
      r1 = find(H(:, j));
      
      for k = 1:length(r1)         
         
         % Update L(qij) by summation of L(rij)\r1(k)
         Lqij(r1(k), j) = Lci(j) + sum(Lrji(r1, j)) - Lrji(r1(k), j);
      
      end % for k
      
      % Get L(Qij)
      LQi = Lci(j) + sum(Lrji(r1, j));
      
      % Decode L(Qi)
      if LQi < 0
         vHat(j) = 1;
      else
         vHat(j) = 0;
      end
                 
   end % for j
   
    if rem(H*vHat', 2) == 0
       break;
    else
        n=n+1;
    end
   
end % for n