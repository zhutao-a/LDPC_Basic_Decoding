   % min1 = min(minOfbetaij(:));                     %A=minOfbetaij,min1Ϊ�����е���Сֵ
   %�������ʽmin1=min(A(;))������ʽ���������������Сֵ
   % B = minOfbetaij;
   % B(B == min1) = [];
   % %����BΪ����Aȥ����Сֵ��ľ�����ʽ������ֻ��B(B = min1) = [];�Ͳ���ȥ����Сֵ����ͬ���ж����Сֵ�����
   % min2 = min(B(:));                                  %min2λ����B����Сֵ��������A�Ĵ�Сֵ
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
%�������Aÿһ�е���Сֵ�ʹ�Сֵ�ļ���
A=[-1 -1 1 2;4 5 6 4;7 8 9 9]
for i = 1:3
    min1 = min(A(i,:));
    B = A(i,:);
    B(B == min1) = [];
    min2 = min(B(:));
    differ = min2-min1
end

    