A = randi([0 1000],[5,6])  % ����ʵ������
min1 = min(A(:));
[a1,b1,v1] = find(A==min1);
B = A(:);
B(B==min1) = [];
min2 = min(B);
[a2,b2,v2] = find(A==min2);
fprintf('��СֵΪ %d ���ڵ� %d �е� %d �С�\n',[min1,a1,b1]);
fprintf('��СֵΪ %d ���ڵ� %d �е� %d �С�\n',[min2,a2,b2]);