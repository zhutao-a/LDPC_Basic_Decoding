function [yo,iter] = BP_decodenewc(y,N0,H,m,n,max_iter)
if m>n
   H=H'; 
  [m,n] = size(H); 
end
if ~issparse(H)               
   [ii,jj,sH] = find(H);
   H = sparse(ii,jj,sH,m,n);  
end
p0=1./(1+exp(-2.*y./(N0/2)));  
p1=1-p0;
[ii,jj] = find(H);            
indx = sub2ind(size(H),ii,jj);
q0 = H * spdiags(p0(:),0,n,n); 
sq0 = full(q0(indx)); 
sff0 = sq0;
q1 = H * spdiags(p1(:),0,n,n); 
sq1 = full(q1(indx));  
sff1 = sq1;
for iter=1:max_iter   
        wsq1=1-2.*sq1; 
        wsq1(find(wsq1==0))=1e-20;
        dq = sparse(ii,jj,wsq1,m,n);
        Pdq_v = full(real(exp(sum(spfun('log',dq),2))));
   Pdq = spdiags(Pdq_v(:),0,m,m) * H; 
   sPdq = full(Pdq(indx));    
       sr0 = (1+sPdq./wsq1)./2; sr0(find(abs(sr0) < 1e-20)) = 1e-20; 
       sr1 = (1-sPdq./wsq1)./2; sr1(find(abs(sr1) < 1e-20)) = 1e-20;
   r0 = sparse(ii,jj,sr0,m,n); 
   r1 = sparse(ii,jj,sr1,m,n);
   Pr0_v = full(real(exp(sum(spfun('log',r0),1))));
   Pr0 = H * spdiags(Pr0_v(:),0,n,n);
   sPr0 = full(Pr0(indx));
   Q0 = full(sum(sparse(ii,jj,sPr0.*sff0,m,n),1));
   Pr1_v = full(real(exp(sum(spfun('log',r1),1))));
   Pr1 = H * spdiags(Pr1_v(:),0,n,n);
   sPr1 = full(Pr1(indx)); 
   Q1 = full(sum(sparse(ii,jj,sPr1.*sff1,m,n),1));
   sq1 = sPr1.*sff1./sr1;
   sqq = sq0+sq1;
   sq0 = sq0./sqq;
   sq1 = sq1./sqq;
   QQ = Q0+Q1;
   Q0 = Q0./QQ;
   Q1 = Q1./QQ;
   yo = (sign(Q1-Q0)+1)/2;
    if rem(H*yo.',2) == 0,
        break; 
    end
end