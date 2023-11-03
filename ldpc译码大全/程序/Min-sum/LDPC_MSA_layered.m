%��С�������㷨
% maxIterNum : ����������
% rx         : �ŵ�����Ľ���ֵ
% decoded    : ����������
% flag       : �Ƿ�����ɹ��ı�־

function [decoded,cycle]=LDPC_MSA_layered(H,y,~,~,p,Imax)
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
    cycle=1;
    return;
end


% ��ʼ����
% ����layered BP��ÿ���һ�� Layer����Ҫ���ڱ�����Ϣ���и��£�Ϊ�˱���ʵ�֣�ʵ�����ÿһ�д洢����
%  Q_j = sum( �ŵ���Ϣfj��  ���е�У����Ϣ�������ڵ�j��У����Ϣ )�������ڽ�����һ�е�У����Ϣ����ʱ����ʼ�ı�����Ϣ
% ����  Q_j - r_mj��Q_j��ÿһ��layer��ˮƽ��������󣬵õ��ĵ�j�����صĺ�����ʡ�


% ����  ���У����Ϣr�ľ���rMatrix.
Q = y;                                   %�����Q��ʼ��Ϊ�ŵ���Ϣ
rMatrix = zeros(M,N);          %�����е�У����Ϣ��ʼ��Ϊ0
for ii=1:N
    for jj=1:M
        rMatrix(jj,ii)=r(ii);
   end
end
rMatrix=(H.*rMatrix);

%������ʼ
for i = 1:Imax
    % ��ʼˮƽ����,����ÿһ��  �������ڳ���ʵ���У�����һ��һ��У�鷽�̴��еġ�����ÿL��У�鷽���ǿ���
    % ���еġ���Ϊ��һ��circulant�е�ÿ����û�й�����ġ����Կ���ͨ�� L������ͬʱ��ˮƽ���裬ÿL������֮��
    % �Ǵ��еġ�
    for j = 1:M
        onesInRows=find(H(j,:) == 1);
        
        colInd    = onesInRows;                    % �ҵ���j����1��λ��
        rowDegree = length(colInd);                %����
        rMessages = rMatrix(j, colInd);             % �ҵ���j�������е�r��Ϣ
        qMessages = Q(colInd)  - rMessages; %  ��Q - r�õ�q��Ϣ
    
        %%%%%%%%%%%%%%%%%%%%%%%�����еĲ���û�б仯������С���㷨һ��%%%%%%%%%%%%%%%
        qSign     = sign(qMessages);            % q��Ϣ�ķ���
        signProd  = prod(qSign) ;                  % ���ų˻�
        qMesAbs   = abs(qMessages);            % ����ֵ
        signEx    = signProd .* qSign ;         % ����Ϣ�ķ��ţ������ų�������ź�ĳ˻�
        
        qMesSort = sort(qMesAbs);                          %����
        rMesAbs  = qMesSort(1)*ones(1,rowDegree);          %У����Ϣѡ����С��q��Ϣ
        ind = find(qMesAbs == qMesSort(1));                %�ҵ�qmessages����С���Ǹ�
        rMesAbs(ind) = qMesSort(2);                         %����С��q��Ϣ��Ӧ��r��Ϣ������q��Ϣ�е���Сֵ
        rMessages  = signEx .* rMesAbs .* sf;              %��õ�j��������Ԫ�ص�r��Ϣ
        rMatrix(j, colInd) = rMessages;                    %��ŵ�rMatrix��
        %%%%%%%%%%%%%%%%%%%%%%%�����еĲ���û�б仯������С���㷨һ��%%%%%%%%%%%%%%%
     
        Q(colInd) = qMessages + rMessages;        % ����Q�е���Ϣ��
    end
    
    %%%���ڴ�ֱ�����Ѿ�������ˮƽ������Q���ˣ���˴�ֱ����ʡ���ˡ����ҵ�M��ˮƽ������ɺ�Q�д洢����Ϣ
    % ���Ǻ������app.
    app = Q;
    
    % �����о�
    for ii=1:N
        if app(ii)<=0
            decoded(ii)=1;
        else
            decoded(ii)=0;
        end
    end
    
    check_sums = mod(H * decoded', 2); 
    
    if i==Imax ||(~any(check_sums))                       %���ͨ��У�飬�򷵻�decoded
        fprintf('finish at iteration %d\n',i);        
        cycle=i;
        break;
    end  

end