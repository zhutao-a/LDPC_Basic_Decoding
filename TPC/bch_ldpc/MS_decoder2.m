function  ro= MS_decoder2(ri,n_code,H,iteration)%����ԭ���ŵ���Ϣ
%MS��С���㷨
[M ,N] = size(H);		
LQi=zeros(1,N);
Lrji = zeros(M, N);
Lqij = H.*repmat(ri, M, 1);
for n=1:iteration
    for i = 1:M                  %����Lrji
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
    for j = 1:N                      %����Lqij
        c1=find( H( :,j ) );                          %��index(j)�еķ�0Ԫ��
        for k1 = 1:length(c1)         
            Lqij(c1(k1),j)= n_code( j ) + sum( Lrji( c1, j ) ) - Lrji( c1(k1), j );
        end      
        LQi(j) = n_code(j) + sum(Lrji(c1, j));
    end
end

ro=LQi;





