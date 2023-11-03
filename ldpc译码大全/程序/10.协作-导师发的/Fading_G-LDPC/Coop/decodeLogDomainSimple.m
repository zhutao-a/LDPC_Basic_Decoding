function [vHat1,vHat10] = decodeLogDomainSimple(rx, H, iteration)
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
Pibetaij = zeros(M, N);

% Asscociate the L(ci) matrix with non-zero elements of H
Lqij = H.*repmat(Lci, M, 1);

for iter = 1:iteration
   
  %%%%% fprintf('Iteration : %d\n', n);
   
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
         
         % Update L(rji)
         Lrji(i, c1(k)) = prodOfalphaij*minOfbetaij;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %基于校验节点，最小值和次小值间距的G-MS译码算法%
%    min1 = min(minOfbetaij(:));                     %A=minOfbetaij,min1为矩阵中的最小值
%    B = minOfbetaij(:);
%    B(B == min1) = [];                              %矩阵B为矩阵A去掉最小值后的矩阵形式
%    min2 = min(B);                                  %min2位矩阵B的最小值，即矩阵A的次小值
%    differ = min2-min1;                             %differ为次小值和最小值的间距
%    if differ > 3    
%        Lrji(i, c1(k)) =prodOfalphaij*minOfbetaij;  %仍按照最小和译码算法计算检验节点
%    else
%         Lrji(i, c1(k)) =prodOfalphaij*minOfbetaij*(log(2)+differ/10);%a=In2=log(2)
%    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
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
      
      % Decode L(Qi)      %%%% 
      
 %      if iter == 1
 %         if LQi < 0
 %             vHat1(j) = 1;
 %         else
 %             vHat1(j) = 0;
 %         end
 %     elseif iter == 10
 %             if LQi < 0
 %                 vHat10(j) = 1;
 %             else
 %                 vHat10(j) = 0;
 %             end
 %      end %if
       
        if LQi < 0
         vHat2(j) = 1;
      else
         vHat2(j) = 0;
      end
                 
   end % for j
%      if rem(H*vHat', 2) == 0
%       break;
%    else
%        n=n+1;
%    end
   
end % for n
