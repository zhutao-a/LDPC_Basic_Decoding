function v=encode(N,G,tmp)

v = mod(tmp*G, 2);
i=1:N;
i=(i-1).';
w=dec2bin(i);
w=fliplr(w);
i=bin2dec(w)+1;
m=i.';
for n=1:N
    Enc_output(n)=v(m(n));
end