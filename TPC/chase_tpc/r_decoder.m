function [decision_codeword,w]=r_decoder(r,gf_table,t,beta)%ÿһ�л����е����룬length(r)=256=239��Ϣ+16У��+1��ż
%gf_table��ʾGF(2^8)���ұ�t��ʾ�Ը��������ʽ���ɴ���ͼ��t=error_pattern_generate(6)
abs_r=abs(r(1:255));%��ȥ��żλr�ľ���ֵ
LRP_index=zeros(1,6);%r�г�ȥ��żλ��ɿ�6��λ��
for i=1:6
    [~,LRP_index(i)]=min(abs_r);
    abs_r(LRP_index(i))=realmax;
end
for i=1:6%��ԭabs_r
    abs_r(LRP_index(i))=abs(r(LRP_index(i)));
end
b=zeros(1,256);%��ʼ��Ӳ�̾�����
for i=1:256%Ӳ�̾����и�ֵ``
    if r(i)>0
        b(i)=1;
    end
end 
T=zeros(64,256);
for i=1:64%���ɲ�������
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
for i=1:64%�����ѡ�����б�
    S_1=S_calculator(T(i,:),1,gf_table);
    S_3=S_calculator(T(i,:),3,gf_table);
    [error_number,error1,error2]=calculate_root(S_1,S_3,gf_table);%�жϵ�i�����������Ƿ�Ϊ��ѡ����
    if error_number==2%��������
        candidate_number=candidate_number+1;
        candidate_codeword(candidate_number,:)=T(i,:);
        candidate_codeword(candidate_number,error2(1))=~candidate_codeword(candidate_number,error2(1));
        candidate_codeword(candidate_number,error2(2))=~candidate_codeword(candidate_number,error2(2));
    elseif error_number==1%��һ����
        candidate_number=candidate_number+1;
        candidate_codeword(candidate_number,:)=T(i,:);
        candidate_codeword(candidate_number,error1)=~candidate_codeword(candidate_number,error1);
        candidate_codeword(candidate_number,256)=~candidate_codeword(candidate_number,256);
    elseif error_number==0%û�д���
        candidate_number=candidate_number+1;
        candidate_codeword(candidate_number,:)=T(i,:);
    else%�޷�����
        continue;
    end      
end

L=zeros(candidate_number,1);
for i=1:candidate_number%�������к�ѡ������������е�ŷʽ����
    bpsk_candidate_codeword=2*candidate_codeword(i,:)-1;
    L(i)=0;
    for j=1:256
        L(i)=L(i)+(bpsk_candidate_codeword(j)-r(j))^2;
    end   
end
[~,L_index]=sort(L);%��������L
decision_codeword=candidate_codeword(L_index(1),:);%ѡ����Сŷʽ����ĺ�ѡ������Ϊ�о�����
L_d=L(L_index(1));%�о�����ŷʽ����

w=zeros(1,256);
for i=1:256%����о�����ÿ�����صľ������ֲ���������Ϣ
    exist=0;
    for j=1:candidate_number%�о����ֵ�i�������Ƿ���ھ�������
        if decision_codeword(i)~=candidate_codeword(L_index(j),i)
            exist=1;%���ھ�������
            L_ci=L(L_index(j));
            break;
        end
    end
    if exist==0%�����ھ�������
        w(i)=beta*(2*decision_codeword(i)-1);
    else%���ھ�������
        w(i)=((L_ci-L_d)/4)*(2*decision_codeword(i)-1)-r(i);
    end
end






