function [syn,hard] = ldpc_irrwbf(H,re,max_ite)

% output
%   syn - syndrome bits
%   hard - hard-coded message

% input
%   H - parity check matrix
%   re - received word
%   max_ite - maximum iteration

tic             % start timer

%%%%%%%%%%%% Step 1.  形成错误图样 %%%%%%%%%%%%


[row,col] = size(H);
hard=[ ];
y_min=[ ];      % IWBF y_min per check node/row
y_soft = re;    % 存储用于迭代的软判决信息
y_re = re;      % 存储用于转化成硬判决信息的软判决信息
iteration = 0;

% hard decision from BPSK
% y_re => 0 --> 1
% y_re <= 0 --> 0

hard = (y_re>0);
hard_0=hard;        % s存储最初的硬判决信息

for s1=1:row
    H_soft(s1,:)=H(s1,:).*abs(y_re);
end

syn = mod(hard*H',2);

%%%%%%%%%%%% Step 2:  计算简化后的可靠性比 %%%%%%%%%%%%

Tm = sum(H_soft')';


while (sum(sum(syn)) ~= 0) & (iteration < max_ite)  %检查 if syn=0 or 达到最大迭代次数

    iteration = iteration + 1;

    %%%%%%%%%%%% Step 3:  计算权重, IRRWBF %%%%%%%%%%%%
    % En = (1/|rn|)*summation[(2Sm-1)Tm]
    
    % Compute for summation terms first    
    for s2 = 1:col          % vertical step, for message bits
        Eo=0;
        En(1,s2)=0;
        for s1 = 1:row      % horizontal step, for Sm
            Eo= ((2*syn(1,s1)-1)*Tm(s1,1)*H(s1,s2));
            En(1,s2)=En(1,s2)+Eo;
        end
    end
    
    % Divide by |rn|
    En = En./abs(y_re);
    
    %%%%%%%%%%%% Step 4:  得到最大的权重 %%%%%%%%%%%%
    % uses max function
    [max_En,id]=max(En,[],2);
    
    %%%%%%%%%%%% Step 5:  翻转该比特 %%%%%%%%%%%%
    hard(id)=not(hard(id));
    
    syn = mod(hard*H',2);  % 重新计算错误图样
    
end 

if (sum(sum(syn)) == 0)
    disp('IRRWBF DECODING IS SUCCESSFUL')
else
    disp('IRRWBF DECODING IS UNSUCCESSFUL')
end

toc             % end timer