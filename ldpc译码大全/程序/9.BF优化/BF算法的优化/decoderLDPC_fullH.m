function decOut = decoderLDPC_fullH(H,H_col_full,H_row_full,soft,method,maxIteration,alpha,beta)
% LDPC���뺯��
% ����Ϊ��
% H��������У�����
% H_col_full,H_row_full�ֱ��Ǵ洢У�����ά�ȵľ���
% blockSize�Ǿ���ֿ��С
% soft���ŵ�����Ϣ
% method�����뷽������0����ʾSPA�㷨����1����ʾMinSum�㷨
% maxIterationΪ����������
% alpha��beta�ֱ���MinSum�㷨���õ�����������
% ���Ϊ��
% decOutΪ�������
tic
%% ������󣬴洢������м�������ʼ������
[m n] = size(H);
U = zeros(m,n);  %���������������ڴ洢����������м���
V = zeros(m,n);  
U0 = soft;  %��ʼ��
iteration = 0; %�ѵ�����������ʼ��Ϊ0
dec = zeros(1,n);  %�洢������

%% �����������о��Լ�У��
  %%% ���ȣ����е�һ��Ӳ�о������Ƿ���Ҫ���е������� %%%%%%%
dec(U0 >= 0) = 0;
dec(U0 < 0) = 1;
s = mod(H*dec',2);  %����У����
s = sum(s);   %У��������֮��
while(s ~= 0)  %У���Ӳ���ȫ0��������������
    iteration = iteration + 1; %��ǰ�ĵ�������
    if(iteration > 1)
    end
    if(iteration > maxIteration) %��ǰ���������������ֵ��ֹͣѭ��
        break;  
    end
    %% ����
    %%%%% ������ %%%%%%
    for i = 1:n
        num = H_col_full(1,i);
        index = H_col_full(2:num+1,i);
        for j = 1:num  %��ÿһ���������д���
            index_j = index(j);  %�÷����ı�ǩ
            index_r = index(index ~= index_j); %�����������֮��Ĳ���
            %%% ���þ���U����V(i->j) %%%
            U_j = U(index_r,i);  %��U��������ñ����ڵ������ӹ�ϵ��У��ڵ�������ȡ����
            sum_j = sum(U_j);  %���
            sum_j = sum_j + U0(i); %�����������Ϣ
            V(index_j,i) = sum_j;  %V����
        end
    end
    
    %%%%% ������ %%%%%%
    if(method == 0)  %SPA�㷨
        for j=1:m
            num = H_row_full(j,1);
            index = H_row_full(j,2:num+1);
            for i=1:num
                index_i = index(i);
                index_r = index(index ~= index_i);
                %%% ���þ���V����U(j->i) %%%
                V_i = V(j,index_r);  %��ȡ�����ӹ�ϵ�����ݿ�
                V_i = tanh(V_i/2);
                V_i = prod(V_i,2);  %������
                pro_i = 2*atanh(V_i);
                if(pro_i == Inf)%atanh�����õ�Infʱ����������
                    pro_i = 20;
                elseif(pro_i == -Inf)
                    pro_i = -20;
                end
                U(j,index_i) = pro_i;  %
            end
        end
    elseif(method == 1) %MinSum�㷨
    end
    %% �������ŶȲ�����Ӳ�о�
    belief = sum(U) + U0;  %��U������Ͳ������ʼ����Ϣ��ӣ���Ϊ�������Ŷ�
    dec(belief >= 0) = 0;
    dec(belief < 0) = 1;
    %% У��
    s = mod(H*dec',2);  %����У����
    s = sum(s);  %����У��������֮��
end
decOut = dec;  %����������
disp('BP is done!');
toc