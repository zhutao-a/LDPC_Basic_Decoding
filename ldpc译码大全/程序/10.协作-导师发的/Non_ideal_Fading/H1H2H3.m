%注：程序运行后对原H阵产生了影响。。。
%需要解决的问题：1、交换列的保存方法，2）怎么有左边单位矩阵调到 右边为单位矩阵（整体对P,I两部分左右对换，同时在原H也做相应对换）
%%%%% 作为子函数返回Hc(编码矩阵） Hd（对应的译码矩阵） 



clear all;
clc;
%H=[0 1 0 0 1 0 1 0 1 1;1 0 1 1 0 1 0 1 0 0;0 1 0 1 1 0 0 1 1 0;1 0 1 0 0 1 1 0 0 1;1 0 1 0 1 0 0 1 1 0;0 1 0 1 0 1 1 0 0 1]
%H=load('Hnew.txt');
%H=load('H1.txt');
%H=[1 1 1 0 0 0 0 0 0;1 0 0 1 0 0 1 0 0;0 1 0 0 1 0 0 1 0;0 0 0 1 1 1 0 0 0;0 0 1 0 0 1 0 0 1;0 0 0 0 0 0 1 1 1]
%%%%%%%%%%%%%% 产生H 矩阵 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M = 500;   %%%%  for H1 H2, M=500,N=1000,dv=3,dc=6
N = 1500;
dv = 3;
dc = 9;
Hc1 = zeros(1,M*dc); 
Hc = zeros(M,dc);
H = zeros(M,N);


%%%%%%% H1
%% permate [1 N] randomly twice  需要手动设置dv次
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

dim=size(H);
rows=dim(1);
cols=dim(2);
Hd = H;% remain for decoding

rearranged_cols=zeros(1, rows);

%逐行进行高斯消元，前面的rows行 x rows列形成单位矩阵
for k=1:rows
    vec = [k:cols];

    %查找可交换的列 
    x = k;
    while (x<=cols & H(k,x)==0)
        ind = find(H(k+1:rows, x) ~= 0);
        if ~isempty(ind)
            break
        end
        x = x + 1;
    end

    %如果找不到可交换的列则视为非法的H矩阵并退出
    if x>cols
       error('Invalid H matrix.');
       %break;
    end

    %如果不是当前列则进行列交换，同时保存交换记录
    if (x~=k)
        rearranged_cols(k)=x;    %%% k为当前列，x为交换的列号，交换记录是从左到右。
        temp=H(:,k);             %%% 原校验矩阵也做相应位置的列交换。。。。。OK!
        H(:,k)=H(:,x);
        H(:,x)=temp;
    end

    %高斯消元，使G(k,k)==1
    if (H(k,k)==0)
        ind = find(H(k+1:rows, k) ~= 0);
        ind_major = ind(1);
        x = k + ind_major;
        H(k, vec) = rem(H(x, vec) + H(k, vec), 2);
    end

    %高斯消元，使得第k列除G(k,k)==1外其他位置为0
    ind = find(H(:, k) ~= 0)';
    for x = ind
        if x ~= k
            H(x, vec) = rem(H(x, vec) + H(k, vec), 2);
        end
    end
end
zerro=zeros(1,cols);
zer=0;
for k=1:rows
    if H(k,:)==zerro
        zer=zer+1;
    end
end
zer,
% Hnew=H(1:(rows-zer),:);
% P=Hnew(:,(rows+1-zer):cols);
% fprintf('Message encoded.\n');

%%%% 注：对原校验矩阵 H(Hd）进行列交换，而不是对码字的位置进行交换。。。
for q=1:1:rows
    if rearranged_cols(q)~=0 
       temp=Hd(:,q);
       Hd(:,q)=Hd(:,rearranged_cols(q));
       Hd(:,rearranged_cols(q))=temp;
    end
end

% I = eye(rows-zer);
% Hc = [P I]; %%%%% 注：消元后的编码矩阵
A = H(:,1:rows-zer);
B = H(:,rows-zer+1:cols);
Hc = [B A];

A = Hd(:,1:rows-zer);
B = Hd(:,rows-zer+1:cols);
Hd = [B A]; %%%%% 注：正规校验矩阵——译码使用 为了[I P]转换到[P I]对应
%%%%  encode and check
s = round(rand(cols-rows+zer, 1));
c = zeros(rows-zer,1);
for t = 1:rows-zer
    sum = Hc(t,1:cols-rows+zer)*s;
    c(t) = mod(sum,2);
    sum = 0;
end %
code = [s;c];
check = mod(Hd*code,2);
cr = find(check)
%%%%%% 作为主程序的文件名保存
Hc2 = Hc;
Hd2 = Hd;
save Hc2.mat Hc2;
save Hd2.mat Hd2;



