%计算p1=(-Fget)*((-E)*Tget*A+C)*s'
clear med;
p=E*Tget;                        %计算E*Tget
for i=1:g
    for a=1:(m-g)
        med(i,a)=mod(p(i,a),2);
    end
end
t=med*A;                         %计算E*Tget*A
clear mid;
for i=1:g
    for a=1:(n-m)
        mid(i,a)=mod(t(i,a),2);
    end
end
clear Q;
Q=mid+C;
clear mid;
for i=1:g                        %计算E*Tget*A+C
    for a=1:(n-m)
        mid(i,a)=mod(Q(i,a),2);
    end
end
clear med;
r=Fget*mid;
for i=1:g
    for a=1:(n-m)
        med(i,a)=mod(r(i,a),2);
    end
end
p1=med*s';
clear med;
clear mid;
for i=1:length(p1)
    p1(i)=mod(p1(i),2);
end

p3=p1';
%计算p2=-Tget*(A*s'+B*p1')
clear med;
clear mid;
med=A*s';                         %计算A*s'
for i=1:(m-g)
    mid(i,1)=mod(med(i,1),2);
end
clear med;
clear r;
r=B*p1;                           %计算B*p1
for i=1:(m-g)
    med(i,1)=mod(r(i,1),2);
end
clear Q;
Q=mid+med;
for i=1:(m-g)
    med(i,1)=mod(Q(i,1),2);
end
p2=Tget*med;
for i=1:length(p2)
    p2(i)=mod(p2(i),2);
end
p4=p2';
clear p2;
p2=p4;
xyuan=[s p3 p4];