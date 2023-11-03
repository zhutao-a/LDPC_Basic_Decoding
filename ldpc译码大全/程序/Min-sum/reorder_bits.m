function [u]= reorder_bits(c,rearranged_cols)
%v= reorder_bits(c,rearranged_cols)

rows=length(rearranged_cols);%rarranged_colsÎª1ĞĞrowsÁĞÁã¾ØÕó
for i=rows:-1:1
   if rearranged_cols(i)~=0
      temp=c(i);
      c(i)=c(rearranged_cols(i));
      c(rearranged_cols(i))=temp;
   end
end

u=c;
