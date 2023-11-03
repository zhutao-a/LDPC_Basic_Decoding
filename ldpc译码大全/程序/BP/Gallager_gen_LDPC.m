function [H,rows,cols] = Gallager_gen_LDPC(miu,wr,wc)
% Code for generating regular parity-check matrix H by miu,wc,wr,using Gallager's approach
% ͨ������miu,wc,wr���ɹ���LDPCУ�����H��ʹ��Gallager�İ취
% Copyright sTeven joNes
% Email:sun.noon@gmail.com
% 2007-10-21

%Example:
% miu = 3;
% wr = 4;
% wc = 3;
% [H,rows,cols] = Gallager_gen_LDPC(miu,wr,wc)

% example's OUTPUT:
% H =
%      1     1     1     1     0     0     0     0     0     0     0     0
% H(1) 0     0     0     0     1     1     1     1     0     0     0     0
%      0     0     0     0     0     0     0     0     1     1     1     1

%      0     1     0     0     1     0     0     0     0     1     1     0
% H(2) 0     0     1     1     0     1     1     0     0     0     0     0
%      1     0     0     0     0     0     0     1     1     0     0     1

%      0     0     0     1     0     1     1     1     0     0     0     0
% H(3) 0     0     1     0     1     0     0     0     1     1     0     0
%      1     1     0     0     0     0     0     0     0     0     1     1
% rows = 9
% cols = 12
%end of example

% H's size will be:[miu*wc,miu*wr]
% number of row    : miu*wc
% number of colume : miu*wr
% ����H�ĳߴ�Ϊ��[miu*wc,miu*wr]
% ������miu*wc
% ������miu*wr

% INPUT:
% miu : int�����ɲ�����
% wc  : weight of column�����أ���ÿ����1�ĸ�����
% wr  : weight of row������10����ÿ����1�ĸ�����
% OUTPUT:
% H : Low-density parity-check matrix
% rows : ������miu*wc
% cols : ������miu*wr


%reference:
%[1]R.Gallager,"Low-density parity-check codes",MIT press,1963
%[2]Willam E. Ryan,"An Introduction to LDPC Codes"

rows = miu*wc;
cols = miu * wr;
h = zeros(rows,cols);

wrones = ones(1,wr);

% H = [H(1)
%      H(2)
%      .
%      .
%      .
%      H(wc)] 

for ii = 1 : miu
    h(ii,(ii-1)*wr + 1:ii*wr) = wrones;
end
% H(1)...done

%�㷨������ÿһ�У����ѡȡ��i�У������һ�еı�־λ��flag(i)��Ϊ0��
%˵���ڸ��Ӿ���H(topi)�У�����Ϊ���еĵ�i�и�ֵΪ1����һ���и�ֵ�ﵽ����wrʱ����ʼ����һ�н��д���
for topi = 2:wc%for H(2) to H(wc) 
    flag  = zeros(1,cols);%��H(topi)�е�ÿһ���Ƿ��Ѿ�������1�ı�־
    for ii = (topi-1)*miu +1 : topi * miu % for each line of H(topi)
        countones_eachline = 0;%����ÿһ���е�1�ĸ��������м�������1�ĸ�����������wrʱ��������һ�еĴ���
        while (countones_eachline<wr)
            index_one_col = ( round(rand(1) * (cols-1)) )+1;%���ѡȡһ��              
            if (flag(index_one_col) ~= 1)%��־λ��Ϊ0�Ļ������л�δ���ù������Խ�����ȥ
                h(ii,index_one_col) = 1;%�����е���Ӧѡȡ����Ԫ����Ϊ1
                flag(index_one_col) = 1;%��־λ��1
                countones_eachline = countones_eachline + 1;
            end%end if (flag(index_one_col) ~= 1)             
        end%end while (countones_eachline<=wr)
    end%end for ii = (topi-1)*miu +1 : topi * miu  
end%end for topi = 2:wc

H = h;

% you can get H(n) in your code as below
% H1 = h(1:miu,1:cols);
% Hn = h((n-1)*miu +1:n * miu,1:cols)