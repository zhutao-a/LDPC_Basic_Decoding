function [decision_codeword,data_out,data_ram]=first_stage_decoder(data_ram,new_data,alpha,gf_table,t)%同时进行32行译码
%data_ram为存储的数据，大小[(8*2+2*G)*16,128],G=2,new_data为新输入的数据，大小[32,128]
%alpha为计算外信息时的参数
%decision_codeword为译码后的码字，大小为[32,128]
%dada_out为传给下一级的数据，大小为[32,128]
G=2;
data_ram_max=15;%存在ram里面绝对值的最大值
W_R_r=zeros(32,256);%存储32个码字
decision_codeword=zeros(32,128);
%W_R_r的前128个比特从data_ram中取
for R=0:1%R=0,r=0,k=0:127就相当于ofec说明文档中的红色线段，依此类推
    for r=0:15
        for k=0:127
            V_R=bitxor(R,1)+2*floor(k/16);  %块的行
            V_C=floor(k/16);                %块的列
            V_r=bitxor(mod(k,16),r);        %块内行
            V_c=r;                          %块内列
            W_R_r(R*16+r+1,k+1)=data_ram(V_R*16+V_r+1,(V_C)*16+V_c+1);
        end
    end
end
W_R_r(:,129:256)=new_data;%W_R_r的后128个比特从new_data中取
for k=1:32%译码，计算新一轮的软信息
    [codeword,w]=r_decoder(W_R_r(k,:),gf_table,t);
    decision_codeword(k,:)=codeword(129:256);%后128比特作为输出
    W_R_r(k,:)=fix(W_R_r(k,:)+alpha*w);%计算软信息
    for i=1:256
        if(W_R_r(k,i)>data_ram_max)
            W_R_r(k,i)=data_ram_max;
        elseif(W_R_r(k,i)<-data_ram_max)
            W_R_r(k,i)=-data_ram_max;
        end
    end
end

data_out=W_R_r(:,1:128);%斜着的前128比特输出

temp=zeros(32,128);%将后128比特乱序后存入ram中
for R=0:1
    for r=0:15
        for k=0:127
            V_R=R;                          %块的行
            V_C=floor(k/16);                %块的列
            V_r=r;                          %块内行
            V_c=bitxor(mod(k+128,16),r);    %块内列
            temp(R*16+r+1,k+1)=W_R_r(V_R*16+V_r+1,128+(V_C)*16+V_c+1);
        end
    end
end

%往上移动32行并将新的信息W_R_r(:,129:256)放入data_ram,原先最上面的32行给data_out
data_ram=circshift(data_ram,-32);%循环向上移动32位
data_ram((7*2+2*G)*16+1:(8*2+2*G)*16,:)=temp;
