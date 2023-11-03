function [syn,hard] = ldpc_wbf(H,re,max_ite)


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
y_min=[ ];      % WBF y_min per check node/row
y_soft = re;    % �洢���ڵ��������о���Ϣ
y_re = re;      % �洢����ת����Ӧ�о���Ϣ�����о���Ϣ
iteration = 0;


% hard decision from BPSK
% y_re > 0 --> 1
% y_re <= 0 --> 0

for i = 1:col
    if y_re(i) > 0.0
        hard(i) = 1;
    else
        hard(i) = 0;
    end % if
end % for
hard_0=hard;        % �洢�����Ӳ�о���Ϣ

for s1=1:row
    H_soft(s1,:)=H(s1,:).*abs(y_re);
end


syn = mod(hard*H',2);%�õ�����ͼ����������У���


%%%%%%%%%%%%  Step 2:  solve for y_min %%%%%%%%%%%%

%%%%%%%%% Uses a zero flag to store first non-zero value %%%%%%%%%%%
for s1 = 1:row          % horizontal step, for check bits
    zero_flag = 0;
    for s2 = 1:col      % vertical step
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


while (sum(sum(syn)) ~= 0) & (iteration < max_ite)  %��� if syn=0 or �ﵽ����������

    iteration = iteration + 1;

    %%%%%%%%%%%% Step 3:  ����Ȩ�� %%%%%%%%%%%%
    % En = summation[(2Sm-1)|ymin|]
    
    for s2 = 1:col         
        Eo=0;
        En(1,s2)=0;
        for s1 = 1:row      % horizontal step, for Sm
            Eo=(2*syn(1,s1)-1)*y_min(s1,1)*H(s1,s2);
            En(1,s2)=En(1,s2)+Eo;
        end
    end
    
    %%%%%%%%%%%% Step 4: �ﵽȨ�����Ľڵ� %%%%%%%%%%%%
    % uses max function
    
    [max_En,id]=max(En,[],2);
    
    %%%%%%%%%%%% Step 5:  ��ת�ýڵ� %%%%%%%%%%%%
    hard(id)=not(hard(id));
    
    syn = mod(hard*H',2); % ���¼������ͼ��

end 


if (sum(sum(syn)) == 0)
    disp('WBF DECODING IS SUCCESSFUL')
else
    disp('WBF DECODING IS UNSUCCESSFUL')
end 

toc            