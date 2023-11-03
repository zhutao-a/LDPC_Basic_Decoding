function H = makeLdpc(M, N, method, noCycle, onePerCol)
% Create R = 1/2 low density parity check matrix
%
%  M        : Number of row行数
%  N        : Number of column列数
%  method   : Method for distributing non-zero element产生非零元素的方法
%             {0} Evencol : For each column, place 1s uniformly at random
%             {1} Evenboth: For each column and row, place 1s uniformly at random
%  noCyle   : Length-4 cycle
%             {0} Ignore (do nothing)忽略
%             {1} Eliminate清除
%  onePerCol: Number of ones per column每列中1的个数
%
%  H        : Low density parity check matrix                   
%
%
% Copyright Bagawan S. Nugroho, 2007 
% http://bsnugroho.googlepages.com

%N=2000;
%M=1000;
%onePerCol=3;
%method = 1;
%noCycle = 1;
% Number of ones per row (N/M ratio must be 2)每行中1的个数（N/M一定要是2）
if N/M ~= 2
   fprintf('Code rate must be 1/2\n');
end
onePerRow = (N/M)*onePerCol;%6

fprintf('Creating LDPC matrix...\n');
onesInCol=zeros(M,N);
switch method
   % Evencol
   case {0}
      % Distribute 1s uniformly at random within column
      for i = 1:N
         onesInCol(:, i) = randperm(M)';%1000*2000的矩阵
      end
        
      % Create non zero elements (1s) index
      r = reshape(onesInCol(1:onePerCol, :), N*onePerCol, 1);%将1000*2000矩阵的前3行改成6000*1矩阵
      tmp = repmat(1:N, onePerCol, 1);%复制矩阵  变为3*2000矩阵
      c = reshape(tmp, N*onePerCol, 1);%6000*1矩阵
      
      % Create sparse matrix H
      H = full(sparse(r, c, 1, M, N));
      
   % Evenboth
   case {1}
      % Distribute 1s uniformly at random within column
      for i = 1:N
         onesInCol(:, i) = randperm(M)';
      end
        
      % Create non zero elements (1s) index
      r = reshape(onesInCol(1:onePerCol, :), N*onePerCol, 1);
      tmp = repmat(1:N, onePerCol, 1);
      c = reshape(tmp, N*onePerCol, 1);
     
      % Make the number of 1s between rows as uniform as possible     
      
      % Order row index
      [r,ix] = sort(r);%升续排列这6000个值
      
      % Order column index based on row index
      cSort=zeros(1,N*onePerCol);
      for i = 1:N*onePerCol
         cSort(i) = c(ix(i));
      end
      
      % Create new row index with uniform weight
      tmp = repmat(1:M, onePerRow, 1);
      r = reshape(tmp, N*onePerCol, 1);
      
      % Create sparse matrix H
      % Remove any duplicate non zero elements index using logical AND
      S = and(sparse(r, cSort, 1, M, N), ones(M, N));
      H = full(S);     
      
end % switch

% Check rows that have no 1 or only have one 1  &检查只有一个1或者没有1的行
for i = 1:M
   
   n = randperm(N);
   % Add two 1s if row has no 1  如果行没有1则加入两个1
   if length(find(r == i)) == 0
      H(i, n(1)) = 1;
      H(i, n(2)) = 1;
   % Add one 1 if row has only one 1   如果行有一个1则加入一个1
   elseif length(find(r == i)) == 1
      H(i, n(1)) = 1;
   end

end % for i

% If desired, eliminate any length-4 cycle
if noCycle == 1
   
   for i = 1:M
      % Look for pair of row - column
      for j = (i + 1):M         
         w = and(H(i, :), H(j, :));
         c1 = find(w);
         lc = length(c1);
         if lc > 1
                       
            % If found, flip one 1 to 0 in the row with less number of 1s
            if length(find(H(i, :))) < length(find(H(j, :)))
               % Repeat the process until only one column left 
               for cc = 1:lc - 1
                  H(j, c1(cc)) = 0;
               end
            else
               for cc = 1:lc - 1
                  H(i, c1(cc)) = 0;
               end
            end % if            
         
         end % if
      end % for j
   end % for i
  
end % if

fprintf('LDPC matrix is created.\n');
