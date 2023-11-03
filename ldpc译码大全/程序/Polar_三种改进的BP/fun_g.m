function L_R= fun_g( x1,x2)



L_R=2*atanh(tanh(x1/2)*tanh(x2/2));
%L_R=0.9*sign(x1)*sign(x2)*min(abs(x1),abs(x2));


end