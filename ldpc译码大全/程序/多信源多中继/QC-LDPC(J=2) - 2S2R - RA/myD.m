function d = myD(x)

v1 = ones(1,x);
v2 = ones(1,x-1);
d1 = diag(v1);
d2 = diag(v2,-1);
d = d1+d2;

