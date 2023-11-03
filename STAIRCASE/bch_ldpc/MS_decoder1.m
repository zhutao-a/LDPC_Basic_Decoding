function  ro= MS_decoder1(ri,N0, H)%不保留原有信道信息
%MS最小和算法
[M ,N] = size(H);		
LQi=zeros(1,N);
Lci =4*ri/N0;
Lrji = zeros(M, N);
Lqij = H.*repmat(Lci, M, 1);
for i = 1:M                  %更新Lrji
  c1 = find(H(i, :));
  prodallofalphaij=prod(sign(Lqij(i,c1)));
  [min_1,index_1]=min(abs(Lqij(i,c1)));
  a1=c1;
  a1(index_1)=[];
  min_2=min(abs(Lqij(i,a1)));
  for k1=1:length(c1)
      if(abs(Lqij(i,c1(k1)))==min_1)
        Lrji(i,c1(k1))=prodallofalphaij*sign(Lqij(i,c1(k1)))*min_2;
      else
        Lrji(i,c1(k1))=prodallofalphaij*sign(Lqij(i,c1(k1)))*min_1;
      end
  end
end 

for j = 1:N                      %更新Lqij
  c1=find( H( :,j ) );                          %找index(j)列的非0元素
  for k1 = 1:length(c1)         
     Lqij(c1(k1),j)= Lci( j ) + sum( Lrji( c1, j ) ) - Lrji( c1(k1), j );
  end      
  LQi(j) = Lci(j) + sum(Lrji(c1, j));
end 

Lci=LQi;
ro=Lci*N0/4;





