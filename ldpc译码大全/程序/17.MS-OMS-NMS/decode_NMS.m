function vHat = decode_NMS(rx, H, iteration)
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
Lci = rx';

% Initialization
Lrji = zeros(M, N);
Ldji = zeros(M, N);
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
         
         % Update L(rji)
         %================================================================================================
  %      Lrji(i, c1(k)) =prodOfalphaij*minOfbetaij;
  %      if ( abs(Lrji(i, c1(k)))>0.8)
  %           Ldji(i, c1(k)) =1.05* Lrji(i, c1(k));
  %      elseif((0.3< abs(Lrji(i, c1(k))))&&(0.8>abs(Lrji(i, c1(k)))))
  %           Ldji(i, c1(k)) = Lrji(i, c1(k));
  %      else( abs(Lrji(i, c1(k)))<0.3)
  %           Ldji(i, c1(k)) =0.95* Lrji(i, c1(k));
  %      end
       % else
       %     Lrji(i, c1(k)) =0.85*prodOfalphaij*minOfbetaij;
       % end
       %  Lrji(i, c1(k)) =0.85*prodOfalphaij*minOfbetaij;
       %   Lrji(i, c1(k)) =0.8*(prodOfalphaij*minOfbetaij-0.05);

       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %基于校验节点，最小值和次小值间距的G-MS译码算法
    min1 = minOfbetaij(:);                             %A=minOfbetaij,min1为矩阵中的最小值,73和76行等价，都是求矩阵中最小值，min(A)是求矩阵每一列的最小值
    B = minOfbetaij;
    B(B == min1) = [];                                %矩阵B为矩阵A去掉最小值后（包括多个相等的最小值情况）的矩阵形式，B(B = min1) = [] ，只去掉一个最小值，若果有多个的情况下
    min2 = min(B(:));                                 %min2位矩阵B的最小值，即矩阵A的次小值
    differ = min2-min1;                                %differ为次小值和最小值的间距
    if differ <= 3    
        Lrji(i, c1(k)) =prodOfalphaij*minOfbetaij*(log(2)+differ/10);%a=In2=log(2)
    else
        Lrji(i, c1(k)) =prodOfalphaij*minOfbetaij;      %仍按照最小和译码算法计算检验节点
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %for g =1:512
  %      min1 = min(betaij(g,:));                             %A=minOfbetaij,min1为矩阵中的最小值,73和76行等价，都是求矩阵中最小值，min(A)是求矩阵每一列的最小值
  %      B = betaij(g,:);
  %      B(B == min1) = [];                                %矩阵B为矩阵A去掉最小值后（包括多个相等的最小值情况）的矩阵形式，B(B = min1) = [] ，只去掉一个最小值，若果有多个的情况下
  %      min2 = min(B(:));                                 %min2位矩阵B的最小值，即矩阵A的次小值
  %      differ = min2-min1;                                %differ为次小值和最小值的间距
  %      if differ <= 3    
  %          Lrji(i, c1(k)) =prodOfalphaij*minOfbetaij*(log(2)+differ/10);%a=In2=log(2)
  %      else
  %          Lrji(i, c1(k)) =prodOfalphaij*minOfbetaij;      %仍按照最小和译码算法计算检验节点
  %      end
  % end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


      end % for k
      
   end % for i

   % ------ Vertical step ------
   for j = 1:N

      % Find non-zero in the row
      r1 = find(H(:, j));
      
      for k = 1:length(r1)         
         
         % Update L(qij) by summation of L(rij)\r1(k)
        % Lqij(r1(k), j) =0.8*(Lci(j) + sum(Lrji(r1, j)) - Lrji(r1(k), j));
        % Lqij(r1(k), j) =0.86*(Lci(j) + sum(Lrji(r1, j)) - Lrji(r1(k), j));
         % Lqij(r1(k), j) =0.7*(Lci(j) + sum(Lrji(r1, j)) - Lrji(r1(k), j));
  %        Lqij(r1(k), j) =(Lci(j) + sum(Lrji(r1, j)) - Lrji(r1(k), j));
          Lqij(r1(k), j) =0.93*((Lci(j) + sum(Ldji(r1, j)) - Ldji(r1(k), j)));
      % Lqij(r1(k), j) = Lci(j) + sum(Lrji(r1, j)) - Lrji(r1(k), j);
      %Lci(j)
     
      end % for k
      
      % Get L(Qij)
%     LQi = Lci(j) + sum(Lrji(r1, j));
LQi = Lci(j) + sum(Ldji(r1, j));
      % Decode L(Qi)
      if LQi < 0
%%%%%这里用的vhat10          
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