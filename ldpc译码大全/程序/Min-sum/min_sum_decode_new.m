%���о�����
%���� H��У�����   y������������    ber��������   errorbit����������λ����Ϣ���������⻯��Ȼ��   p��������������Ϣ������
%Imax������������
%��� MM��������  cycle��ѭ������  
function [MM,cycle]=min_sum_decode_new(H,y,~,~,p,Imax)

I=1;%��������������
%Imax=20;%�涨����������

[m,n]=size(H);
%n=H��������/��Ϣ�ڵ���
%m=H��������/У��ڵ���
sf=0.7;
z=zeros(1,n);
r=zeros(1,n);
L=zeros(1,n);

M=sparse(H);
E=zeros(m,n);

for ii=1:n
    if y(ii)==1
        r(ii)=log(p(ii)/(1-p(ii)));
    else
        r(ii)=log((1-p(ii))/p(ii));
    end
end

%��ʼ��M����
M=M*diag(r);

%����
while 1==1
  
    for jj=1:m
        onesInRows=find(H(jj,:) == 1);
        colInd    = onesInRows;             % �ҵ���j����1��λ��
        rowDegree = length(colInd);            %����
        qMessages = M(jj, colInd);        % �ҵ���j�������е�q��Ϣ
        qSign     = sign(qMessages);           % q��Ϣ�ķ���
        signProd  = prod(qSign) ;              % ���ų˻�
        qMesAbs   = abs(qMessages);            % ����ֵ
        signEx    = signProd .* qSign ;        % ����Ϣ�ķ��ţ������ų�������ź�ĳ˻�
        
        qMesSort = sort(qMesAbs);                          %����
        rMesAbs  = qMesSort(1)*ones(1,rowDegree);          %У����Ϣѡ����С��q��Ϣ
        ind = find(qMesAbs == qMesSort(1));                %�ҵ�qmessages����С���Ǹ�
        rMesAbs(ind) = qMesSort(2);                         %����С��q��Ϣ��Ӧ��r��Ϣ������q��Ϣ�е���Сֵ
        rMessages  = signEx .* rMesAbs .* sf;              %��õ�j��������Ԫ�ص�r��Ϣ
        E(jj, colInd) = rMessages;                    %��ŵ�rMatrix��              
    end
    
    %������Ϣ�ڵ�,Test
    for ii=1:n
        onesInCols=find(H(:,ii)==1);
        rowInd    = onesInCols;
        rMessages = E(rowInd, ii);
        L(ii)=r(ii)+sum(rMessages);
        qMessages = L(ii) - rMessages;           % ������Ϣ�������еĳ�ȥ�����У����Ϣ֮��
        M(rowInd, ii) = qMessages;           % ��ŵ�qMatrix��
        if L(ii)<=0
            z(ii)=1;
        else
            z(ii)=0;
        end
        
    end
    

    Hz=mod(H*z',2);
    
    if I==Imax || isempty(find(Hz, 1))
        fprintf('finish at iteration %d\n',I);
        MM=z;
        cycle=I;
        return;
    end
    
    I=I+1;    
end