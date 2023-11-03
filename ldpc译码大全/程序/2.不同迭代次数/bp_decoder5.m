function [vhat5]=bp_decoder5(re_waveform,H,rate,EbNo)

dim=size(H);
rows=dim(1);
cols=dim(2);
%rate=(cols-rows)/cols;
vhat5(1,1:cols)=0;
zero(1,1:rows)=0;
s=struct('qmn0',0,'qmn1',0,'dqmn',0,'rmn0',0,'rmn1',0,'qn0',0,'qn1',0,'alphamn',1);
%associate this structure with all non zero elements of H
%fa=1./��1+exp��-2ayi/sigma^2��)
%��˹�ŵ�:sigma^2=1/2*rate*EbN0

pl1=1./(1+exp(4*rate*EbNo.*re_waveform));
pl0=1-pl1;

%��ʼ�������ض����ŵ�Ԥ����Ϣ���ص�������ʡ�
newh(1:rows, 1:cols)=s;

[h1i h1j]=find(H==1);
h1num=length(h1i);% the No. of 1s in H
for i=1:h1num
    newh(h1i(i),h1j(i)).qmn0=pl0(h1j(i));
    newh(h1i(i),h1j(i)).qmn1=pl1(h1j(i));
end

%��������50
for iteration=1:5
    %�����裺����Ϣ�ڵ��������ʰ����Ŵ����㷨�ó���У��ڵ�ĺ�����ʡ�
    for i=1:h1num %������ʲ�
        newh(h1i(i),h1j(i)).dqmn=newh(h1i(i),h1j(i)).qmn0-newh(h1i(i),h1j(i)).qmn1;
    end

    for i=1:rows
        colind=find(h1i==i);%�ҵ���ÿ����1����Ӧ���е�λ��
        colnum=length(colind); %ÿ��1�ĸ���
        for j=1:colnum
            drmn=1;
            for k=1:colnum
                if k~=j
                    drmn=drmn*newh(i,h1j(colind(k))).dqmn;
                end
            end
            newh(i,h1j(colind(j))).rmn0=(1+drmn)/2;
            newh(i,h1j(colind(j))).rmn1=(1-drmn)/2;
        end
    end

    %�����裺��У��ڵ�ĺ�������������Ϣ�ڵ�ĺ�����ʡ�
    for j=1:cols
        rowind=find(h1j==j);%�ҵ�ÿһ��1����Ӧ�е�λ��
        rownum=length(rowind);
        for i=1:rownum
            prod_rmn0=1;
            prod_rmn1=1;
            for k=1:rownum
                if k~=i
                    prod_rmn0=prod_rmn0*newh(h1i(rowind(k)),j).rmn0;
                    prod_rmn1=prod_rmn1*newh(h1i(rowind(k)),j).rmn1;
                end
            end
            const1=pl0(j)*prod_rmn0;
            const2=pl1(j)*prod_rmn1;
            newh(h1i(rowind(i)),j).alphamn=1/( const1 + const2 ) ;
            newh(h1i(rowind(i)),j).qmn0=newh(h1i(rowind(i)),j).alphamn*const1;
            newh(h1i(rowind(i)),j).qmn1=newh(h1i(rowind(i)),j).alphamn*const2;
            %update pseudo posterior probability
            %����α�������
            const3=const1*newh(h1i(rowind(i)),j).rmn0;
            const4=const2*newh(h1i(rowind(i)),j).rmn1;
            alpha_n=1/(const3+const4);
            newh(h1i(rowind(i)),j).qn0=alpha_n*const3;
            newh(h1i(rowind(i)),j).qn1=alpha_n*const4;
            %tentative decoding
            %���볢�ԣ�����Ϣ�ڵ�ĺ��������Ӳ�о�
            if newh(h1i(rowind(i)),j).qn1>0.5
                vhat5(j)=1;
            else
                vhat5(j)=0;
            end
        end
    end

    if mul_GF2(vhat5,H')==zero
    %����о��������㣬��������������������
        break;
    end
end

