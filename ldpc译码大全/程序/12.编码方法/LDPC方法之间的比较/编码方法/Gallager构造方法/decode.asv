clear x;
x=demodz;

clear prob0;
clear prob1;
prob0=zeros(1,lieH);
prob1=zeros(1,lieH);

for a=1:lieH
    prob1(1,a)=1/(1+exp(x(1,a)*2/sigma^2));
    prob0(1,a)=1-prob1(1,a);
end

q0=zeros(hangH,lieH);
q1=zeros(hangH,lieH);
r0=zeros(hangH,lieH);
r1=zeros(hangH,lieH);

for i=1:lieH
    for jo=1:liezhong
        q0(ncol(jo,i),i)=prob0(1,i);
        q1(ncol(jo,i),i)=prob1(1,i);
    end
end




for lp=1:20
    for i=1:hangH
        for jo=1:hangzhong
            delta=1;
            for l=1:hangzhong
                if l~=jo
                    delta=delta*(1-2*q1(i,nrow(i,l)));
                end
            end
            r0(i,nrow(i,jo))=0.5+0.5*delta;
            r1(i,nrow(i,jo))=1-r0(i,nrow(i,jo));
        end
    end

    for i=1:lieH
        for jo=1:liezhong
            alpha1=1;
            alpha2=1;
            alpha3=1;
            alpha4=1;
            for l=1:liezhong
                if l~=jo
                    alpha1=alpha1*r0(ncol(l,i),i);
                    alpha2=alpha2*r1(ncol(l,i),i);
                end
            end
            %---------------------------------------------------
            if (prob0(1,i)*alpha1+prob1(1,i)*alpha2)==0
                alpha3=1;
            else alpha3=1/(prob0(1,i)*alpha1+prob1(1,i)*alpha2);
            end
            %----------------------------------------------------
            q0(ncol(jo,i),i)=alpha3*prob0(1,i)*alpha1;
            q1(ncol(jo,i),i)=alpha3*prob1(1,i)*alpha2;
        end
    end

    
    Q0=zeros(1,lieH);
    Q1=zeros(1,lieH);
    for i=1:lieH
        delta1=1;
        delta2=1;
        for jo=1:3
            delta1=delta1*r0(ncol(jo,i),i);
            delta2=delta2*r1(ncol(jo,i),i);
        end
        if (prob0(1,i)*delta1+prob1(1,i)*delta2)==0
            delta3=1;
        else delta3=1/(prob0(1,i)*delta1+prob1(1,i)*delta2);
        end
        Q0(1,i)=delta3*prob0(1,i)*delta1;
    end
    
    decoded=zeros(1,lieH);
    for i=1:lieH
        if Q0(1,i)<0.5
            decoded(1,i)=1;
        end
    end
    
    clear check;
    check=H*decoded';
    biaozhi=0;
    
    for i=1:hangH
        if mod(check(i,1),2)==1
            biaozhi=1;
            break;
        end
    end
    
    if biaozhi==0
        break;
    end
end

