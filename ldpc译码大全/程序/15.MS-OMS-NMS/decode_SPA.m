%function vHat = decode_SPA(rx, H, N0, iteration)
function [vhat1,vhat10] = decode_SPA(rx, H, N0, iteration)
% Log-domain sum product algorithm LDPC decoder
%
%  rx        : Received signal vector (column vector)
%  H         : LDPC matrix
%  N0        : Noise variance
%  iteration : Number of iteration
%
%  vHat      : Decoded vector (0/1) 
%
%
% Copyright Bagawan S. Nugroho, 2007 
% http://bsnugroho.googlepages.com

[M N] = size(H);

% Prior log-likelihood. Minus sign is used for 0/1 to -1/1 mapping
Lci = (2*rx./N0)';

% Initialization
Lrji = zeros(M, N);
Pibetaij = zeros(M, N);

% Asscociate the L(ci) matrix with non-zero elements of H
Lqij = H.*repmat(Lci, M, 1);

 
% Get non-zero elements
[r, c] = find(H);

% Iteration
n=0;
while  n < iteration
   
   fprintf('Iteration : %d\n', n);
   
   % Get the sign and magnitude of L(qij)   
   alphaij = sign(Lqij);   
   betaij = abs(Lqij);

   for l = 1:length(r)
      Pibetaij(r(l), c(l)) = log((exp(betaij(r(l), c(l))) + 1)/ (exp(betaij(r(l), c(l))) - 1));
   end
   
   % ----- Horizontal step -----
   for i = 1:M
      
      % Find non-zeros in the column
      c1 = find(H(i, :));
      
      % Get the summation of Pi(betaij))        
      for k = 1:length(c1)

         %sumOfPibetaij = 0;
         %prodOfalphaij = 1;
         
         % Summation of Pi(betaij)\c1(k)
         sumOfPibetaij = sum(Pibetaij(i, c1)) - Pibetaij(i, c1(k));
         
         % Avoid division by zero/very small number, get Pi(sum(Pi(betaij)))
         if sumOfPibetaij < 1e-20
            sumOfPibetaij = 1e-10;
         end         
         PiSumOfPibetaij = log((exp(sumOfPibetaij) + 1)/(exp(sumOfPibetaij) - 1));
      
         % Multiplication of alphaij\c1(k) (use '*' since alphaij are -1/1s)
         prodOfalphaij = prod(alphaij(i, c1))*alphaij(i, c1(k));
         
         % Update L(rji)
         Lrji(i, c1(k)) = prodOfalphaij*PiSumOfPibetaij;
         
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
      
      % Get L(Qi)
      LQi = Lci(j) + sum(Lrji(r1, j));
      
      % Decode L(Qi)
       if iter == 1
          if LQi < 0
              vHat1(j) = 1;
          else
              vHat1(j) = 0;
          end
      elseif iter == 10
              if LQi < 0
                  vHat10(j) = 1;
              else
                  vHat10(j) = 0;
              end
       end %if
                       
   end % for j
   
    if rem(H*vHat', 2) == 0
       break;
    else
        n=n+1;
   end
   
end % for n
