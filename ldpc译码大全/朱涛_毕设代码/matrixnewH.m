clc;
clear all;
M = 256;            %����У�����H��СΪM*N
N = 512;
method = 1;         %H�����ɷ���
noCycle = 1;        %��Χ��Ϊ4�Ļ�
onePerCol = 3;      %����
strategy = 2;       %����H�ĳ�ʼ������
H = makeLdpc(M, N, method, noCycle, onePerCol);  %����У�����Hm*n,����n=2*m
[L1,U1, newH] = makeParityChk(H, strategy);       %��������H(���б任),����LU�ֽⲢ����L,U
save L1;
save U1;
save newH;





