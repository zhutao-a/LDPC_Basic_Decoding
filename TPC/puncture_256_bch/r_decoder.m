function [decision_codeword,w]=r_decoder(r,gf_table,t)%每一行或者列的译码，length(r)=256=239信息+16校验+1奇偶
%gf_table表示GF(2^8)查找表，t表示以格雷码的形式生成错误图样t=error_pattern_generate(6)
abs_r=abs(r(1:255));%除去奇偶位r的绝对值
%%
%速度更快
LRP_index=zeros(1,6);%r中除去奇偶位最不可靠6个位置
for i=1:6
    [~,LRP_index(i)]=min(abs_r);
    abs_r(LRP_index(i))=realmax;
end
for i=1:6%复原abs_r
    abs_r(LRP_index(i))=abs(r(LRP_index(i)));
end
%%
%以下是为了与硬件顺序相匹配，还有下文中的t(i,7-k)也是为了与硬件顺序匹配
% LRP_index=select_256_to_6min(abs_r);
% LRP_index=256-LRP_index;
%%
b=zeros(1,256);%初始化硬盘决序列
for i=1:256%硬盘决序列赋值
    if r(i)<0
        b(i)=1;
    end
end
candidate_number=0;
candidate_codeword=zeros(32,256);
m=zeros(32,1);%模拟重量
flag=zeros(32,1);
S_1=S_calculator(b,1,gf_table);%计算出b的S1
S_3=S_calculator(b,3,gf_table);%计算出b的S3
for i=1:64%生成测试序列
    if mod(sum(b)+sum(t(i,:)),2)==0%加上错误图样后满足奇偶校验
        candidate_number=candidate_number+1;
        analog_weight=0;
        T=b;
        for k=1:6%计算出模拟重量%计算出此时的测试序列T
            analog_weight=analog_weight+t(i,7-k)*abs_r(LRP_index(k));
            T(LRP_index(k))=mod(T(LRP_index(k))+t(i,7-k),2);
        end
        S1_new=S_1;
        S3_new=S_3;
        for k=1:6%计算出新的S1%计算出新的S3
            S1_new=mod(S1_new+t(i,7-k)*gf_table(256-LRP_index(k),:),2);
            S3_new=mod(S3_new+t(i,7-k)*gf_table(mod(3*(255-LRP_index(k)),255)+1,:),2);
        end
        [error_number,error1,error2]=calculate_root(S1_new,S3_new,gf_table);%判断测试序列是否为候选码字
        if error_number==2%有两错误
            flag(candidate_number)=1;
            m(candidate_number)=analog_weight;
            for k=1:6%由于error2(1)引起的模拟重量变化
                if(error2(1)==LRP_index(k)&&t(i,7-k)==1)
                    m(candidate_number)=m(candidate_number)-abs_r(LRP_index(k));
                    break;
                else
                    if(k==6)
                        m(candidate_number)=m(candidate_number)+abs_r(error2(1));
                    end
                end
            end
            for k=1:6%由于error2(2)引起的模拟重量变化
                if(error2(2)==LRP_index(k)&&t(i,7-k)==1)
                    m(candidate_number)=m(candidate_number)-abs_r(LRP_index(k));
                    break;
                else
                    if(k==6)
                        m(candidate_number)=m(candidate_number)+abs_r(error2(2));
                    end
                end
            end
            candidate_codeword(candidate_number,:)=T;
            candidate_codeword(candidate_number,error2(1))=~candidate_codeword(candidate_number,error2(1));
            candidate_codeword(candidate_number,error2(2))=~candidate_codeword(candidate_number,error2(2));
        elseif error_number==1%有一错误
            flag(candidate_number)=1;
            m(candidate_number)=analog_weight;
            for k=1:6%由于error1引起的模拟重量变化
                if(error1==LRP_index(k)&&t(i,7-k)==1)
                    m(candidate_number)=m(candidate_number)-abs_r(error1);
                    break;
                else
                    if(k==6)
                        m(candidate_number)=m(candidate_number)+abs_r(error1);
                    end
                end
            end
            for k=1:6%由于奇偶校验引起的模拟重量变化
                if(LRP_index(k)==256&&t(i,7-k)==1)
                    m(candidate_number)=m(candidate_number)-abs(r(256));
                    break;
                else
                    if(k==6)
                        m(candidate_number)=m(candidate_number)+abs(r(256));
                    end
                end
            end
            candidate_codeword(candidate_number,:)=T;
            candidate_codeword(candidate_number,error1)=~candidate_codeword(candidate_number,error1);
            candidate_codeword(candidate_number,256)=~candidate_codeword(candidate_number,256);
        elseif error_number==0%没有错误
            flag(candidate_number)=1;
            m(candidate_number)=analog_weight;
            candidate_codeword(candidate_number,:)=T;
        else%无法解码
            continue;
        end   
    end
end

flag_index=find(flag);
[m_oder,m_index,~]=unique(m(flag_index));%升序排列,并消除相同值
number=length(m_oder);
if(number==0)
    w=zeros(1,256);%初始化外信息
    decision_codeword=b;
else
    m_max=m_oder(number);%最大模拟重量
    m_d=m_oder(1);%最小模拟重量，即判决码字重量
    decision_codeword=candidate_codeword(flag_index(m_index(1)),:);  

    w=zeros(1,256);%初始化外信息
    for i=1:256%求判决码字每个比特竞争码字，每个比特外信息
        exist=0;%竞争码字存在标志位

        if(number>4)
            for j=1:4%找最小模拟重量竞争码字
                if decision_codeword(i)~=candidate_codeword(flag_index(m_index(j)),i)
                    exist=1;
                    m_c=m(flag_index(m_index(j)));%求出竞争码字模拟重量
                    break;
                end
            end
        else
            for j=1:number%找最小模拟重量竞争码字
                if decision_codeword(i)~=candidate_codeword(flag_index(m_index(j)),i)
                    exist=1;
                    m_c=m(flag_index(m_index(j)));%求出竞争码字模拟重量
                    break;
                end
            end
        end

        if exist==0%不存在竞争码字
            w(i)=(fix((m_max-m_d)/8)+fix((m_max-m_d)/16))*(1-2*decision_codeword(i));%(fix((m_max-m_d)/8)+fix((m_max-m_d)/16))
        else%存在竞争码字
            w(i)=(m_c-m_d)*(1-2*decision_codeword(i))-r(i);
        end
    end
end