A = randi([0 1000],[5,6])  % 生成实验数据
min1 = min(A(:));
[a1,b1,v1] = find(A==min1);
B = A(:);
B(B==min1) = [];
min2 = min(B);
[a2,b2,v2] = find(A==min2);
fprintf('最小值为 %d ，在第 %d 行第 %d 列。\n',[min1,a1,b1]);
fprintf('次小值为 %d ，在第 %d 行第 %d 列。\n',[min2,a2,b2]);