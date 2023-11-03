function z=hanshu1(x,y)
%w=2*atanh(tanh(x/2)*tanh(y/2));
%w=log(cosh((x+y)/2))-log(cosh((x-y)/2));
w=sign(x)*sign(y)*min(abs(x),abs(y));
%w=(1+x*y)/(x+y);
z=w;
end

