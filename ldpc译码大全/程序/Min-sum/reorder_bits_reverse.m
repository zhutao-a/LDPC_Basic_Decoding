function [u]= reorder_bits_reverse(c,rearranged_cols)
%v= reorder_bits(c,rearranged_cols)

rows=length(rearranged_cols);%rarranged_colsÎª1ĞĞrowsÁĞÁã¾ØÕó
for i=1:rows
   if rearranged_cols(i)~=0
      temp=c(i);
      c(i)=c(rearranged_cols(i));
      c(rearranged_cols(i))=temp;
   end
end

u=c;