function encOut = encoderLDPC(msgIn,Hb,blockSize)
% LDPC���뺯�����õ��Ʒ�������
% ����Ϊ�ֱ�Ϊ
% msgIn����Ϣ���У�Hb���ֿ���ʽ��У�����blockSize���ֿ��С
% ���Ϊ
% encOut��������

[mb,nb] = size(Hb);


%% ��һ���������м�ڵ�
Hs = Hb(:,mb+1:nb);  %У������е���Ϣ���֣���Сmb*kb
x = []; %�վ������ڴ洢�м�ڵ�
for i=1:mb
    index = find(Hs(i,:) ~= 0); %Ѱ��У���������з�����
    offset = Hs(i,index); %�������ƫ����
    xi = zeros(1,blockSize);  %�����ۼ�
    for j=1:length(index)
        indexj = (index(j) - 1)*blockSize;
        si = msgIn(1+indexj:blockSize+indexj); %��ȡ��Ϣ�����ж�Ӧ��index��һ��
        si = [si(offset(j):end) si(1:offset(j)-1)];  %���ݸ�index�µ�offset������Ϣ���н�����λ
        xi = xi + si;  %�ۼ�
    end
    xi = mod(xi,2); %�����з��������ۼ�֮��ģ2�����õ���һ���м�ڵ�
    x = [x xi]; %ƴ��
end



%% �ڶ������������λ
temp = 0;
parity = zeros(1,mb*blockSize);
for i=1:blockSize
    for j=0:mb-1
        temp = mod(x(i+j*blockSize) + temp,2);
        parity(i+j*blockSize) = temp;
    end
end

%% ����������ϳɱ�����
encOut = [parity msgIn];
