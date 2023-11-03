%��С�������㷨
% maxIterNum : ����������
% y         : �ŵ�����Ľ���ֵ
% decoded    : ����������
% flag       : �Ƿ�����ɹ��ı�־

function [decoded,cycle]=LDPC_MSA(H,y,ber,errorbit,p,Imax)
[M,N]=size(H);
sf=0.75;
decoded=y;

r=zeros(1,N);
for ii=1:N
    if y(ii)==1
        r(ii)=log(p(ii)/(1-p(ii)));
    else
        r(ii)=log((1-p(ii))/p(ii));
    end
end

if mod(H*decoded',2)==0  %���ͨ��У�飬�򷵻�decoded
    fprintf('No error./n');
    cycle=1;
    return;
end


% ��ʼ����
% ���� ��ű�����Ϣq�ľ���qMatrix, �Լ� ���У����Ϣr�ľ���rMatrix.
qMatrix = sparse(H);   
rMatrix = sparse(H);

app = zeros(1,N);     %���ÿ�ε�������ʱ�ĺ������

% ��ʼ������qMatrix �е�i�������е�"1"��Ӧ��λ�� ��ʼ��Ϊrx.
qMatrix = qMatrix * diag(y);


for i = 1:Imax
    % ��ʼˮƽ����,����ÿһ��
    for j = 1:M
        onesInRows=find(H(j,:) == 1);
        colInd    = onesInRows;             % �ҵ���j����1��λ��
        rowDegree = length(colInd);            %����
        qMessages = qMatrix(j, colInd);        % �ҵ���j�������е�q��Ϣ
        qSign     = sign(qMessages);           % q��Ϣ�ķ���
        signProd  = prod(qSign) ;              % ���ų˻�
        qMesAbs   = abs(qMessages);            % ����ֵ
        signEx    = signProd .* qSign ;        % ����Ϣ�ķ��ţ������ų�������ź�ĳ˻�
        
        qMesSort = sort(qMesAbs);                          %����
        rMesAbs  = qMesSort(1)*ones(1,rowDegree);          %У����Ϣѡ����С��q��Ϣ
        ind = find(qMesAbs == qMesSort(1));                %�ҵ�qmessages����С���Ǹ�
        rMesAbs(ind) = qMesSort(2);                         %����С��q��Ϣ��Ӧ��r��Ϣ������q��Ϣ�е���Сֵ
        rMessages  = signEx .* rMesAbs .* sf;              %��õ�j��������Ԫ�ص�r��Ϣ
        rMatrix(j, colInd) = rMessages;                    %��ŵ�rMatrix��
    end
    
    
    %��ʼ��ֱ����,����ÿһ��
    for j = 1:N
        onesInCols=find(H(:,j)==1);
        rowInd    = onesInCols;                % �ҵ���j����1��λ��
        %colDegree = length(rowInd);               % ����
        rMessages = rMatrix(rowInd, j);           % �ҵ���j�������е�r��Ϣ
        app(j)    = sum(rMessages) + y(j);       % ��j�����صĺ������=���е�����Ϣ + �ŵ���Ϣrx
        qMessages = app(j) - rMessages;           % ������Ϣ�������еĳ�ȥ�����У����Ϣ֮��
        qMatrix(rowInd, j) = qMessages;           % ��ŵ�qMatrix��
    end
    
    % �����о�
    decoded(find(app <= 0)) = 1;
    decoded(find(app >  0)) = 0;
    
    if i==Imax || isempty(find(mod(H*decoded',2), 1))                      %���ͨ��У�飬�򷵻�decoded
        fprintf('finish at iteration %d\n',i);
        cycle=i;
        break;
    end  
end

























