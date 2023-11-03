%最小和译码算法
% maxIterNum : 最大迭代次数
% rx         : 信道输入的接收值
% decoded    : 译码后的码字
% flag       : 是否译码成功的标志

function [decoded,cycle]=LDPC_MSA_layered(H,y,~,~,p,Imax)
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
    cycle=1;
    return;
end


% 开始译码
% 由于layered BP在每完成一个 Layer后，需要对于变量消息进行更新，为了便于实现，实际针对每一列存储的是
%  Q_j = sum( 信道信息fj，  所有的校验消息给变量节点j的校验消息 )，这样在进行新一行的校验信息计算时，初始的变量消息
% 等于  Q_j - r_mj。Q_j是每一个layer的水平步骤结束后，得到的第j个比特的后验概率。


% 构造  存放校验信息r的矩阵rMatrix.
Q = y;                                   %这里的Q初始化为信道信息
rMatrix = zeros(M,N);          %将所有的校验消息初始化为0
for ii=1:N
    for jj=1:M
        rMatrix(jj,ii)=r(ii);
   end
end
rMatrix=(H.*rMatrix);

%迭代开始
for i = 1:Imax
    % 开始水平步骤,遍历每一行  ，这里在程序实现中，还是一个一个校验方程串行的。但是每L个校验方程是可以
    % 并行的。因为在一个circulant中的每行是没有公共点的。所以可以通过 L个方程同时做水平步骤，每L个方程之间
    % 是串行的。
    for j = 1:M
        onesInRows=find(H(j,:) == 1);
        
        colInd    = onesInRows;                    % 找到第j行中1的位置
        rowDegree = length(colInd);                %行重
        rMessages = rMatrix(j, colInd);             % 找到第j行中所有的r消息
        qMessages = Q(colInd)  - rMessages; %  用Q - r得到q消息
    
        %%%%%%%%%%%%%%%%%%%%%%%这其中的部分没有变化，和最小和算法一样%%%%%%%%%%%%%%%
        qSign     = sign(qMessages);            % q消息的符号
        signProd  = prod(qSign) ;                  % 符号乘积
        qMesAbs   = abs(qMessages);            % 幅度值
        signEx    = signProd .* qSign ;         % 外信息的符号，等于排除自身符号后的乘积
        
        qMesSort = sort(qMesAbs);                          %排序
        rMesAbs  = qMesSort(1)*ones(1,rowDegree);          %校验消息选择最小的q消息
        ind = find(qMesAbs == qMesSort(1));                %找到qmessages中最小的那个
        rMesAbs(ind) = qMesSort(2);                         %而最小的q消息对应的r消息是其他q消息中的最小值
        rMessages  = signEx .* rMesAbs .* sf;              %求得第j行中所有元素的r信息
        rMatrix(j, colInd) = rMessages;                    %存放到rMatrix中
        %%%%%%%%%%%%%%%%%%%%%%%这其中的部分没有变化，和最小和算法一样%%%%%%%%%%%%%%%
     
        Q(colInd) = qMessages + rMessages;        % 更新Q中的信息。
    end
    
    %%%由于垂直步骤已经包含在水平步骤求Q中了，因此垂直步骤省略了。并且当M行水平步骤完成后，Q中存储的消息
    % 就是后验概率app.
    app = Q;
    
    % 尝试判决
    for ii=1:N
        if app(ii)<=0
            decoded(ii)=1;
        else
            decoded(ii)=0;
        end
    end
    
    check_sums = mod(H * decoded', 2); 
    
    if i==Imax ||(~any(check_sums))                       %如果通过校验，则返回decoded
        fprintf('finish at iteration %d\n',i);        
        cycle=i;
        break;
    end  

end