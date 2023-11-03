function [C]=mul_GF2(A,B)

C=A*B;
C=mod(C, 2);%mod(A,B)就是求A除以B的余数
