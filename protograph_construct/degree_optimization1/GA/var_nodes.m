function [var]=var_nodes(first,last,number) %���ݲ�ͬ����������number����ͬ�ȵ�������
var=[]; 
%����224������Ϊ6��var
if number==6 
    tp(1)=first; 
    tp(2)=first+1; 
    for k=first+2:last/2-1 
       tp(3) =k; 
       for q=k+1:last/2 
          tp(4)=q;  
          for tt=q+1:last-1 
          tp(5)=tt; tp(6)=last; 
          var=[var;tp]; 
          end 
       end 
    end 
end 
%����84������Ϊ5��var
if number==5 
    tp(1)=first;     
    tp(2)=first+1; 
    for k=first+2:last/2 
       tp(3) =k; 
       for q=k+1:last-1 
          tp(4)=q;tp(5)=last; 
          var=[var;tp]; 
       end 
    end 
end 
%����136������Ϊ4��var
%%%%%%%%%%%%%%%%%%%% 
if number==4 
    tp(1)=first; 
    for k=first+1:last-2 
       tp(2) =k; 
       for q=k+1:last-1 
          tp(3)=q;tp(4)=last; 
          var=[var;tp]; 
       end 
    end 
end 
%����17������Ϊ3��var
if number==3 
       tp(1) =first; 
       for q=first+1:last-1 
          tp(2)=q; tp(3)=last; 
          var=[var;tp]; 
       end 
 
end 
%����1������Ϊ2��var 
if number==2 
       tp(1) =first;tp(2)=last;  
       var=[var;tp]; 
end 

 