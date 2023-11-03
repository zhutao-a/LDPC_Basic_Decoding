function [decision_codeword,w]=r_decoder(r)%每一行或者列的译码，length(r)=256=239信息+16校验+1奇偶
abs_r=abs(r(1:127));%除去奇偶位r的绝对值
LRP_index=zeros(1,6);%r中除去奇偶位最不可靠6个位置
for i=1:6
    [~,LRP_index(i)]=min(abs_r);
    abs_r(LRP_index(i))=realmax;
end
for i=1:6%复原abs_r
    abs_r(LRP_index(i))=abs(r(LRP_index(i)));
end
b=zeros(1,128);%初始化硬盘决序列
for i=1:128%硬盘决序列赋值
    if r(i)>0
        b(i)=1;
    end
end 
t=error_pattern_generate(6);%以格雷码的形式生成错误图样
m=zeros(64,1);%初始化候选码字的模拟重量
candidate_codeword=zeros(64,128);%初始化候选码字列表
flag=zeros(64,1);%第i个测试序列是否是候选码字标志位

for i=1:64%计算候选码字和模拟重量
    T=b;
    if(mod((sum(b)+sum(t(i,:))),2)==0)%满足奇偶校验关系
        for k=1:6%计算出此时的测试序列T
            T(LRP_index(k))=mod(T(LRP_index(k))+t(i,k),2);
        end
        H=gf(T);
        [~,cnumerr,decoded] = bchdec(H(1:127),127,113);
        G=double(decoded.x);
        if((mod(sum(G)+T(128),2)==0)&&(cnumerr~=-1))%满足奇偶校验关系
            flag(i)=1;
            candidate_codeword(i,:)=[G,T(128)];
            m(i)=sum(mod(candidate_codeword(i,:)+b,2).*abs(r));
        end
    end
end

flag_index=find(flag);
[m_oder,m_index,~]=unique(m(flag_index));%升序排列,并消除相同值
number=length(m_oder);
m_max=m_oder(number);%最大模拟重量
m_d=m_oder(1);%最小模拟重量，即判决码字重量
decision_codeword=candidate_codeword(flag_index(m_index(1)),:);  

w=zeros(1,128);%初始化外信息
for i=1:128%求判决码字每个比特竞争码字，每个比特外信息
    exist=0;%竞争码字存在标志位
    for j=1:number%找最小模拟重量竞争码字
        if decision_codeword(i)~=candidate_codeword(flag_index(m_index(j)),i)
            exist=1;
            m_c=m(flag_index(m_index(j)));%求出竞争码字模拟重量
            break;
        end
    end
    if exist==0%不存在竞争码字
        w(i)=(m_max-m_d)/6*(1-2*decision_codeword(i));
    else%存在竞争码字
        w(i)=(m_c-m_d)*(1-2*decision_codeword(i))-r(i);
    end
end
