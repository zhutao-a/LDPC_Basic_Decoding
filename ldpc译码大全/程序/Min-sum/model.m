dataname='10000PE-RetentionErr.xlsx';
cMSB=xlsread(dataname,'A2:A32769');
yMSB=xlsread(dataname,'B2:B32769');
cLSB=xlsread(dataname,'C2:C32769');
yLSB=xlsread(dataname,'D2:D32769');
c_combine=[cMSB,cLSB];
y_combine=[yMSB,yLSB];
cal=0;
for n=1:32768
    if c_combine(n,:)==[0 1]
        if y_combine(n,:)==[0,0]
            cal=cal+1;
        end
    elseif c_combine(n,:)==[0 0]
        if y_combine(n,:)==[1,0]
            cal=cal+1;
        end
    elseif c_combine(n,:)==[1 0]
        if y_combine(n,:)==[1,1]
            cal=cal+1;
        end
    end
    
end
cal
calup=0;
for n=1:32768
    if c_combine(n,:)==[1 1]
        if y_combine(n,:)==[1,0]
            calup=calup+1;
        end
    elseif c_combine(n,:)==[1 0]
        if y_combine(n,:)==[0,0]
            calup=calup+1;
        end
    elseif c_combine(n,:)==[0 0]
        if y_combine(n,:)==[0,1]
            calup=calup+1;
        end
    end
    
end
calup