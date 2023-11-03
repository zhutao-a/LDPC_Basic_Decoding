function [decision_codeword,w]=r_decoder(r,gf_table,t)%ÿһ�л����е����룬length(r)=256=239��Ϣ+16У��+1��ż
%gf_table��ʾGF(2^8)���ұ�t��ʾ�Ը��������ʽ���ɴ���ͼ��t=error_pattern_generate(6)
abs_r=abs(r(1:255));%��ȥ��żλr�ľ���ֵ
%%
%�ٶȸ���
LRP_index=zeros(1,6);%r�г�ȥ��żλ��ɿ�6��λ��
for i=1:6
    [~,LRP_index(i)]=min(abs_r);
    abs_r(LRP_index(i))=realmax;
end
for i=1:6%��ԭabs_r
    abs_r(LRP_index(i))=abs(r(LRP_index(i)));
end
%%
%������Ϊ����Ӳ��˳����ƥ�䣬���������е�t(i,7-k)Ҳ��Ϊ����Ӳ��˳��ƥ��
% LRP_index=select_256_to_6min(abs_r);
% LRP_index=256-LRP_index;
%%
b=zeros(1,256);%��ʼ��Ӳ�̾�����
for i=1:256%Ӳ�̾����и�ֵ
    if r(i)<0
        b(i)=1;
    end
end
candidate_number=0;
candidate_codeword=zeros(32,256);
m=zeros(32,1);%ģ������
flag=zeros(32,1);
S_1=S_calculator(b,1,gf_table);%�����b��S1
S_3=S_calculator(b,3,gf_table);%�����b��S3
for i=1:64%���ɲ�������
    if mod(sum(b)+sum(t(i,:)),2)==0%���ϴ���ͼ����������żУ��
        candidate_number=candidate_number+1;
        analog_weight=0;
        T=b;
        for k=1:6%�����ģ������%�������ʱ�Ĳ�������T
            analog_weight=analog_weight+t(i,7-k)*abs_r(LRP_index(k));
            T(LRP_index(k))=mod(T(LRP_index(k))+t(i,7-k),2);
        end
        S1_new=S_1;
        S3_new=S_3;
        for k=1:6%������µ�S1%������µ�S3
            S1_new=mod(S1_new+t(i,7-k)*gf_table(256-LRP_index(k),:),2);
            S3_new=mod(S3_new+t(i,7-k)*gf_table(mod(3*(255-LRP_index(k)),255)+1,:),2);
        end
        [error_number,error1,error2]=calculate_root(S1_new,S3_new,gf_table);%�жϲ��������Ƿ�Ϊ��ѡ����
        if error_number==2%��������
            flag(candidate_number)=1;
            m(candidate_number)=analog_weight;
            for k=1:6%����error2(1)�����ģ�������仯
                if(error2(1)==LRP_index(k)&&t(i,7-k)==1)
                    m(candidate_number)=m(candidate_number)-abs_r(LRP_index(k));
                    break;
                else
                    if(k==6)
                        m(candidate_number)=m(candidate_number)+abs_r(error2(1));
                    end
                end
            end
            for k=1:6%����error2(2)�����ģ�������仯
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
        elseif error_number==1%��һ����
            flag(candidate_number)=1;
            m(candidate_number)=analog_weight;
            for k=1:6%����error1�����ģ�������仯
                if(error1==LRP_index(k)&&t(i,7-k)==1)
                    m(candidate_number)=m(candidate_number)-abs_r(error1);
                    break;
                else
                    if(k==6)
                        m(candidate_number)=m(candidate_number)+abs_r(error1);
                    end
                end
            end
            for k=1:6%������żУ�������ģ�������仯
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
        elseif error_number==0%û�д���
            flag(candidate_number)=1;
            m(candidate_number)=analog_weight;
            candidate_codeword(candidate_number,:)=T;
        else%�޷�����
            continue;
        end   
    end
end

flag_index=find(flag);
[m_oder,m_index,~]=unique(m(flag_index));%��������,��������ֵͬ
number=length(m_oder);
if(number==0)
    w=zeros(1,256);%��ʼ������Ϣ
    decision_codeword=b;
else
    m_max=m_oder(number);%���ģ������
    m_d=m_oder(1);%��Сģ�����������о���������
    decision_codeword=candidate_codeword(flag_index(m_index(1)),:);  

    w=zeros(1,256);%��ʼ������Ϣ
    for i=1:256%���о�����ÿ�����ؾ������֣�ÿ����������Ϣ
        exist=0;%�������ִ��ڱ�־λ

        if(number>4)
            for j=1:4%����Сģ��������������
                if decision_codeword(i)~=candidate_codeword(flag_index(m_index(j)),i)
                    exist=1;
                    m_c=m(flag_index(m_index(j)));%�����������ģ������
                    break;
                end
            end
        else
            for j=1:number%����Сģ��������������
                if decision_codeword(i)~=candidate_codeword(flag_index(m_index(j)),i)
                    exist=1;
                    m_c=m(flag_index(m_index(j)));%�����������ģ������
                    break;
                end
            end
        end

        if exist==0%�����ھ�������
            w(i)=(fix((m_max-m_d)/8)+fix((m_max-m_d)/16))*(1-2*decision_codeword(i));%(fix((m_max-m_d)/8)+fix((m_max-m_d)/16))
        else%���ھ�������
            w(i)=(m_c-m_d)*(1-2*decision_codeword(i))-r(i);
        end
    end
end