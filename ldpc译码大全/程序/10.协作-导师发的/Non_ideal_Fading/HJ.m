%注：程序运行后对原H阵产生了影响。。。
%需要解决的问题：1、交换列的保存方法，2）怎么有左边单位矩阵调到 右边为单位矩阵（整体对P,I两部分左右对换，同时在原H也做相应对换）
%%%%% 作为子函数返回Hc(编码矩阵） Hd（对应的译码矩阵） 



clear all;
clc;
load Hd1;
load Hd2;

[M,N] = size(Hd2);
Z = zeros(M,M);

H = [Hd1 Z;Hd2];
save H.mat H;



