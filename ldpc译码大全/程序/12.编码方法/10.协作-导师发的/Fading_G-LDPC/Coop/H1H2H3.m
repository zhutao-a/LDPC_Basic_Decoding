%ע���������к��ԭH�������Ӱ�졣����
%��Ҫ��������⣺1�������еı��淽����2����ô����ߵ�λ������� �ұ�Ϊ��λ���������P,I���������ҶԻ���ͬʱ��ԭHҲ����Ӧ�Ի���
%%%%% ��Ϊ�Ӻ�������Hc(������� Hd����Ӧ��������� 



clear all;
clc;
%H=[0 1 0 0 1 0 1 0 1 1;1 0 1 1 0 1 0 1 0 0;0 1 0 1 1 0 0 1 1 0;1 0 1 0 0 1 1 0 0 1;1 0 1 0 1 0 0 1 1 0;0 1 0 1 0 1 1 0 0 1]
%H=load('Hnew.txt');
%H=load('H1.txt');
%H=[1 1 1 0 0 0 0 0 0;1 0 0 1 0 0 1 0 0;0 1 0 0 1 0 0 1 0;0 0 0 1 1 1 0 0 0;0 0 1 0 0 1 0 0 1;0 0 0 0 0 0 1 1 1]
%%%%%%%%%%%%%% ����H ���� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M = 500;   %%%%  for H1 H2, M=500,N=1000,dv=3,dc=6
N = 1000;
%M=256;
%N=768;
dv = 3;
dc = 3;
Hc1 = zeros(1,M*dc); 
Hc = zeros(M,dc);
H = zeros(M,N);


%%%%%%% H1
%% permate [1 N] randomly twice  ��Ҫ�ֶ�����dv��
Hc11 = randperm(N);
Hc12 = randperm(N);
Hc13 = randperm(N);

Hc1 = [Hc11 Hc12 Hc13];

for i = 1:M
    for j = 1:dc 
        Hc(i,j) = Hc1((i-1)*dc+j);
    end %for
end %for
for i = 1:M
    for j = 1:dc
        H(i,Hc(i,j))=1;
    end %for
end %for
row1 = 0;
for i =1:M
    for j = 1:N
        if H(i,j) == 1
            row1 = row1+1;
        end %if
    end %for
    if row1~=dc
        disp('no correct dc H');
        i
        break;
    end %if
    row1 = 0;
end %for
vec1 = 0;
for i = 1:N
    for j = 1:M
        if H(j,i) == 1
            vec1 = vec1+1;
        end %if
    end %for
    if vec1~=dv
        disp('no correct dv H1');
        i
        break;
    end %if
    vec1 = 0;
end %for
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = eye(M);
H2 = [H I];
save H2.mat H2;



