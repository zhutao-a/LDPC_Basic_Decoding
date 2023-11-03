function [H_col H_row H H_col_full H_row_full] = preProcess(Hb,blockSize)
% 预处理函数，对分块形式的校验矩阵做预处理，包括两部分
% 1.扩展矩阵，得到完整的校验矩阵
% 2.统计矩阵，得到分块格式下矩阵中非零块的数量、位置和偏移量大小
% 输入:Hb为分块形式的校验矩阵，blockSize是分块大小
% 输出:H_col为分块校验矩阵每一列中非零块的个数、位置和偏移量
%      H_row为分块校验矩阵每一行中非零块的个数、位置和偏移量
%      H为扩展之后的完整矩阵
%      H_col_full为完整校验矩阵每一列中非零点的个数及位置
%      H_row_full为完整校验矩阵每一行中非零点的个数及位置

%% 1.扩展得到完整的校验矩阵
[mb nb] = size(Hb);
parLen = mb*blockSize;  %校验位的长度
codeLen = nb*blockSize;  %码长
H = zeros(parLen,codeLen);  %完全的校验矩阵
for i=1:mb
    for j=1:nb
        offset = Hb(i,j); %提取偏移量
        if(offset == 0)  %如果为0，展开为全0矩阵
            I = zeros(blockSize);
        else  %否则，为循环移位的单位矩阵
            I = eye(blockSize);    
            I = [I(:,end-offset+2:end) I(:,1:end-offset+1)];  %单位矩阵循环移位
        end
        t = 1:blockSize;
        x = t + (i-1)*blockSize;
        y = t + (j-1)*blockSize;  %在全矩阵中填充的位置
        H(x,y) = I;  %填充完全矩阵
    end
end
H(1,parLen) = 0; %矩阵中特殊位置的处理

%% 2.统计分块校验矩阵中非零块的数量、位置和偏移量
for i=1:mb  %对每一行进行统计
    index = find(Hb(i,:) ~= 0);   %非零块的位置
    offset = Hb(i,index);         %非零块的偏移量
    num = length(offset);         %非零块的数量
    H_row(i,1) = num;
    H_row(i,2:num+1) = index;
    H_row(i,num+2:2*num+1) = offset;
end

for i=1:nb  %然后对每一列进行统计
    index = find(Hb(:,i) ~= 0);
    offset = Hb(index,i);
    num = length(offset);
    H_col(1,i) = num;
    H_col(2:num+1,i) = index;
    H_col(num+2:2*num+1,i) = offset;
end

%% 3.统计完整校验矩阵中非零点的数量和位置
for i=1:parLen  %对每一行进行统计
    index = find(H(i,:) ~= 0);   %非零点的位置
    num = length(index);         %非零点的数量
    H_row_full(i,1) = num;
    H_row_full(i,2:num+1) = index;
end

for i=1:codeLen  %对每一列进行统计
    index = find(H(:,i) ~= 0);  %非零点的位置
    num = length(index);        %非零点的数量
    H_col_full(1,i) = num;
    H_col_full(2:num+1,i) = index;
end