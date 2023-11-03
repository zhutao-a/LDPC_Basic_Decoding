function decOut = decoderLDPC_fullH(H,H_col_full,H_row_full,soft,method,maxIteration,alpha,beta)
% LDPC译码函数
% 输入为：
% H是完整的校验矩阵
% H_col_full,H_row_full分别是存储校验矩阵维度的矩阵
% blockSize是矩阵分块大小
% soft是信道软信息
% method是译码方法，“0”表示SPA算法，“1”表示MinSum算法
% maxIteration为最大迭代次数
% alpha和beta分别是MinSum算法中用到的修正参数
% 输出为：
% decOut为输出码字
tic
%% 定义矩阵，存储计算的中间结果，初始化变量
[m n] = size(H);
U = zeros(m,n);  %定义两个矩阵，用于存储迭代计算的中间结果
V = zeros(m,n);  
U0 = soft;  %初始化
iteration = 0; %已迭代次数，初始化为0
dec = zeros(1,n);  %存储译码结果

%% 迭代、译码判决以及校验
  %%% 首先，进行第一次硬判决，看是否需要进行迭代译码 %%%%%%%
dec(U0 >= 0) = 0;
dec(U0 < 0) = 1;
s = mod(H*dec',2);  %计算校验子
s = sum(s);   %校验子向量之和
while(s ~= 0)  %校验子不是全0，继续迭代译码
    iteration = iteration + 1; %当前的迭代次数
    if(iteration > 1)
    end
    if(iteration > maxIteration) %当前迭代次数超出最大值，停止循环
        break;  
    end
    %% 迭代
    %%%%% 列运算 %%%%%%
    for i = 1:n
        num = H_col_full(1,i);
        index = H_col_full(2:num+1,i);
        for j = 1:num  %对每一个非零块进行处理
            index_j = index(j);  %该非零块的标签
            index_r = index(index ~= index_j); %除开本非零块之外的部分
            %%% 利用矩阵U来求V(i->j) %%%
            U_j = U(index_r,i);  %将U矩阵中与该变量节点有连接关系的校验节点数据提取出来
            sum_j = sum(U_j);  %求和
            sum_j = sum_j + U0(i); %加上入口软信息
            V(index_j,i) = sum_j;  %V矩阵
        end
    end
    
    %%%%% 行运算 %%%%%%
    if(method == 0)  %SPA算法
        for j=1:m
            num = H_row_full(j,1);
            index = H_row_full(j,2:num+1);
            for i=1:num
                index_i = index(i);
                index_r = index(index ~= index_i);
                %%% 利用矩阵V来求U(j->i) %%%
                V_i = V(j,index_r);  %提取有连接关系的数据块
                V_i = tanh(V_i/2);
                V_i = prod(V_i,2);  %求连积
                pro_i = 2*atanh(V_i);
                if(pro_i == Inf)%atanh函数得到Inf时做修正处理
                    pro_i = 20;
                elseif(pro_i == -Inf)
                    pro_i = -20;
                end
                U(j,index_i) = pro_i;  %
            end
        end
    elseif(method == 1) %MinSum算法
    end
    %% 计算置信度并进行硬判决
    belief = sum(U) + U0;  %将U矩阵求和并且与初始软信息相加，即为最终置信度
    dec(belief >= 0) = 0;
    dec(belief < 0) = 1;
    %% 校验
    s = mod(H*dec',2);  %计算校验子
    s = sum(s);  %计算校验子向量之和
end
decOut = dec;  %返回译码结果
disp('BP is done!');
toc