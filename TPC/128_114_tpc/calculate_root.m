function [error_number,error1,error2]=calculate_root(S_1,S_3)%b=239��Ϣ+16У��+1��ż,�ߴ�����ǰ
%�˺�������Ĵ���λ��ָ����b�е�λ�ã�����һ������a^234����error1=255-234=11
%�޷����error_number=3��error1=0��error2=[0,0]
%һ������error_number=1��error1=λ�ã�error2=[0,0]
%��������error_number=2��error1=0��error2=[λ��1,λ��2]
error1=0;
error2=[0,0];
gf_table=gf_table_generate();%���ұ�
for i=1:256%���S1����
    if isequal(S_1,gf_table(i,:))
        m1=i-1;%���S1��ӦԪ�ص���
        break;
    end
end
if m1==255  %S1==0ʱ����S1��^3==0,m1multiply3��ʾ��S1)^3����
    m1multiply3=255;%��S1��^3��ӦԪ����Ϊ0
else        %S1~=0ʱ
    m1multiply3=mod(3*m1,255);%��S1��^3��ӦԪ����
end
S1_power3=gf_table(m1multiply3+1,:);%��S1��^3��ӦԪ�صĶ���������
temp=mod(S_3+S1_power3,2);%�����(S1)^3+S3�Ķ���������
zero_8=[0,0,0,0,0,0,0,0];
if ( isequal(S_1,zero_8) )&&( isequal(temp,zero_8) )%S1=0and(S1)^3+S3=0,û�г���
    error_number=0;
elseif (isequal(S_1,zero_8))&&( ~isequal(temp,zero_8) )%S1=0,S3+(S1)^3~=0,�޷��������
    error_number=3;
elseif (~isequal(S_1,zero_8) )&&(isequal(temp,zero_8) )%S1~=0,S3+(S1)^3=0,��һ������
    error_number=1;%��ʱ����λ��beta1=a^j1=S1=sigma1=a^m1,������λ���ݾ���j1=m1
    error1=255-m1;
else%S1~=0,S3+(S1)^3~=0,�������ⲻ��,����λ�ö���ʽsigma2*x^2+sigma1*x=1
    %����λ�ö���ʽ��Ϊ(x')^2+x'=u,����u=sigma2/(sigma1)^2 x=x'*(sigma1/sigma2) sigma1=S1 sigma2=[(S1)^3+S3]/S1
    for i=1:255%�����(S1)^3+S3��Ӧ����
        if isequal(temp,gf_table(i,:))
             temp_power=i-1;
             break;
        end
    end
    u_power=mod(temp_power-m1multiply3,255);%�����u����
    u=gf_table(u_power+1,:);%u�Ķ����Ʊ�ʾ���ʹ�����ǰ
    if u(6)==0%a^5��Ӧϵ��Ϊ0�����������н⣬��������λ��
        error_number=2;
        y=[gf_table(85+1,:);gf_table(11+1,:);gf_table(22+1,:);gf_table(18+1,:);
           gf_table(44+1,:);gf_table(255+1,:);gf_table(36+1,:);gf_table(54+1,:)];%Ԥ���趨��y
       u_root1=zeros(1,8);
       for i=1:8%������仯����λ�ö���ʽ��һ�����Ķ���������
            u_root1=mod(u_root1+u(i)*y(i,:),2);
       end
       u_root2=mod(u_root1+ gf_table(1,:),2);%������仯����λ�ö���ʽ�ڶ������Ķ���������;
       for i=1:255%���u_root1��u_root2��Ӧ����
           if isequal(u_root1,gf_table(i,:))
               u_root1_power=i-1;
           end
           if isequal(u_root2,gf_table(i,:))
               u_root2_power=i-1;
           end
       end
       root1_power=mod(2*m1+u_root1_power-temp_power,255);%���ʵ�ʴ���λ�ö���ʽ��root1����(0->254)
       root2_power=mod(2*m1+u_root2_power-temp_power,255);%���ʵ�ʴ���λ�ö���ʽ��root2����
       error2=[255-mod(255-root1_power,255),255-mod(255-root2_power,255)];
    else%a^5��Ӧϵ��Ϊ1���޷�����
    error_number=3;
    end    
end

