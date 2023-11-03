function [H_col H_row H H_col_full H_row_full] = preProcess(Hb,blockSize)
% Ԥ���������Էֿ���ʽ��У�������Ԥ��������������
% 1.��չ���󣬵õ�������У�����
% 2.ͳ�ƾ��󣬵õ��ֿ��ʽ�¾����з�����������λ�ú�ƫ������С
% ����:HbΪ�ֿ���ʽ��У�����blockSize�Ƿֿ��С
% ���:H_colΪ�ֿ�У�����ÿһ���з����ĸ�����λ�ú�ƫ����
%      H_rowΪ�ֿ�У�����ÿһ���з����ĸ�����λ�ú�ƫ����
%      HΪ��չ֮�����������
%      H_col_fullΪ����У�����ÿһ���з����ĸ�����λ��
%      H_row_fullΪ����У�����ÿһ���з����ĸ�����λ��

%% 1.��չ�õ�������У�����
[mb nb] = size(Hb);
parLen = mb*blockSize;  %У��λ�ĳ���
codeLen = nb*blockSize;  %�볤
H = zeros(parLen,codeLen);  %��ȫ��У�����
for i=1:mb
    for j=1:nb
        offset = Hb(i,j); %��ȡƫ����
        if(offset == 0)  %���Ϊ0��չ��Ϊȫ0����
            I = zeros(blockSize);
        else  %����Ϊѭ����λ�ĵ�λ����
            I = eye(blockSize);    
            I = [I(:,end-offset+2:end) I(:,1:end-offset+1)];  %��λ����ѭ����λ
        end
        t = 1:blockSize;
        x = t + (i-1)*blockSize;
        y = t + (j-1)*blockSize;  %��ȫ����������λ��
        H(x,y) = I;  %�����ȫ����
    end
end
H(1,parLen) = 0; %����������λ�õĴ���

%% 2.ͳ�Ʒֿ�У������з�����������λ�ú�ƫ����
for i=1:mb  %��ÿһ�н���ͳ��
    index = find(Hb(i,:) ~= 0);   %������λ��
    offset = Hb(i,index);         %������ƫ����
    num = length(offset);         %����������
    H_row(i,1) = num;
    H_row(i,2:num+1) = index;
    H_row(i,num+2:2*num+1) = offset;
end

for i=1:nb  %Ȼ���ÿһ�н���ͳ��
    index = find(Hb(:,i) ~= 0);
    offset = Hb(index,i);
    num = length(offset);
    H_col(1,i) = num;
    H_col(2:num+1,i) = index;
    H_col(num+2:2*num+1,i) = offset;
end

%% 3.ͳ������У������з�����������λ��
for i=1:parLen  %��ÿһ�н���ͳ��
    index = find(H(i,:) ~= 0);   %������λ��
    num = length(index);         %����������
    H_row_full(i,1) = num;
    H_row_full(i,2:num+1) = index;
end

for i=1:codeLen  %��ÿһ�н���ͳ��
    index = find(H(:,i) ~= 0);  %������λ��
    num = length(index);        %����������
    H_col_full(1,i) = num;
    H_col_full(2:num+1,i) = index;
end