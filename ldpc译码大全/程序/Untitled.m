   % min1 = min(minOfbetaij(:));                     %A=minOfbetaij,min1为矩阵中的最小值
   %两个表达式min1=min(A(;))或者上式，都是求矩阵中最小值
   % B = minOfbetaij;
   % B(B == min1) = [];
   % %矩阵B为矩阵A去掉最小值后的矩阵形式，如若只是B(B = min1) = [];就不能去掉最小值都相同且有多个最小值的情况
   % min2 = min(B(:));                                  %min2位矩阵B的最小值，即矩阵A的次小值
   % differ = min2-min1;
%A=[-1 1 1 2;4 5 6 4;7 8 9 9]
%min1 = min(min(A))
%B=A
%B(B==min1)=[]
%min2 = min(B(:))
%differ = min2-min1
%n =(log(2)+differ/10)
%C=[1 2 5 6;5 2 9 6;4 5 5 3]
%q=4;
%E =ones(q,q)*n
%D= C * E

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%求出矩阵A每一行的最小值和次小值的间距差
A=[-1 -1 1 2;4 5 6 4;7 8 9 9]
for i = 1:3
    min1 = min(A(i,:));
    B = A(i,:);
    B(B == min1) = [];
    min2 = min(B(:));
    differ = min2-min1
end

    