
%%%%%%% QC-LDPC���� %%%%%%%
%��һģ�����ڽ��б��룬���뷽������������ģ����Ŀ��Բο�
function [W]=HuQC(H,p,J,L,s)
%QC-LDPC��ı������ʵ���Ͼ��Ǽ���n=k��G �Ĺ���,
%����n=Lp��k=(L-J)p��G�ֱ�������֡���Ϣλ����QC-LDPC��У�����H��Ӧ�����ɾ���,
%G�Ĵ�СΪ(L-J)p��Lp��
H;     %%% J��L����СΪp��p��ѭ��ת�ƾ��������
r=1-J/L;

%%%��һ�����Ƚ� H ���%%%
%%%%%%%%%%%%%%%
%%% H=[Q Z] %%%
%%%%%%%%%%%%%%%
% ���� Q
for a=1:(J*p)
    for b=1:(L-J)*p
        Q(a,b)=H(a,b);
    end
end
clear a; clear b;
% ���� Z
for a=1:(J*p)
    for b=((L-J)*p+1):(L*p)
        Z(a,b-(L-J)*p)=H(a,b);
    end
end
disp('�ֽ�H���γ�Q��Z')
%%%�ڶ������γ� G %%%
%%%%%%%%%%%%%%%
%%% G=[I W] %%%
%%%%%%%%%%%%%%%

% W=(Z^(-1) Q)^T

%���� Z ���������� Zni
clear guodu;
clear I1;
I1=eye(J*p); % T:Ts*Ts
guodu=[Z I1];
 
%��guodu����벿�ֻ��������Ǿ���
for i=1:((J*p)-1)
    if guodu(i,i)==0
        for a=(i+1):(J*p)
            if guodu(a,i)==1
                for b=1:(2*(J*p))
                    guodu(i,b)=guodu(i,b)+guodu(a,b);
                    guodu(i,b)=mod(guodu(i,b),2);
                end
                break;
            end
        end
    end
    %�ڵ�i����������һ������1��Ԫ�أ�����i�мӵ��Ǹ�Ԫ�����ڵ���һ��
    for a=(i+1):(J*p)
        if guodu(a,i)==1
            for b=1:(2*(J*p))
                guodu(a,b)=guodu(i,b)+guodu(a,b);
                guodu(a,b)=mod(guodu(a,b),2);
            end
        end
    end
end
%��guodu����벿�ֻ��ɵ�λ��
i=(J*p);
while i~=1
    a=i-1;
    while a~=0
        if guodu(a,i)==1
            for b=1:(2*(J*p))
                guodu(a,b)=guodu(a,b)+guodu(i,b);
                guodu(a,b)=mod(guodu(a,b),2);
            end
        end
        a=a-1;
    end
    i=i-1;
end
%��guodu���Ұ벿����Ϊ�������ȡ����
clear Zni;
for i=((J*p)+1):(2*(J*p))
    for a=1:(J*p)
        Zni(a,(i-(J*p)))=guodu(a,i);
    end
end
%Z���������������̵��˽���
%���������һ�����������Ĺ��̣�ϵͳ�����������ĺ�������������ʱ�䳤
%��˲�����ʹ��

clear WW;clear D;

%%% WW=(Z^(-1) Q)  W=WW^T  WW:Jp*(L-J)p

%�����м������WW=(Z^(-1) Q)  WW:Jp*(L-J)p
WW=Zni*Q;
for a=1:(J*p)
    for b=1:(L-J)*p
        D(a,b)=mod(WW(a,b),2);
    end
end
% ���� W 
W=D';
% aaaa=size(W)
%%%%%
% I=eye((L-J)*p);
% % �γ� G 
% G=[I W];
% disp('���ɾ��� G Ū����')
% %%%%%���б���,����Ϊ c %%%%%
% % s:(L-J)p
% clear cc;clear a;
% cc=s*G;  % c:1*Lp
% % ģ2֮���γ� c
% for a=1:(L*p)
%     c(a)=mod(cc(a),2);
% end
% c;
% disp('������ɣ��γ� c ��')




