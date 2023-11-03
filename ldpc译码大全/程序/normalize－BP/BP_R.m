function[R]=BP_R(Lq)
for j=1:length(Lq(:,1))
for i=1:length(Lq(1,:))                                            %È·¶¨·ûºÅ
  if Lq(j,i)<=0                        
       sgn(j,i)=-1;
   else
       sgn(j,i)=1;
   end;       
end;
end;


R(1,1)=-sgn(1,3)*sgn(1,8)*sgn(1,9)*phi(phi(Lq(1,3))+phi(Lq(1,8))+phi(Lq(1,9)));
R(3,1)=-sgn(3,4)*sgn(3,5)*sgn(3,11)*phi(phi(Lq(3,4))+phi(Lq(3,5))+phi(Lq(3,11)));
R(6,1)=-sgn(6,12)*sgn(6,13)*sgn(6,14)*phi(phi(Lq(6,12))+phi(Lq(6,13))+phi(Lq(6,14)));

R(4,2)=-sgn(4,8)*sgn(4,11)*sgn(4,12)*phi(phi(Lq(4,8))+phi(Lq(4,11))+phi(Lq(4,12)));
R(4,2)=-sgn(4,3)*sgn(4,7)*sgn(4,13)*phi(phi(Lq(4,3))+phi(Lq(4,7))+phi(Lq(4,13)));
R(11,2)=-sgn(11,6)*sgn(11,18)*sgn(11,19)*phi(phi(Lq(11,6))+phi(Lq(11,18))+phi(Lq(11,19)));

R(1,3)=-sgn(1,1)*sgn(1,8)*sgn(1,9)*phi(phi(Lq(1,1))+phi(Lq(1,8))+phi(Lq(1,9)));
R(5,3)=-sgn(5,2)*sgn(5,7)*sgn(5,13)*phi(phi(Lq(5,2))+phi(Lq(5,7))+phi(Lq(5,13)));
R(8,3)=-sgn(8,4)*sgn(8,10)*sgn(8,16)*phi(phi(Lq(8,4))+phi(Lq(8,10))+phi(Lq(8,16)));

R(3,4)=-sgn(3,1)*sgn(3,5)*sgn(3,11)*phi(phi(Lq(3,1))+phi(Lq(3,5))+phi(Lq(3,11)));
R(8,4)=-sgn(8,3)*sgn(8,10)*sgn(8,16)*phi(phi(Lq(8,3))+phi(Lq(8,10))+phi(Lq(8,16)));
R(13,4)=-sgn(13,8)*sgn(13,19)*sgn(13,20)*phi(phi(Lq(13,8))+phi(Lq(13,19))+phi(Lq(13,20)));

R(2,5)=-sgn(2,6)*sgn(2,7)*sgn(2,10)*phi(phi(Lq(2,6))+phi(Lq(2,7))+phi(Lq(2,10)));
R(3,5)=-sgn(3,1)*sgn(3,4)*sgn(3,11)*phi(phi(Lq(3,1))+phi(Lq(3,4))+phi(Lq(3,11)));
R(15,5)=-sgn(15,9)*sgn(15,17)*sgn(15,19)*phi(phi(Lq(15,9))+phi(Lq(15,17))+phi(Lq(15,19)));

R(2,6)=-sgn(2,5)*sgn(2,7)*sgn(2,10)*phi(phi(Lq(2,5))+phi(Lq(2,7))+phi(Lq(2,10)));
R(11,6)=-sgn(11,2)*sgn(11,18)*sgn(11,19)*phi(phi(Lq(11,2))+phi(Lq(11,18))+phi(Lq(11,19)));
R(12,6)=-sgn(12,15)*sgn(12,17)*sgn(12,20)*phi(phi(Lq(12,15))+phi(Lq(12,17))+phi(Lq(12,20)));

R(2,7)=-sgn(2,5)*sgn(2,6)*sgn(2,10)*phi(phi(Lq(2,5))+phi(Lq(2,6))+phi(Lq(2,10)));
R(5,7)=-sgn(5,2)*sgn(5,3)*sgn(5,13)*phi(phi(Lq(5,2))+phi(Lq(5,3))+phi(Lq(5,13)));
R(9,7)=-sgn(9,14)*sgn(9,16)*sgn(9,17)*phi(phi(Lq(9,14))+phi(Lq(9,16))+phi(Lq(9,17)));

R(1,8)=-sgn(1,1)*sgn(1,3)*sgn(1,9)*phi(phi(Lq(1,1))+phi(Lq(1,3))+phi(Lq(1,9)));
R(4,8)=-sgn(4,2)*sgn(4,11)*sgn(4,12)*phi(phi(Lq(4,2))+phi(Lq(4,11))+phi(Lq(4,12)));
R(13,8)=-sgn(13,4)*sgn(13,19)*sgn(13,20)*phi(phi(Lq(13,4))+phi(Lq(13,19))+phi(Lq(13,20)));%%

R(1,9)=-sgn(1,1)*sgn(1,3)*sgn(1,8)*phi(phi(Lq(1,1))+phi(Lq(1,3))+phi(Lq(1,8)));
R(7,9)=-sgn(7,10)*sgn(7,12)*sgn(7,15)*phi(phi(Lq(7,10))+phi(Lq(7,12))+phi(Lq(7,15)));
R(15,9)=-sgn(15,5)*sgn(15,17)*sgn(15,19)*phi(phi(Lq(15,5))+phi(Lq(15,17))+phi(Lq(15,19)));

R(2,10)=-sgn(2,5)*sgn(2,6)*sgn(2,7)*phi(phi(Lq(2,5))+phi(Lq(2,6))+phi(Lq(2,7)));
R(7,10)=-sgn(7,9)*sgn(7,12)*sgn(7,15)*phi(phi(Lq(7,9))+phi(Lq(7,12))+phi(Lq(7,15)));
R(8,10)=-sgn(8,3)*sgn(8,4)*sgn(8,16)*phi(phi(Lq(8,3))+phi(Lq(8,4))+phi(Lq(8,16)));

R(3,11)=-sgn(3,1)*sgn(3,4)*sgn(3,5)*phi(phi(Lq(3,1))+phi(Lq(3,4))+phi(Lq(3,5)));
R(4,11)=-sgn(4,2)*sgn(4,8)*sgn(4,12)*phi(phi(Lq(4,2))+phi(Lq(4,8))+phi(Lq(4,12)));
R(10,11)=-sgn(10,14)*sgn(10,15)*sgn(10,18)*phi(phi(Lq(10,14))+phi(Lq(10,15))+phi(Lq(10,18)));

R(4,12)=-sgn(4,2)*sgn(4,8)*sgn(4,11)*phi(phi(Lq(4,2))+phi(Lq(4,8))+phi(Lq(4,11)));
R(6,12)=-sgn(6,1)*sgn(6,13)*sgn(6,14)*phi(phi(Lq(6,1))+phi(Lq(6,13))+phi(Lq(6,14)));
R(7,12)=-sgn(7,9)*sgn(7,10)*sgn(7,15)*phi(phi(Lq(7,9))+phi(Lq(7,10))+phi(Lq(7,15)));

R(5,13)=-sgn(5,2)*sgn(5,3)*sgn(5,7)*phi(phi(Lq(5,2))+phi(Lq(5,3))+phi(Lq(5,7)));
R(6,13)=-sgn(6,1)*sgn(6,12)*sgn(6,14)*phi(phi(Lq(6,1))+phi(Lq(6,12))+phi(Lq(6,14)));
R(14,13)=-sgn(14,16)*sgn(14,18)*sgn(14,20)*phi(phi(Lq(14,16))+phi(Lq(14,18))+phi(Lq(14,20)));

R(6,14)=-sgn(6,1)*sgn(6,12)*sgn(6,13)*phi(phi(Lq(6,1))+phi(Lq(6,12))+phi(Lq(6,13)));
R(9,14)=-sgn(9,7)*sgn(9,16)*sgn(9,17)*phi(phi(Lq(9,7))+phi(Lq(9,16))+phi(Lq(9,17)));
R(10,14)=-sgn(10,11)*sgn(10,15)*sgn(10,18)*phi(phi(Lq(10,11))+phi(Lq(10,15))+phi(Lq(10,18)));

R(7,15)=-sgn(7,9)*sgn(7,10)*sgn(7,12)*phi(phi(Lq(7,9))+phi(Lq(7,10))+phi(Lq(7,12)));
R(10,15)=-sgn(10,11)*sgn(10,14)*sgn(10,18)*phi(phi(Lq(10,11))+phi(Lq(10,14))+phi(Lq(10,18)));
R(12,15)=-sgn(12,6)*sgn(12,17)*sgn(12,20)*phi(phi(Lq(12,6))+phi(Lq(12,17))+phi(Lq(12,20)));

R(8,16)=-sgn(8,3)*sgn(8,4)*sgn(8,10)*phi(phi(Lq(8,3))+phi(Lq(8,4))+phi(Lq(8,10)));
R(9,16)=-sgn(9,7)*sgn(9,14)*sgn(9,17)*phi(phi(Lq(9,7))+phi(Lq(9,14))+phi(Lq(9,17)));
R(14,16)=-sgn(14,13)*sgn(14,18)*sgn(14,20)*phi(phi(Lq(14,13))+phi(Lq(14,18))+phi(Lq(14,20)));

R(9,17)=-sgn(9,7)*sgn(9,14)*sgn(9,16)*phi(phi(Lq(9,7))+phi(Lq(9,14))+phi(Lq(9,16)));
R(12,17)=-sgn(12,6)*sgn(12,15)*sgn(12,20)*phi(phi(Lq(12,6))+phi(Lq(12,15))+phi(Lq(12,20)));
R(15,17)=-sgn(15,5)*sgn(15,9)*sgn(15,19)*phi(phi(Lq(15,5))+phi(Lq(15,9))+phi(Lq(15,19)));

R(10,18)=-sgn(10,11)*sgn(10,14)*sgn(10,15)*phi(phi(Lq(10,11))+phi(Lq(10,14))+phi(Lq(10,15)));
R(11,18)=-sgn(11,2)*sgn(11,6)*sgn(11,19)*phi(phi(Lq(11,2))+phi(Lq(11,6))+phi(Lq(11,19)));
R(14,18)=-sgn(14,13)*sgn(14,16)*sgn(14,20)*phi(phi(Lq(14,13))+phi(Lq(14,16))+phi(Lq(14,20)));

R(11,19)=-sgn(11,2)*sgn(11,6)*sgn(11,18)*phi(phi(Lq(11,2))+phi(Lq(11,6))+phi(Lq(11,18)));
R(13,19)=-sgn(13,4)*sgn(13,8)*sgn(13,20)*phi(phi(Lq(13,4))+phi(Lq(13,8))+phi(Lq(13,20)));
R(15,19)=-sgn(15,5)*sgn(15,9)*sgn(15,17)*phi(phi(Lq(15,5))+phi(Lq(15,9))+phi(Lq(15,17)));

R(12,20)=-sgn(12,6)*sgn(12,15)*sgn(12,17)*phi(phi(Lq(12,6))+phi(Lq(12,15))+phi(Lq(12,17)));
R(13,20)=-sgn(13,4)*sgn(13,8)*sgn(13,19)*phi(phi(Lq(13,4))+phi(Lq(13,8))+phi(Lq(13,19)));
R(14,20)=-sgn(14,13)*sgn(14,16)*sgn(14,18)*phi(phi(Lq(14,13))+phi(Lq(14,16))+phi(Lq(14,18)));