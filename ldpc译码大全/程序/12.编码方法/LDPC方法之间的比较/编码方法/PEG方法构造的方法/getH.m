%%clear all;
%%clc;
%%%����������,m:У��ڵ���Ŀ��n:�����ڵ���Ŀ(ע������R��һ��Ϊ1/2)
%%%�����������ʵ�LDPCУ�����
m=input('The number of check nodes:');
n=input('The number of variable nodes:');
%function H=getH(m,n)
h=zeros(m,n);
%���������ڵ�ȷֲ����� dv=0.38354*x+0.04237*x^2+0.57409*x^3
%Ϊ�˵õ����õ����ܣ��˴��Ķȷֲ����в����ܶȽ�������ѡȡ
dv=inline('0.38354*x+0.04237*x.^2+0.57409*x.^3','x');
%����ÿ���ȷֲ��Ľڵ���
indv=quadl(dv,0,1);
a2=round(n*(0.38354/2/indv));
a3=round(n*(0.04273/3/indv));
ds(1:a2)=2;
ds(a2+1:a3+a2)=3;
ds(a2+a3+1:n)=4;
%���ﲻ����У��ڵ�Ķȷֲ����У�������Tannerͼʱ����Ϊ0
dc=zeros(1,m);
%����չ��PEG�㷨����ÿһ�������ڵ�չ��l����ͼ������Tannerͼ
for j=1:n            %����ÿһ�������ڵ�ѭ��
    for k=1:ds(j)    %���ڶȷֲ�ѭ�������Ʊߵ���Ŀ
        if k==1
            %��Ϊ��һ���ߣ�ֱ��Ѱ����С�ȷֲ���У��ڵ�
            k1=find(dc==min(dc));
            h(k1(1),j)=1;
            dc(k1(1))=dc(k1(1))+1;
        else %�����ǵ�һ���ߣ���չ��l����ͼ��Ѱ����l����С�ȷֲ���У��ڵ�
            flag=1;
            l=1;
            %�����ÿһ��У��ڵ��Ƿ�����ڵ�l�������,���չ����������
            dcf=zeros(1000,m);
            row=find(h(:,j));   %������������Ϊ1���б�
            dcf(l,row)=1;       %չ����һ��
            while(flag)
                l=l+1;
                h_row=h(row,:);
                if  length(row)==1
                    col=find(h_row);
                else
                    col=find(any(h_row(:,1:n)));    %��������Ѱ��Ϊ1���б�
                end
                h_col=(h(:,col))';
                if length(col)==1
                    row1=find(h_col);        
                else
                    row1=find(any(h_col(:,1:m)));
                end
                row=row1;
                dcf(l,row)=1; 
                if l>=2 
                    %ֹͣչ����һ������������Ԫ��ֹͣ����
                   if dcf(l,:)==dcf(l-1,:)
                      nc_all=find(dcf(l,:)==0);
                      ndc=dc(nc_all);
                      nc=find(ndc==min(ndc));
                      h(nc_all(nc(1)),j)=1;
                      dc(nc_all(nc(1)))=dc(nc_all(nc(1)))+1;
                       break;
                    %ֹͣչ���ڶ������������Ԫ�ر���
                   elseif (sum(dcf(l-1,:))<m) && (sum(dcf(l,:))==m)
                      nc1_all=find((dcf(l-1,:)&dcf(l,:))==0);
                      ndc1=dc(nc1_all);
                      nc1=find(ndc1==min(ndc1));
                      h(nc1_all(nc1(1)),j)=1;
                      dc(nc1_all(nc1(1)))=dc(nc1_all(nc1(1)))+1;
                      break;
                   end
              end
          end
       end 
    end
end
H=h;

 