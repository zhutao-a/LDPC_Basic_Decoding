function output= decoder_BP_SE_ref(H,y_signal,sigma,L)
% A. Chockalingam, “Low-Complexity Algorithms for Large-MIM0 Detection,” 中的算法
% H : the channel matrix
% the receiver know the channel perfectly
% decoder_y_signal :signal passed channel with noise polluted
% BPSK

[Tr,Tx] = size(H);
output=zeros(Tx,1);

beta=zeros(Tr,Tx); %消息数组
alph=zeros(Tx,Tr); %消息数组
p=zeros(Tx,Tr); %信号的概率分布，为+1的概率
u=zeros(Tr,Tx);
sig=zeros(Tr,Tx);

for l=1:L
    %下面开始循环
    
    %下面计算信号的概率分布
    for i=1:Tr
        for j=1:Tx
            p(j,i)=exp(alph(j,i))/(1+exp(alph(j,i)));
        end
    end
    
    %计算beta
    for i=1:Tr
        for j=1:Tx
            %下面计算均值和方差
            u(i,j)=0;
            for kk=1:Tx
                if kk~=j
                    u(i,j)=u(i,j)+H(i,kk)*(2*p(kk,i)-1);
                end
            end
            sig(i,j)=sigma;
            for kk=1:Tx
                if kk~=j
                    sig(i,j)=sig(i,j)+abs(H(i,kk))^2 * (4*p(kk,i)*(1-p(kk,i)));
                end
            end
                    
            beta(i,j)=4*real(H(i,j)'*(y_signal(i)-u(i,j))) /sig(i,j);
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
    
end

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

