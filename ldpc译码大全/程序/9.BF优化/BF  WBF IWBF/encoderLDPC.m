function encOut = encoderLDPC(msgIn,Hb,blockSize)
% LDPC编码函数，用递推方法编码
% 输入为分别为
% msgIn：信息序列；Hb：分块形式的校验矩阵；blockSize：分块大小
% 输出为
% encOut：编码结果

[mb,nb] = size(Hb);


%% 第一步，计算中间节点
Hs = Hb(:,mb+1:nb);  %校验矩阵中的信息部分，大小mb*kb
x = []; %空矩阵，用于存储中间节点
for i=1:mb
    index = find(Hs(i,:) ~= 0); %寻找校验矩阵该行中非零项
    offset = Hs(i,index); %非零项的偏移量
    xi = zeros(1,blockSize);  %用于累加
    for j=1:length(index)
        indexj = (index(j) - 1)*blockSize;
        si = msgIn(1+indexj:blockSize+indexj); %提取信息序列中对应该index的一段
        si = [si(offset(j):end) si(1:offset(j)-1)];  %根据该index下的offset，对信息序列进行移位
        xi = xi + si;  %累加
    end
    xi = mod(xi,2); %对所有非零块进行累加之后，模2，即得到这一段中间节点
    x = [x xi]; %拼接
end



%% 第二步，计算检验位
temp = 0;
parity = zeros(1,mb*blockSize);
for i=1:blockSize
    for j=0:mb-1
        temp = mod(x(i+j*blockSize) + temp,2);
        parity(i+j*blockSize) = temp;
    end
end

%% 第三步，组合成编码结果
encOut = [parity msgIn];
