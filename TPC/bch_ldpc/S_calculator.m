function S_k=S_calculator(b,k,gf_table)%����У���ӣ�S_k��ʾ��Ӧ�Ķ���������,b��ʾӲ�̾�������֣��ߴ�����ǰ
l_b=length(b);%l_b=256
r=b(1:l_b-1);%��ȥ���һλ��żУ��λ
l_r=l_b-1;%l_r=255
temp=zeros(1,l_r);
%temp=k0+k1*a^1+k2*a^2+...+(kl_r-1)*a^(l_r-1)

for i=1:l_r   %��У���Ӵ���l_r���ݵĲ���ģl_r�Ӷ����ݣ�temp������ǰ�������ں�ע��r�Ǹߴ���ǰ��
    if r(i)==1%�������ң���ʱ�ߴ�����ǰ
        j=mod((l_r-i)*k,l_r);%r�ߴ���ǰ������Ϊl_r-i,���mod l_r��ʣ����ݴ�j(ע������gf����������ʽ����)
        temp(j+1)=xor(temp(j+1),1);%��һ��Ϊ��0�������j����j+1
    end
end

S_k=zeros(1,log2(l_r+1));%S_k=[0,0,0,0,0,0,0,0]

for i=1:l_r%��temp��������ݵļӷ����ò��ұ�תΪgf���ڵ�һ��Ԫ��,��S_k����������
    if temp(i)==1 %����a^(i-1)��һ��
        S_k=mod(S_k+gf_table(i,:),2);
    end
end







