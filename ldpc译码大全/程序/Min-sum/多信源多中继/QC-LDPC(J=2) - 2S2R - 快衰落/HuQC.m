
%%%%%%% QC-LDPC编码 %%%%%%%
%这一模块是在进行编码，编码方法根据相关论文，论文可以参考
function [W]=HuQC(H,p,J,L,s)
%QC-LDPC码的编码过程实质上就是计算n=k×G 的过程,
%其中n=Lp、k=(L-J)p和G分别代表码字、信息位和与QC-LDPC码校验矩阵H相应的生成矩阵,
%G的大小为(L-J)p×Lp。
H;     %%% J×L个大小为p×p的循环转移矩阵而构成
r=1-J/L;

%%%第一步，先将 H 拆分%%%
%%%%%%%%%%%%%%%
%%% H=[Q Z] %%%
%%%%%%%%%%%%%%%
% 产生 Q
for a=1:(J*p)
    for b=1:(L-J)*p
        Q(a,b)=H(a,b);
    end
end
clear a; clear b;
% 产生 Z
for a=1:(J*p)
    for b=((L-J)*p+1):(L*p)
        Z(a,b-(L-J)*p)=H(a,b);
    end
end
disp('分解H，形成Q、Z')
%%%第二步，形成 G %%%
%%%%%%%%%%%%%%%
%%% G=[I W] %%%
%%%%%%%%%%%%%%%

% W=(Z^(-1) Q)^T

%计算 Z 矩阵的逆矩阵 Zni
clear guodu;
clear I1;
I1=eye(J*p); % T:Ts*Ts
guodu=[Z I1];
 
%将guodu的左半部分化成下三角矩阵
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
    %在第i列中向下找一个等于1的元素，将第i行加到那个元素所在的那一行
    for a=(i+1):(J*p)
        if guodu(a,i)==1
            for b=1:(2*(J*p))
                guodu(a,b)=guodu(i,b)+guodu(a,b);
                guodu(a,b)=mod(guodu(a,b),2);
            end
        end
    end
end
%将guodu的左半部分化成单位阵
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
%将guodu的右半部分作为最后结果提取出来
clear Zni;
for i=((J*p)+1):(2*(J*p))
    for a=1:(J*p)
        Zni(a,(i-(J*p)))=guodu(a,i);
    end
end
%Z矩阵的逆矩阵求解过程到此结束
%以上是求解一个矩阵逆矩阵的过程，系统里有求逆矩阵的函数，但是误差大，时间长
%因此不建议使用

clear WW;clear D;

%%% WW=(Z^(-1) Q)  W=WW^T  WW:Jp*(L-J)p

%计算中间变量：WW=(Z^(-1) Q)  WW:Jp*(L-J)p
WW=Zni*Q;
for a=1:(J*p)
    for b=1:(L-J)*p
        D(a,b)=mod(WW(a,b),2);
    end
end
% 计算 W 
W=D';
% aaaa=size(W)
%%%%%
% I=eye((L-J)*p);
% % 形成 G 
% G=[I W];
% disp('生成矩阵 G 弄好了')
% %%%%%进行编码,码字为 c %%%%%
% % s:(L-J)p
% clear cc;clear a;
% cc=s*G;  % c:1*Lp
% % 模2之后，形成 c
% for a=1:(L*p)
%     c(a)=mod(cc(a),2);
% end
% c;
% disp('编码完成，形成 c 啦')




