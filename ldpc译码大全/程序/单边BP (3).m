function output= decoder_BP_CPE(H,y_signal,sigma,L,threshold)
% 信道决定边数的部分边BP
% the receiver know the channel perfectly
% decoder_y_signal :signal passed channel with noise polluted
% BPSK

[Tr,Tx] = size(H);
output=zeros(Tx,1);

beta=zeros(Tr,Tx); %消息数组
alph=zeros(Tx,Tr); %消息数组
alph2=zeros(Tx,Tr); %消息数组

p=zeros(Tx,Tr); %信号的概率分布，为+1的概率

%下面对信道排序，生成信道的排序矩阵
index=zeros(Tr,Tx); %储存H中每一行的元素从小到大排序后的下标值
for i=1:Tr
    [~, index(i,:)]=sort(abs(H(i,:)));
end

%下面根据排序矩阵index生成连通矩阵和每个因子节点对应的df
connection=zeros(Tr,Tx);
df=zeros(Tr,1);
for i=1:Tr
    for j=1:Tx
        if abs(H(i,j))>threshold
            df(i)=df(i)+1;
            connection(i,j)=1;
        end
    end
    if df(i)==0
        df(i)=1;
        max=abs(H(i,1));
        index_max=1;
        for j=2:Tx
            if abs(H(i,j))>max
                max=abs(H(i,j));
                index_max=j;
            end
        end
        connection(i,index_max)=1;
    end
end

for l=1:L
    %下面开始迭代
    
    %下面计算信号的概率分布
    for i=1:Tr
        for j=1:Tx
            p(j,i)=exp(alph2(j,i))/(1+exp(alph2(j,i)));
        end
    end
    
    %计算beta
    for i=1:Tr %对每个y(i)循环
        
        %生成对应大小的解空间
        space_temp1=[1 1 -1 -1; 1 -1  1 -1;];
        k=2;
        while (k<df(i))
            space_temp2=zeros(k+1,2^(k+1));
            for ii=1:2^k
                space_temp2(:,2*ii-1)=[space_temp1(:,ii); 1];
                space_temp2(:,2*ii)=[space_temp1(:,ii); -1];
            end
            k=k+1;
            space_temp1=space_temp2;
        end
        if df(i)==1
            x_space=[1 -1];
        else
            x_space=space_temp1;
        end
        
        for j=1:Tx
            max1=-100000;
            max2=-100000;
            if connection(i,j)==1
                index_j=find(index(i,:)==j); %找出j在比特节点中的排序
                index_j=Tx-index_j+1;
                
                %下面对解空间循环
                for mm=1:2^df(i)
                    
                    %下面计算选出来的h和信号的乘积
                    Hx_temp=0;
                    for i_df=1:df(i)
                        Hx_temp= Hx_temp+H(i,index(i,Tx-i_df+1))*x_space(i_df,mm); %记录选出来的h*x,从最大的h开始乘
                    end
                    
                    %计算分母项，总噪声功率
                    u_temp=0;
                    sig=sigma;
                    if df(i)~=Tx
                        for ii_df=1:Tx-df(i)
                            u_temp=u_temp+H(i,index(i,ii_df))*(2*p(index(i,ii_df),i)-1);
                            sig=sig+abs(H(i,index(i,ii_df)))^2;
                        end
                    end
                    
                    %下面计算信号空间的第j项为1时的beta值
                    if x_space(index_j,mm)==1
                        temp1=-abs(y_signal(i)-Hx_temp-u_temp)^2/sig;
                        
                        %计算alph的累加和
                        for kk=1:Tx
                            if  kk~=j && connection(i,kk)==1
                                index_xspace=find(index(i,:)==kk); %找出kk在比特节点中的排序
                                if x_space(Tx-index_xspace+1,mm)==1
                                    temp1=temp1+alph2(kk,i);
                                end
                            end
                        end
                        
                        %更新最大值
                        if temp1>max1
                            max1=temp1;
                        end
                        
                        %下面计算信号空间的第j项为-1时的beta值
                    elseif x_space(index_j,mm)==-1
                        temp2=-abs(y_signal(i)-Hx_temp-u_temp)^2/sig;
                        
                        %计算alph的累加和
                        for kk=1:Tx
                            if  kk~=j && connection(i,kk)==1
                                index_xspace=find(index(i,:)==kk); %找出kk在比特节点中的排序
                                if x_space(Tx-index_xspace+1,mm)==1
                                    temp2=temp2+alph2(kk,i);
                                end
                            end
                        end
                        
                        %更新最大值
                        if temp2>max2
                            max2=temp2;
                        end
                    end
                end %解空间循环完毕
                
            elseif connection(i,j)==0
                %如果比特节点与i个因子节点不相连，则用该比特节点代替df个比特节点中的最小的一个
                index_sub=index(i,:);
                index_sub((index_sub==j))=index_sub(Tx-df(i)+1);
                index_sub(Tx-df(i)+1)=j;
                index_j=df(i);
                
                for mm=1:2^df(i)
                    
                    %下面计算选出来的h和信号的乘积
                    Hx_temp=0;
                    for i_df=1:df(i)
                        Hx_temp= Hx_temp+H(i,index_sub(Tx-i_df+1))*x_space(i_df,mm); %记录选出来的h*x,从最大的h开始乘
                    end
                    
                    %计算分母项，总噪声功率
                    u_temp=0;
                    sig=sigma;
                    if df(i)~=Tx
                        for ii_df=1:Tx-df(i)
                            u_temp=u_temp+H(i,index_sub(ii_df))*(2*p(index_sub(ii_df),i)-1);
                            sig=sig+abs(H(i,index_sub(ii_df)))^2;
                        end
                    end
                    
                    %下面计算信号空间的第j项为1时的beta值
                    if x_space(index_j,mm)==1
                        temp1=-abs(y_signal(i)-Hx_temp-u_temp)^2/sig;
                        
                        %计算alph的累加和
                        for kk=1:Tx
                            if  kk~=index(i,Tx-df(i)+1) && connection(i,kk)==1
                                index_xspace=find(index(i,:)==kk); %找出kk在比特节点中的排序
                                if x_space(Tx-index_xspace+1,mm)==1
                                    temp1=temp1+alph2(kk,i);
                                end
                            end
                        end
                        
                        %更新最大值
                        if temp1>max1
                            max1=temp1;
                        end
                        
                        %下面计算信号空间的第j项为-1时的beta值
                    elseif x_space(index_j,mm)==-1
                        temp2=-abs(y_signal(i)-Hx_temp-u_temp)^2/sig;
                        
                        % 计算alph的累加和
                        for kk=1:Tx
                            if  kk~=index(i,Tx-df(i)+1) && connection(i,kk)==1
                                index_xspace=find(index(i,:)==kk); %找出kk在比特节点中的排序
                                if x_space(Tx-index_xspace+1,mm)==1
                                    temp2=temp2+alph2(kk,i);
                                end
                            end
                        end
                        
                        %更新最大值
                        if temp2>max2
                            max2=temp2;
                        end
                    end
                end %解空间循环完毕
            end
            
            beta(i,j)=max1-max2;
        end
    end
    
    %下面计算alph
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
    
end %一次迭代完毕

%下面计算得到的边缘概率，然后输出
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

