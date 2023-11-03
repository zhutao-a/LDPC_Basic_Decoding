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
N = 1500;
dv = 3;
dc = 9;
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

dim=size(H);
rows=dim(1);
cols=dim(2);
Hd = H;% remain for decoding

rearranged_cols=zeros(1, rows);

%���н��и�˹��Ԫ��ǰ���rows�� x rows���γɵ�λ����
for k=1:rows
    vec = [k:cols];

    %���ҿɽ������� 
    x = k;
    while (x<=cols & H(k,x)==0)
        ind = find(H(k+1:rows, x) ~= 0);
        if ~isempty(ind)
            break
        end
        x = x + 1;
    end

    %����Ҳ����ɽ�����������Ϊ�Ƿ���H�����˳�
    if x>cols
       error('Invalid H matrix.');
       %break;
    end

    %������ǵ�ǰ��������н�����ͬʱ���潻����¼
    if (x~=k)
        rearranged_cols(k)=x;    %%% kΪ��ǰ�У�xΪ�������кţ�������¼�Ǵ����ҡ�
        temp=H(:,k);             %%% ԭУ�����Ҳ����Ӧλ�õ��н�������������OK!
        H(:,k)=H(:,x);
        H(:,x)=temp;
    end

    %��˹��Ԫ��ʹG(k,k)==1
    if (H(k,k)==0)
        ind = find(H(k+1:rows, k) ~= 0);
        ind_major = ind(1);
        x = k + ind_major;
        H(k, vec) = rem(H(x, vec) + H(k, vec), 2);
    end

    %��˹��Ԫ��ʹ�õ�k�г�G(k,k)==1������λ��Ϊ0
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

%%%% ע����ԭУ����� H(Hd�������н����������Ƕ����ֵ�λ�ý��н���������
for q=1:1:rows
    if rearranged_cols(q)~=0 
       temp=Hd(:,q);
       Hd(:,q)=Hd(:,rearranged_cols(q));
       Hd(:,rearranged_cols(q))=temp;
    end
end

% I = eye(rows-zer);
% Hc = [P I]; %%%%% ע����Ԫ��ı������
A = H(:,1:rows-zer);
B = H(:,rows-zer+1:cols);
Hc = [B A];

A = Hd(:,1:rows-zer);
B = Hd(:,rows-zer+1:cols);
Hd = [B A]; %%%%% ע������У����󡪡�����ʹ�� Ϊ��[I P]ת����[P I]��Ӧ
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
%%%%%% ��Ϊ��������ļ�������
Hc2 = Hc;
Hd2 = Hd;
save Hc2.mat Hc2;
save Hd2.mat Hd2;



