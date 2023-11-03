function [decision_codeword,w]=r_decoder(r,gf_table,t,beta)%每一行或者列的译码，length(r)=256=239信息+16校验+1奇偶
%gf_table表示GF(2^8)查找表，t表示以格雷码的形式生成错误图样t=error_pattern_generate(6)
abs_r=abs(r(1:255));%除去奇偶位r的绝对值
LRP_index=zeros(1,6);%r中除去奇偶位最不可靠6个位置
for i=1:6
    [~,LRP_index(i)]=min(abs_r);
    abs_r(LRP_index(i))=realmax;
end
for i=1:6%复原abs_r
    abs_r(LRP_index(i))=abs(r(LRP_index(i)));
end
b=zeros(1,256);%初始化硬盘决序列
for i=1:256%硬盘决序列赋值``
    if r(i)>0
        b(i)=1;
    end
end 
T=zeros(64,256);
for i=1:64%生成测试序列
    T(i,:)=b;
    T(i,LRP_index(1))=mod(T(i,LRP_index(1))+t(i,1),2);
    T(i,LRP_index(2))=mod(T(i,LRP_index(2))+t(i,2),2);
    T(i,LRP_index(3))=mod(T(i,LRP_index(3))+t(i,3),2);
    T(i,LRP_index(4))=mod(T(i,LRP_index(4))+t(i,4),2);
    T(i,LRP_index(5))=mod(T(i,LRP_index(5))+t(i,5),2);
    T(i,LRP_index(6))=mod(T(i,LRP_index(6))+t(i,6),2);
    T(i,256)=mod(sum(T(i,1:255)),2);
end
candidate_number=0;
candidate_codeword=zeros(64,256);
for i=1:64%求出候选码字列表
    S_1=S_calculator(T(i,:),1,gf_table);
    S_3=S_calculator(T(i,:),3,gf_table);
    [error_number,error1,error2]=calculate_root(S_1,S_3,gf_table);%判断第i个测试序列是否为候选码字
    if error_number==2%有两错误
        candidate_number=candidate_number+1;
        candidate_codeword(candidate_number,:)=T(i,:);
        candidate_codeword(candidate_number,error2(1))=~candidate_codeword(candidate_number,error2(1));
        candidate_codeword(candidate_number,error2(2))=~candidate_codeword(candidate_number,error2(2));
    elseif error_number==1%有一错误
        candidate_number=candidate_number+1;
        candidate_codeword(candidate_number,:)=T(i,:);
        candidate_codeword(candidate_number,error1)=~candidate_codeword(candidate_number,error1);
        candidate_codeword(candidate_number,256)=~candidate_codeword(candidate_number,256);
    elseif error_number==0%没有错误
        candidate_number=candidate_number+1;
        candidate_codeword(candidate_number,:)=T(i,:);
    else%无法解码
        continue;
    end      
end

L=zeros(candidate_number,1);
for i=1:candidate_number%计算所有候选码字与接收序列的欧式距离
    bpsk_candidate_codeword=2*candidate_codeword(i,:)-1;
    L(i)=0;
    for j=1:256
        L(i)=L(i)+(bpsk_candidate_codeword(j)-r(j))^2;
    end   
end
[~,L_index]=sort(L);%升序排列L
decision_codeword=candidate_codeword(L_index(1),:);%选择最小欧式距离的候选码子作为判决码字
L_d=L(L_index(1));%判决码字欧式距离

w=zeros(1,256);
for i=1:256%求出判决码字每个比特的竞争码字并计算外信息
    exist=0;
    for j=1:candidate_number%判决码字第i个比特是否存在竞争码字
        if decision_codeword(i)~=candidate_codeword(L_index(j),i)
            exist=1;%存在竞争码字
            L_ci=L(L_index(j));
            break;
        end
    end
    if exist==0%不存在竞争码字
        w(i)=beta*(2*decision_codeword(i)-1);
    else%存在竞争码字
        w(i)=((L_ci-L_d)/4)*(2*decision_codeword(i)-1)-r(i);
    end
end






