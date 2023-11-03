function [vHat,n1] = decode_NMS(rx, H, iteration)
%function [vHat,n1] = decode_NMS(rx, H2, iteration)
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
Lci = -rx';   %原来Lci = rx'


% Initialization
Lrji = zeros(M, N);
%Pibetaij = zeros(M, N);

% Asscociate the L(ci) matrix with non-zero elements of H

n=0;
n1=0;
%H=zeros(128,256);
%H1=zeros(128,256);


%for j=1:16
    %for m=1:16
        %H1(:,j+(m-1)*4)=H2(:,(j-1)*8+m);%由4*8生成的16*32类循环矩阵)
        %H1(:,j+(m-1)*16)=H2(:,(j-1)*8+m);%由4*8生成的64*128类循环矩阵）
        %H1(:,j+(m-1)*16)=H2(:,(j-1)*16+m);   %由8*16生成的128*256类循环矩阵）
         %H1(:,j+(m-1)*16)=H2(:,(j-1)*32+m); %（由16*32生成的256*512类循环矩阵）
   % end 
%end

%for j=1:16
    %for m=1:8
        %H(j+(m-1)*4,:)=H1((j-1)*4+m,:);
        %H(j+(m-1)*16,:)=H1((j-1)*4+m,:);
         %H(j+(m-1)*16,:)=H1((j-1)*8+m,:);
          %H(j+(m-1)*16,:)=H1((j-1)*16+m,:);
    %end
%end

Lqij = H.*repmat(Lci, M, 1);

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
        
         Lrji(i, c1(k)) = 0.8*prodOfalphaij*minOfbetaij;
       
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
n1=n;