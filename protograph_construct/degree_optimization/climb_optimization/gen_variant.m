function [v_deg_per_col,v_deg_per_row]=gen_variant(p_deg_per_col,p_deg_per_row,F)%产生变异种群
[NP,~]=size(p_deg_per_col);
v_deg_per_col=zeros(size(p_deg_per_col));
v_deg_per_row=zeros(size(p_deg_per_row));
for i=1:NP
    r1=randi(NP);
    r2=randi(NP);
    while(r2==r1)%确保两者不相等
        r2=randi(NP);
    end
    r3=randi(NP);
    while((r3==r1)||(r3==r2))
        r3=randi(NP);
    end
    v_deg_per_col(i,:)=p_deg_per_col(r1,:)+round(F*(p_deg_per_col(r2,:)-p_deg_per_col(r3,:)));
    v_deg_per_row(i,:)=p_deg_per_row(r1,:)+round(F*(p_deg_per_row(r2,:)-p_deg_per_row(r3,:)));
end





