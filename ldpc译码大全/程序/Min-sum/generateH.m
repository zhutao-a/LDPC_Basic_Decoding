%n=2286
%k=1905
%381*2286
function H=generateH()
P=[31 45 25 125 119 77 21 27 103 119 87 55 20 80 20 1 0 -1;
12 10 50 126 107 27 12 40 73 111 47 113 32 33 38 0 0 0;
4 20 100 119 87 54 16 80 19 95 94 104 64 66 76 1 -1 0];

L=127;c=3;t=15;
I=[eye(L) eye(L)];
for ii=1:c
    for jj=1:c+t
        if P(ii,jj) == 0
            H((ii-1)*L+1:ii*L,(jj-1)*L+1:jj*L)=eye(L);
        elseif P(ii,jj)== -1
            
        else
            H((ii-1)*L+1:ii*L,(jj-1)*L+1:jj*L)=I(:,L-P(ii,jj)+1:2*L-P(ii,jj));
        end
    end
end