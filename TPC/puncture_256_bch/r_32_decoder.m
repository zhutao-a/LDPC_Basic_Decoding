function [decision_codeword,data_out,data_ram,n_code_out,n_code_ram]=r_32_decoder(data_ram,new_data,n_code_ram,n_code_back,alpha,gf_table,t,data_ram_max)
%ͬʱ����32������
%data_ramΪ�洢�����ݣ���С[(8*2+2*G)*16,128],G=2,new_dataΪ����������ݣ���С[32,128]
%alphaΪ��������Ϣʱ�Ĳ���
%decision_codewordΪ���������֣���СΪ[32,128]
%dada_outΪ��������ݣ���СΪ[32,128]
G=2;
W_R_r=zeros(32,256);%�洢32������
n_code=zeros(32,256);%�����ŵ���ʼ��Ϣ
decision_codeword=zeros(32,128);
%W_R_r��ǰ128�����ش�data_ram��ȡ
for R=0:1%R=0,r=0,k=0:127���൱��ofec˵���ĵ��еĺ�ɫ�߶Σ���������
    for r=0:15
        for k=0:127
            V_R=bitxor(R,1)+2*floor(k/16);  %�����
            V_C=floor(k/16);                %�����
            V_r=bitxor(mod(k,16),r);        %������
            V_c=r;                          %������
            W_R_r(R*16+r+1,k+1)=data_ram(V_R*16+V_r+1,(V_C)*16+V_c+1);
            n_code(R*16+r+1,k+1)=n_code_ram(V_R*16+V_r+1,(V_C)*16+V_c+1);%�����ŵ���ʼ��Ϣ
        end
    end
end
W_R_r(:,129:256)=new_data;%W_R_r�ĺ�128�����ش�new_data��ȡ��new_data����
n_code(:,129:256)=n_code_back;%�����ŵ���ʼ��Ϣ
for k=1:32%���룬������һ�ֵ�����Ϣ
    [codeword,w]=r_decoder(W_R_r(k,:),gf_table,t);
    decision_codeword(k,:)=codeword(129:256);%��128������Ϊ���
    W_R_r(k,:)=n_code(k,:)+fix(alpha*w);%��������Ϣ
    W_R_r(k,:)=max_constraint(W_R_r(k,:),data_ram_max);%���ƾ���ֵ��
end

%������õ�����Ϣ��front�ַŻذ����޾���
for R=0:1%R=0,r=0,k=0:127���൱��ofec˵���ĵ��еĺ�ɫ�߶Σ���������
    for r=0:15
        for k=0:127
            V_R=bitxor(R,1)+2*floor(k/16);  %�����
            V_C=floor(k/16);                %�����
            V_r=bitxor(mod(k,16),r);        %������
            V_c=r;                          %������
            data_ram(V_R*16+V_r+1,(V_C)*16+V_c+1)=W_R_r(R*16+r+1,k+1);
        end
    end
end

temp1=zeros(32,128);%�����Ҫ����ram���������ĺ�128����
n_temp1=zeros(32,128);%�����ŵ���ʼ��Ϣ
for R=0:1
    for r=0:15
        for k=0:127
            V_R=R;                          %�����
            V_C=floor(k/16);                %�����
            V_r=r;                          %������
            V_c=bitxor(mod(k+128,16),r);    %������
            temp1(R*16+r+1,k+1)=W_R_r(V_R*16+V_r+1,128+(V_C)*16+V_c+1);
            n_temp1(R*16+r+1,k+1)=n_code(V_R*16+V_r+1,128+(V_C)*16+V_c+1);
        end
    end
end

temp2=zeros(32,128);%ram��������Ĵ�����һ����������Ϣ
n_temp2=zeros(32,128);%�����ŵ���ʼ��Ϣ
for R=0:1
    for r=0:15
        for k=0:127
            V_R=R;                          %�����
            V_C=floor(k/16);                %�����
            V_r=r;                          %������
            V_c=bitxor(mod(k+128,16),r);    %������
            temp2(R*16+r+1,k+1)=data_ram(V_R*16+V_r+1,(V_C)*16+V_c+1);
            n_temp2(R*16+r+1,k+1)=n_code_ram(V_R*16+V_r+1,(V_C)*16+V_c+1);%�����ŵ���ʼ��Ϣ
        end
    end
end


%�����ƶ�32�в����µ���Ϣtemp����data_ram,ԭ���������32�и�data_out
data_out=temp2;
data_ram=circshift(data_ram,-32);%ѭ�������ƶ�32λ
data_ram((7*2+2*G)*16+1:(8*2+2*G)*16,:)=temp1;

n_code_out=n_temp2;%�����ŵ���ʼ��Ϣ
n_code_ram=circshift(n_code_ram,-32);%�����ŵ���ʼ��Ϣ
n_code_ram((7*2+2*G)*16+1:(8*2+2*G)*16,:)=n_temp1;%�����ŵ���ʼ��Ϣ

