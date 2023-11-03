clc;
clear all;
M = 256;            %定义校验矩阵H大小为M*N
N = 512;
method = 1;         %H的生成方案
noCycle = 1;        %无围长为4的环
onePerCol = 3;      %列重
strategy = 2;       %重做H的初始化参数
H = makeLdpc(M, N, method, noCycle, onePerCol);  %产生校验矩阵Hm*n,其中n=2*m
[L1,U1, newH] = makeParityChk(H, strategy);       %重新制作H(经列变换),基于LU分解并生成L,U
save L1;
save U1;
save newH;





