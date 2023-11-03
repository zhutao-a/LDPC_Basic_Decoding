%软判决译码
%输入 H：校验矩阵   y：读出的数组    ber：错误率   errorbit：错误所在位的信息，用来特殊化似然比   p：包含错误率信息的数组
%Imax：最大迭代次数
%输出 MM：纠错结果  cycle：循环次数  
function [MM,cycle]=min_sum_decode_new(H,y,~,~,p,Imax)

I=1;%迭代次数计数器
%Imax=20;%规定最大迭代次数

[m,n]=size(H);
%n=H矩阵列数/信息节点数
%m=H矩阵行数/校验节点数
sf=0.7;
z=zeros(1,n);
r=zeros(1,n);
L=zeros(1,n);

M=sparse(H);
E=zeros(m,n);

for ii=1:n
    if y(ii)==1
        r(ii)=log(p(ii)/(1-p(ii)));
    else
        r(ii)=log((1-p(ii))/p(ii));
    end
end

%初始化M矩阵
M=M*diag(r);

%迭代
while 1==1
  
    for jj=1:m
        onesInRows=find(H(jj,:) == 1);
        colInd    = onesInRows;             % 找到第j行中1的位置
        rowDegree = length(colInd);            %行重
        qMessages = M(jj, colInd);        % 找到第j行中所有的q消息
        qSign     = sign(qMessages);           % q消息的符号
        signProd  = prod(qSign) ;              % 符号乘积
        qMesAbs   = abs(qMessages);            % 幅度值
        signEx    = signProd .* qSign ;        % 外信息的符号，等于排除自身符号后的乘积
        
        qMesSort = sort(qMesAbs);                          %排序
        rMesAbs  = qMesSort(1)*ones(1,rowDegree);          %校验消息选择最小的q消息
        ind = find(qMesAbs == qMesSort(1));                %找到qmessages中最小的那个
        rMesAbs(ind) = qMesSort(2);                         %而最小的q消息对应的r消息是其他q消息中的最小值
        rMessages  = signEx .* rMesAbs .* sf;              %求得第j行中所有元素的r信息
        E(jj, colInd) = rMessages;                    %存放到rMatrix中              
    end
    
    %更新信息节点,Test
    for ii=1:n
        onesInCols=find(H(:,ii)==1);
        rowInd    = onesInCols;
        rMessages = E(rowInd, ii);
        L(ii)=r(ii)+sum(rMessages);
        qMessages = L(ii) - rMessages;           % 变量消息等于所有的除去自身的校验消息之和
        M(rowInd, ii) = qMessages;           % 存放到qMatrix中
        if L(ii)<=0
            z(ii)=1;
        else
            z(ii)=0;
        end
        
    end
    

    Hz=mod(H*z',2);
    
    if I==Imax || isempty(find(Hz, 1))
        fprintf('finish at iteration %d\n',I);
        MM=z;
        cycle=I;
        return;
    end
    
    I=I+1;    
end