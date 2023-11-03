function [decision_codeword,data_out,data_ram]=first_stage_decoder(data_ram,new_data,alpha,gf_table,t)%ͬʱ����32������
%data_ramΪ�洢�����ݣ���С[(8*2+2*G)*16,128],G=2,new_dataΪ����������ݣ���С[32,128]
%alphaΪ��������Ϣʱ�Ĳ���
%decision_codewordΪ���������֣���СΪ[32,128]
%dada_outΪ������һ�������ݣ���СΪ[32,128]
G=2;
data_ram_max=15;%����ram�������ֵ�����ֵ
W_R_r=zeros(32,256);%�洢32������
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
        end
    end
end
W_R_r(:,129:256)=new_data;%W_R_r�ĺ�128�����ش�new_data��ȡ
for k=1:32%���룬������һ�ֵ�����Ϣ
    [codeword,w]=r_decoder(W_R_r(k,:),gf_table,t);
    decision_codeword(k,:)=codeword(129:256);%��128������Ϊ���
    W_R_r(k,:)=fix(W_R_r(k,:)+alpha*w);%��������Ϣ
    for i=1:256
        if(W_R_r(k,i)>data_ram_max)
            W_R_r(k,i)=data_ram_max;
        elseif(W_R_r(k,i)<-data_ram_max)
            W_R_r(k,i)=-data_ram_max;
        end
    end
end

data_out=W_R_r(:,1:128);%б�ŵ�ǰ128�������

temp=zeros(32,128);%����128������������ram��
for R=0:1
    for r=0:15
        for k=0:127
            V_R=R;                          %�����
            V_C=floor(k/16);                %�����
            V_r=r;                          %������
            V_c=bitxor(mod(k+128,16),r);    %������
            temp(R*16+r+1,k+1)=W_R_r(V_R*16+V_r+1,128+(V_C)*16+V_c+1);
        end
    end
end

%�����ƶ�32�в����µ���ϢW_R_r(:,129:256)����data_ram,ԭ���������32�и�data_out
data_ram=circshift(data_ram,-32);%ѭ�������ƶ�32λ
data_ram((7*2+2*G)*16+1:(8*2+2*G)*16,:)=temp;
