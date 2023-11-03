%%%regular LDPC(3,6) 
function [L_u]=LDPC_decoding(L_r,decode_iterations)
load PEGH_3_6_504.mat
K=252;                      
N=504;  %%% length of codeword
Rate=0.5;
M=round(N*(1-Rate));
for i=1:M
    Hrow_entity(i)=length(find(H_indexrow(i,:)~=0));
end
%%%BP decoding of LDPC code %%%
     for i=1:M 
         for j_i=1:Hrow_entity(i)       
             M_vc(j_i,i)=L_r(H_indexrow(i,j_i));
         end
     end
     for iterations_i=1:decode_iterations       
         for i=1:M
             for j_i=1:Hrow_entity(i)
                     temp=1;
                     for k_i=1:Hrow_entity(i)
                         if k_i==j_i
                             continue;
                         end
                         temp=temp*tanh(M_vc(k_i,i)/2);     
                     end                
                    M_cv(i,j_i)=2*atanh(temp);
             end
         end  
         for i=1:N
             for j_i=1:3
                 temp=0;
                 for k_i=1:3
                     if k_i==j_i
                         continue;
                     end
                     for z_i=1:Hrow_entity(H_indexcol(i,k_i))
                         if H_indexrow(H_indexcol(i,k_i),z_i)==i
                             temp=temp+M_cv(H_indexcol(i,k_i),z_i);
                             break;
                         end
                     end
                 end
                 for z_i=1:Hrow_entity(H_indexcol(i,j_i))
                     if H_indexrow(H_indexcol(i,j_i),z_i)==i
                         M_vc(z_i,H_indexcol(i,j_i))=temp+L_r(i);
                     end
                 end 
             end
         end     
     end
     L_u=L_r;
     for i=1:M
         for j_i=1:Hrow_entity(i)  
             L_u(H_indexrow(i,j_i))= L_u(H_indexrow(i,j_i))+M_cv(i,j_i);            
         end
     end




