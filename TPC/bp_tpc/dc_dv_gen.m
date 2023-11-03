function [dc,dv]=dc_dv_gen(v_H)


dc=sum(sum(v_H,2));
temp=sum(v_H,1);
dv=sum(temp(find(temp>1)));
