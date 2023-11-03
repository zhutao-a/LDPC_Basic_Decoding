function [ L ] = decompose2( m1, m2, y, u )
%DECOMPOSE2 Summary of this function goes here
%   Detailed explanation goes here

% 定义节点结构体
node_all = cell(1, log2(m1));

% 生成根节点
node_all{1}.parity = mod(m2,2);
node_all{1}.seq = u(1:m2-1);
node_all{1}.i = ceil(m2/2);

% 计算所有相关节点
for n1 = 2:log2(m1)
    num = 2*numel(node_all{n1-1});
    for n2 = 1:num
        index = ceil(n2/2);
        i = node_all{n1-1}(index).i;
        seq = node_all{n1-1}(index).seq;
        
        node_all{n1}(n2).parity = mod(i,2);
        node_all{n1}(n2).i = ceil(i/2);
        if mod(n2,2)==1
            node_all{n1}(n2).seq  = xor(seq(1:2:2*i-2), seq(2:2:2*i-2));
        else
            node_all{n1}(n2).seq  = seq(2:2:2*i-2);
        end
        
        if n1 == log2(m1)
            node_all{n1}(n2).L1 = y(2*n2-1);
            node_all{n1}(n2).L2 = y(2*n2);
        end
    end
end

for n1 = log2(m1)-1:-1:1
    num = numel(node_all{n1});
    for n2 = 1:num
        L1 = node_all{n1+1}(2*n2-1).L1;
        L2 = node_all{n1+1}(2*n2-1).L2;
        if node_all{n1+1}(2*n2-1).parity==0
            seq = node_all{n1+1}(2*n2-1).seq;
            i = node_all{n1+1}(2*n2-1).i;
            node_all{n1}(n2).L1 = g_fun(L1, L2, seq(2*i-1));
        else
            node_all{n1}(n2).L1 = f_fun(L1, L2);
        end
        
        L1 = node_all{n1+1}(2*n2).L1;
        L2 = node_all{n1+1}(2*n2).L2;
        if node_all{n1+1}(2*n2).parity==0
            seq = node_all{n1+1}(2*n2).seq;
            i = node_all{n1+1}(2*n2).i;
            node_all{n1}(n2).L2 = g_fun(L1, L2, seq(2*i-1));
        else
            node_all{n1}(n2).L2 = f_fun(L1, L2);
        end
    end
end

L1 = node_all{1}.L1;
L2 = node_all{1}.L2;
if node_all{1}.parity==0
    seq = node_all{1}.seq;
    i = node_all{1}.i;
    L = g_fun(L1, L2, seq(2*i-1));
else
    L = f_fun(L1, L2);
end


end

