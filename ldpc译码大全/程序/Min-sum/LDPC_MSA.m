%最小和译码算法
% maxIterNum : 最大迭代次数
% y         : 信道输入的接收值
% decoded    : 译码后的码字
% flag       : 是否译码成功的标志

function [decoded,cycle]=LDPC_MSA(H,y,ber,errorbit,p,Imax)
[M,N]=size(H);
sf=0.75;
decoded=y;

r=zeros(1,N);
for ii=1:N
    if y(ii)==1
        r(ii)=log(p(ii)/(1-p(ii)));
    else
        r(ii)=log((1-p(ii))/p(ii));
    end
end

if mod(H*decoded',2)==0  %如果通过校验，则返回decoded
    fprintf('No error./n');
    cycle=1;
    return;
end


% 开始译码
% 构造 存放变量信息q的矩阵qMatrix, 以及 存放校验信息r的矩阵rMatrix.
qMatrix = sparse(H);   
rMatrix = sparse(H);

app = zeros(1,N);     %存放每次迭代译码时的后验概率

% 初始化，将qMatrix 中第i列中所有的"1"对应的位置 初始化为rx.
qMatrix = qMatrix * diag(y);


for i = 1:Imax
    % 开始水平步骤,遍历每一行
    for j = 1:M
        onesInRows=find(H(j,:) == 1);
        colInd    = onesInRows;             % 找到第j行中1的位置
        rowDegree = length(colInd);            %行重
        qMessages = qMatrix(j, colInd);        % 找到第j行中所有的q消息
        qSign     = sign(qMessages);           % q消息的符号
        signProd  = prod(qSign) ;              % 符号乘积
        qMesAbs   = abs(qMessages);            % 幅度值
        signEx    = signProd .* qSign ;        % 外信息的符号，等于排除自身符号后的乘积
        
        qMesSort = sort(qMesAbs);                          %排序
        rMesAbs  = qMesSort(1)*ones(1,rowDegree);          %校验消息选择最小的q消息
        ind = find(qMesAbs == qMesSort(1));                %找到qmessages中最小的那个
        rMesAbs(ind) = qMesSort(2);                         %而最小的q消息对应的r消息是其他q消息中的最小值
        rMessages  = signEx .* rMesAbs .* sf;              %求得第j行中所有元素的r信息
        rMatrix(j, colInd) = rMessages;                    %存放到rMatrix中
    end
    
    
    %开始垂直步骤,遍历每一列
    for j = 1:N
        onesInCols=find(H(:,j)==1);
        rowInd    = onesInCols;                % 找到第j列中1的位置
        %colDegree = length(rowInd);               % 列重
        rMessages = rMatrix(rowInd, j);           % 找到第j列中所有的r消息
        app(j)    = sum(rMessages) + y(j);       % 第j个比特的后验概率=所有的外信息 + 信道信息rx
        qMessages = app(j) - rMessages;           % 变量消息等于所有的除去自身的校验消息之和
        qMatrix(rowInd, j) = qMessages;           % 存放到qMatrix中
    end
    
    % 尝试判决
    decoded(find(app <= 0)) = 1;
    decoded(find(app >  0)) = 0;
    
    if i==Imax || isempty(find(mod(H*decoded',2), 1))                      %如果通过校验，则返回decoded
        fprintf('finish at iteration %d\n',i);
        cycle=i;
        break;
    end  
end

























