function [syn,hard] = ldpc_iwbf(H,re,alp,max_ite)

% output
%   syn - syndrome bits
%   hard - hard-coded message

% input
%   H - parity check matrix
%   re - received word
%   max_ite - maximum iteration

tic             % start timer

%%%%%%%%%%%% Step 1. �γɴ���ͼ�� %%%%%%%%%%%%


[row,col] = size(H);
hard=[ ];
y_min=[ ];      % IWBF y_min per check node/row
y_soft = re;    % �洢���ڵ������ŵ�����Ϣ
y_re = re;      % �洢����ת����Ӳ�о���Ϣ�����о���Ϣ
iteration = 0;
wf = alp;%������Ȩ������

% hard decision from BPSK
% y_re > 0 --> 1
% y_re <= 0 --> 0

for i = 1:col
    if y_re(i) > 0.0
        hard(i) = 1;
    else
        hard(i) = 0;
    end 
end 
hard_0=hard;        % �洢�����Ӳ�о���Ϣ

for s1=1:row
    H_soft(s1,:)=H(s1,:).*abs(y_re);
end

syn = mod(hard*H',2);%�������ͼ��

%%%%%%%%%%%% Step 2:  solve for y_min %%%%%%%%%%%%

%%%%%%%%% Uses a zero flag to store first non-zero value %%%%%%%%%%%

for s1 = 1:row        
    zero_flag = 0;
    for s2 = 1:col     
        if H_soft(s1,s2) ~= 0 
            if zero_flag == 0
                y_min(s1,1) = H_soft(s1,s2);
                zero_flag = 1;
            end
            if H_soft(s1,s2) <= y_min(s1,1)
                y_min(s1,1) = H_soft(s1,s2);%�õ���С��y
            end
        end
    end
end

while (sum(sum(syn)) ~= 0) & (iteration < max_ite)  %��� if syn=0 or �ﵽ���ĵ�������
    iteration = iteration + 1;

    %%%%%%%%%%%% Step 3: ����Ȩ�� %%%%%%%%%%%%
    % En = summation[(2Sm-1)|ymin| - |yn|]
    
    for s2 = 1:col          % vertical step, for message bits
        Eo=0;
        En(1,s2)=0;
        for s1 = 1:row      % horizontal step, for Sm
            Eo=(2*syn(1,s1)-1)*y_min(s1,1)*H(s1,s2) - (wf*y_re(1,s1));
            En(1,s2)=En(1,s2)+Eo;
        end
    end
    
    %%%%%%%%%%%% Step 4:  �������Ȩ�� %%%%%%%%%%%%
    % uses max function
    
    [max_En,id]=max(En,[],2);
    
    %%%%%%%%%%%% Step 5: ��ת�ñ��� %%%%%%%%%%%%
    hard(id)=not(hard(id));
    
    syn = mod(hard*H',2);  % ���¼������ͼ��  
    
end 


if (sum(sum(syn)) == 0)
    disp('IWBF DECODING IS SUCCESSFUL')
else
    disp('IWBF DECODING IS UNSUCCESSFUL')
end 

toc             % end timer