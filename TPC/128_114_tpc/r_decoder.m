function [decision_codeword,w]=r_decoder(r)%ÿһ�л����е����룬length(r)=256=239��Ϣ+16У��+1��ż
abs_r=abs(r(1:127));%��ȥ��żλr�ľ���ֵ
LRP_index=zeros(1,6);%r�г�ȥ��żλ��ɿ�6��λ��
for i=1:6
    [~,LRP_index(i)]=min(abs_r);
    abs_r(LRP_index(i))=realmax;
end
for i=1:6%��ԭabs_r
    abs_r(LRP_index(i))=abs(r(LRP_index(i)));
end
b=zeros(1,128);%��ʼ��Ӳ�̾�����
for i=1:128%Ӳ�̾����и�ֵ
    if r(i)>0
        b(i)=1;
    end
end 
t=error_pattern_generate(6);%�Ը��������ʽ���ɴ���ͼ��
m=zeros(64,1);%��ʼ����ѡ���ֵ�ģ������
candidate_codeword=zeros(64,128);%��ʼ����ѡ�����б�
flag=zeros(64,1);%��i�����������Ƿ��Ǻ�ѡ���ֱ�־λ

for i=1:64%�����ѡ���ֺ�ģ������
    T=b;
    if(mod((sum(b)+sum(t(i,:))),2)==0)%������żУ���ϵ
        for k=1:6%�������ʱ�Ĳ�������T
            T(LRP_index(k))=mod(T(LRP_index(k))+t(i,k),2);
        end
        H=gf(T);
        [~,cnumerr,decoded] = bchdec(H(1:127),127,113);
        G=double(decoded.x);
        if((mod(sum(G)+T(128),2)==0)&&(cnumerr~=-1))%������żУ���ϵ
            flag(i)=1;
            candidate_codeword(i,:)=[G,T(128)];
            m(i)=sum(mod(candidate_codeword(i,:)+b,2).*abs(r));
        end
    end
end

flag_index=find(flag);
[m_oder,m_index,~]=unique(m(flag_index));%��������,��������ֵͬ
number=length(m_oder);
m_max=m_oder(number);%���ģ������
m_d=m_oder(1);%��Сģ�����������о���������
decision_codeword=candidate_codeword(flag_index(m_index(1)),:);  

w=zeros(1,128);%��ʼ������Ϣ
for i=1:128%���о�����ÿ�����ؾ������֣�ÿ����������Ϣ
    exist=0;%�������ִ��ڱ�־λ
    for j=1:number%����Сģ��������������
        if decision_codeword(i)~=candidate_codeword(flag_index(m_index(j)),i)
            exist=1;
            m_c=m(flag_index(m_index(j)));%�����������ģ������
            break;
        end
    end
    if exist==0%�����ھ�������
        w(i)=(m_max-m_d)/6*(1-2*decision_codeword(i));
    else%���ھ�������
        w(i)=(m_c-m_d)*(1-2*decision_codeword(i))-r(i);
    end
end
