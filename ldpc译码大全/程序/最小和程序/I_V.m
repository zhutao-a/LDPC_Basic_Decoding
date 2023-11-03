function [infor_V,k,V_infor,b]=I_V(H)
% ==============================================================================================
% functions   信息节点与变量节点的对应关系
% qian chen
% =========================================================================
% =====================
%检测校验矩阵H中1的位置。
%infor_V表示信息节点与变量节点的对应关系
%V_infor表示变量节点与信息节点的对应关系
%初始化用到的数组
% infor_V=zeros(size(H,1),6); %列数表示H矩阵的行重
k=zeros(1,size(H,1));  
% V_infor=zeros(size(H,1),3); %列数表示H矩阵的列重
b=zeros(1,size(H,2));
%信息对变量
for index12=1:size(H,1)%H的行数
    i=0;
    for index13=1:size(H,2)%H的列数
        k(index12)=k(index12)+H(index12,index13);%列重
        if H(index12,index13)==1
            i=i+1;
            %行表示信息节点的下标，列表示信息节点对应变量的个数
            %数组中保存的是每个信息节点对应的变量的下标
            infor_V(index12,i)=index13; 
        end
    end
end
%变量对信息      
for index14=1:size(H,2)%H的列数
    j=0;
    for index15=1:size(H,1)%H的行数
        b(index14)=b(index14)+H(index15,index14);%行重
        if H(index15,index14)==1
            j=j+1;
            %行表示变量的下标，列表示每个变量对应的信息节点的个数，
            %数组中保存的是每个变量对应信息节点的下标
            V_infor(index14,j)=index15;
        end
    end
end