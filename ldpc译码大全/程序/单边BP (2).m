function output= decoder_BP_EB(H,y_signal,sigma,L,df)
%���㷨Ϊ J. Hu and T. Duman, Graph-based detection algorithms for layered space-time architectures �������EB�㷨
% H : the channel matrix
% the receiver know the channel perfectly
% decoder_y_signal :signal passed channel with noise polluted
% BPSK

[Tr,Tx] = size(H);
output=zeros(Tx,1);

beta=zeros(Tr,Tx); %��Ϣ����
alph=zeros(Tx,Tr); %��Ϣ����
alph2=zeros(Tx,Tr); %��Ϣ����

%��������ȫ��df��С�Ľ�ռ�
space_temp1=[1 1 -1 -1; 1 -1  1 -1;];
k=2;
while (k<df)
    space_temp2=zeros(k+1,2^(k+1));
    for ii=1:2^k
        space_temp2(:,2*ii-1)=[space_temp1(:,ii); 1];
        space_temp2(:,2*ii)=[space_temp1(:,ii); -1];
    end
    k=k+1;
    space_temp1=space_temp2;
end
if df==1
    x_space=[1 -1];
else
    x_space=space_temp1;
end

%������ŵ����������ŵ����������
index=zeros(Tr,Tx); %����H��ÿһ�е�Ԫ�ش�С�����������±�ֵ
for i=1:Tr
    [~, index(i,:)]=sort(abs(H(i,:)));
end

%����������ͨ�Ⱦ���ָʾ���ؽڵ�����ӽڵ�����ͨ���
connection=zeros(Tr,Tx);
for i=1:Tr
    for j=1:df
        connection(i,index(i,Tx-j+1))=1;
    end
end

for l=1:L
    %���濪ʼ����
    
    %����beta
    for i=1:Tr %��ÿ��y(i)ѭ��
        for j=1:Tx
            max1=-100000;
            max2=-100000;
            if connection(i,j)==1
                index_j=find(index(i,:)==j); %�ҳ�j�ڱ��ؽڵ��е�����
                index_j=Tx-index_j+1;
                
                %����Խ�ռ�ѭ��
                for mm=1:2^df
                    
                    %�������ѡ������h���źŵĳ˻�
                    Hx_temp=0;
                    for i_df=1:df
                        Hx_temp= Hx_temp+H(i,index(i,Tx-i_df+1))*x_space(i_df,mm); %��¼ѡ������h*x,������h��ʼ��
                    end
                    
                    %�����ĸ�����������
                    sig=sigma;
                    if df~=Tx
                        for ii_df=1:Tx-df
                            sig=sig+abs(H(i,index(i,ii_df)))^2;
                        end
                    end
                    
                    %��������źſռ�ĵ�j��Ϊ1ʱ��betaֵ
                    if x_space(index_j,mm)==1
                        temp1=-abs(y_signal(i)-Hx_temp)^2/sig;
                        
                        %����alph���ۼӺ�
                        for kk=1:Tx
                            if  kk~=j && connection(i,kk)==1
                                index_xspace=find(index(i,:)==kk); %�ҳ�kk�ڱ��ؽڵ��е�����
                                if x_space(Tx-index_xspace+1,mm)==1
                                    temp1=temp1+alph2(kk,i);
                                end
                            end
                        end
                        
                        %�������ֵ
                        if temp1>max1
                            max1=temp1;
                        end
                        
                        %��������źſռ�ĵ�j��Ϊ-1ʱ��betaֵ
                    elseif x_space(index_j,mm)==-1
                        temp2=-abs(y_signal(i)-Hx_temp)^2/sig;
                        
                        %����alph���ۼӺ�
                        for kk=1:Tx
                            if  kk~=j && connection(i,kk)==1
                                index_xspace=find(index(i,:)==kk); %�ҳ�kk�ڱ��ؽڵ��е�����
                                if x_space(Tx-index_xspace+1,mm)==1
                                    temp2=temp2+alph2(kk,i);
                                end
                            end
                        end
                        
                        %�������ֵ
                        if temp2>max2
                            max2=temp2;
                        end
                    end
                end %��ռ�ѭ�����
                
            elseif connection(i,j)==0
                %������ؽڵ���i�����ӽڵ㲻���������øñ��ؽڵ����df�����ؽڵ��е���С��һ��
                index_sub=index(i,:);
                index_sub((index_sub==j))=index_sub(Tx-df+1);
                index_sub(Tx-df+1)=j;
                index_j=df;
                
                for mm=1:2^df
                    
                    %�������ѡ������h���źŵĳ˻�
                    Hx_temp=0;
                    for i_df=1:df
                        Hx_temp= Hx_temp+H(i,index_sub(Tx-i_df+1))*x_space(i_df,mm); %��¼ѡ������h*x,������h��ʼ��
                    end
                    
                    %�����ĸ�����������
                    sig=sigma;
                    if df~=Tx
                        for ii_df=1:Tx-df
                            sig=sig+abs(H(i,index_sub(ii_df)))^2;
                        end
                    end
                    
                    %��������źſռ�ĵ�j��Ϊ1ʱ��betaֵ
                    if x_space(index_j,mm)==1
                        temp1=-abs(y_signal(i)-Hx_temp)^2/sig;
                        
                        %����alph���ۼӺ�
                        for kk=1:Tx
                            if  kk~=index(i,Tx-df+1) && connection(i,kk)==1
                                index_xspace=find(index(i,:)==kk); %�ҳ�kk�ڱ��ؽڵ��е�����
                                if x_space(Tx-index_xspace+1,mm)==1
                                    temp1=temp1+alph2(kk,i);
                                end
                            end
                        end
                        
                        %�������ֵ
                        if temp1>max1
                            max1=temp1;
                        end
                        
                        %��������źſռ�ĵ�j��Ϊ-1ʱ��betaֵ
                    elseif x_space(index_j,mm)==-1
                        temp2=-abs(y_signal(i)-Hx_temp)^2/sig;
                        
                       % ����alph���ۼӺ�
                        for kk=1:Tx
                            if  kk~=index(i,Tx-df+1) && connection(i,kk)==1
                                index_xspace=find(index(i,:)==kk); %�ҳ�kk�ڱ��ؽڵ��е�����
                                if x_space(Tx-index_xspace+1,mm)==1
                                    temp2=temp2+alph2(kk,i);
                                end
                            end
                        end
                        
                        %�������ֵ
                        if temp2>max2
                            max2=temp2;
                        end
                    end
                end %��ռ�ѭ�����
            end
            
            beta(i,j)=max1-max2;
        end
    end
    
    %�������alph
    for i=1:Tr
        for j=1:Tx
            temp3=0;
            for k=1:Tr
                if k~=i
                    temp3=temp3+beta(k,j);
                end
            end
            alph(j,i)=temp3;
        end
    end
    
    alph2=alph;
    
end %һ�ε������

%�������õ��ı�Ե���ʣ�Ȼ�����
for j=1:Tx
    temp4=0;
    for k=1:Tr
        temp4=temp4+beta(k,j);
    end
    if temp4>0
        output(j)=1;
    else
        output(j)=-1;
    end
end

