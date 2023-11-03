%��һ��BP�㷨
function [v]=BP1(y,H,sigma_2,maxiter)
% H=[1 1 1 0 0 0 0 0;0 0 0 1 1 1 0 0;1 0 0 1 0 0 1 0;0 1 0 0 1 0 0 1];
% y=[0.2 0.2 -0.9 0.6 0.5 -1.1 -0.4 -1.2];
% sigma_2=0.5;
% maxiter=50;
[m,n]=size(H);
success=0;k=0;                           
Lc=2*y/sigma_2;                                        %��ʼ����Ϣ�ڵ����ϢLc.
Lg=repmat(Lc,m,1);                                     %��ʼ������Lg(i,j)
Lg=Lg.*H;
[hj,hi]=find(H==1);
while((success==0)&(k<maxiter))                        %c*h'~=0��k(��������)δ�ﵽ����������maxiter,�������е�������.
    for j=1:m                                          %����У��ڵ�����Ϣ�ڵ㴫�ݵ���ϢLh��j,i)
    for i=1:n
        if H(j,i)==1
            A=1; t=0;
            for ii=1:n
                if (ii~=i)&(H(j,ii)==1)
                    A=A*sign(Lg(j,ii)); b(j,ii)=abs(Lg(j,ii));t=t+1;
                    if t==1
                        B0=b(j,ii);
                    else B=b(j,ii);
                        if B0>B
                            B0=B;
                        end
                    end
                 end
            end
            x=1.25;Lh(j,i)=A*B0/1.25;
        end
    end
end
for i=1:n                                            %������Ϣ�ڵ���У��ڵ㴫�ݵ���Ϣ Lg(i,j)
      rowind=find(hi==i);
      temp=Lh(hj(rowind),i);
      Q=sum(temp);
      Q1=Q-temp;
      Lg(hj(rowind),i)=Lc(i)+Q1;
      LQ=Lc(i)+Q;                                   %���о�
      if LQ<0                                       %Ӳ�о�
       v(i)=1;
      else v(i)=0;
      end
end
  k= k+1;
  if mod(v*H',2)==0                                  %�о������Ƿ�ɹ�,���ɹ�(success=1),���˳�ѭ������,�������.
     success=1;
  else  success=0;
  end
end