function [L1,U1, newH] = makeParityChk(H, strategy)
% Generate parity check vector bases on LDPC matrix H using sparse LU decomposition
%产生奇偶检验向量，基于使用稀疏LU分解的H矩阵的LDPC
%  dSource : Binary source (0/1)
%  H       : LDPC matrix
%  strategy: Strategy for finding the next non-zero diagonal elements  %找到下一个非零对角线元素的策略
%            {0} First  : First non-zero found by column search  %通过列搜索第一次找到非零
%            {1} Mincol : Minimum number of non-zeros in later columns  %后面的非零值中的最小值
%            {2} Minprod: Minimum product of:
%                         - Number of non-zeros its column minus 1
%                         - Number of non-zeros its row minus 1
%           
%  c       : Check bits 
%
%
% Copyright Bagawan S. Nugroho, 2007 
% http://bsnugroho.googlepages.com

% Get the matrix dimension  得到矩阵维数
[M, N] = size(H);  %将H的行数列数给M,N
% Set a new matrix F for LU decomposition  建立一个新的基于LU分解的矩阵F
F = H;
% LU matrices
L = zeros(M, N - M);
U = zeros(M, N - M);

% Re-order the M x (N - M) submatrix
for i = 1:M

   % strategy {0 = First; 1 = Mincol; 2 = Minprod}
   switch strategy
      
      % Create diagonally structured matrix using 'First' strategy
      % 使用第一个策略产生一个对角结构的矩阵
      case {0}
         
         % Find non-zero elements (1s) for the diagonal 找到对角线上的非零元素
         [r, c] = find(F(:, i:end));
         
         % Find non-zero diagonal element candidates
         rowIndex = find(r == i);
            
         % Find the first non-zero column  找到第一个非零列
         chosenCol = c(rowIndex(1)) + (i - 1);
            
      % Create diagonally structured matrix using 'Mincol' strategy
      case {1}
         
         % Find non-zero elements (1s) for the diagonal
         [r, c] = find(F(:, i:end));
         colWeight = sum(F(:, i:end), 1);
         
         % Find non-zero diagonal element candidates
         rowIndex = find(r == i);
         
         % Find the minimum column weight
         [x, ix] = min(colWeight(c(rowIndex)));
         % Add offset to the chosen row index to match the dimension of the... 
         % original matrix F
         chosenCol = c(rowIndex(ix)) + (i - 1);
             
      % Create diagonally structured matrix using 'Minprod' strategy   
      case {2}
            
         % Find non-zero elements (1s) for the diagonal
         [r, c] = find(F(:, i:end));
         colWeight = sum(F(:, i:end), 1) - 1;
         rowWeight = sum(F(i, :), 2) - 1;
         
         % Find non-zero diagonal element candidates
         rowIndex = find(r == i);
            
         % Find the minimum product
         [x, ix] = min(colWeight(c(rowIndex))*rowWeight);
         % Add offset to the chosen row index to match the dimension of the... 
         % original matrix F
         chosenCol = c(rowIndex(ix)) + (i - 1);
         
      otherwise
         fprintf('Please select columns re-ordering strategy!\n');
      
   end % switch

   % Re-ordering columns of both H and F
   tmp1 = F(:, i);
   tmp2 = H(:, i);
   F(:, i) = F(:, chosenCol);
   H(:, i) = H(:, chosenCol);
   F(:, chosenCol) = tmp1;
   H(:, chosenCol) = tmp2;
                     
   % Fill the LU matrices column by column
   L(i:end, i) = F(i:end, i);
   U(1:i, i) = F(1:i, i);
         
   % There will be no rows operation at the last row  最后一行没有行操作
   if i < M           
            
      % Find the later rows with non-zero elements in column i
      [r2, c2] = find(F((i + 1):end, i));          
      % Add current row to the later rows which have a 1 in column i
      F((i + r2), :) = mod(F((i + r2), :) + repmat(F(i, :), length(r2), 1), 2);
                                                           
   end % if
         
end % for i

L1=L;
U1=U;
% Return the rearrange H 
newH = H;

