clear;
clear all;
tic;
%%
%protograph�Ĳ���
vn_degree_max=17;
cn_degree_max=30;
average_dc=27.85;
rate=111/128;%Ҫ�������
M=17;%protograph������
N=round(M/(1-rate));%protograph������

real_rate=1-M/N;%ʵ�ʵõ�������
disp(N);disp(M);disp(real_rate);
%%
%GA���������ֵ�Ĳ���
Pe = 1e-16;%��С�������
max_iter = 50;%�������ĵ�������
NP=300;
%%
%��ʼ��protographÿ��ÿ�еĶȣ���Ҫ����sum(degree_per_col)=sum(degree_per_row)
[degree_per_col,degree_per_row]=initial_degree(N,M,average_dc,vn_degree_max,cn_degree_max);
%ͨ��ÿ��ÿ�еĶȼ�����ȷֲ�
[vn_degree,vn_edge_portion,cn_degree,cn_edge_portion]=degree_distribution(degree_per_col,degree_per_row);
%�����ȷֲ��Ͳ������ø�˹���Ƽ��������ֵ(���ַ�)
[sigma,Pe_best]=calculate_threshold_GA(0.2,0.6,max_iter,Pe,vn_degree,vn_edge_portion,cn_degree,cn_edge_portion);
sigma_best=sigma;
disp(sigma_best);
disp(Pe_best);
sigma_current=zeros(NP,1);
Pe_current=zeros(NP,1);
i=0;
while(i<300)
    disp(i);
    for j=1:2
        [m_degree_per_col,m_degree_per_row]=change_degree(degree_per_col,degree_per_row,NP,j,vn_degree_max,cn_degree_max);%ͨ����ͬ�������ı�ȷֲ�
        for k=1:NP
            %ͨ��ÿ��ÿ�еĶȼ�����ȷֲ�
            [vn_degree,vn_edge_portion,cn_degree,cn_edge_portion]=degree_distribution(m_degree_per_col(k,:),m_degree_per_row(k,:));
            %�����ȷֲ��Ͳ������ø�˹���Ƽ��������ֵ(���ַ�)
            [sigma_current(k),Pe_current(k)]=calculate_threshold_GA(0.2,0.6,max_iter,Pe,vn_degree,vn_edge_portion,cn_degree,cn_edge_portion);
        end
        [sigma_current_best,index] = max(sigma_current);%��öȱ仯�������sigma
        if(sigma_current_best>sigma_best)
            sigma_best=sigma_current_best;
            Pe_best=Pe_current(index);
            degree_per_col=m_degree_per_col(index,:);
            degree_per_row=m_degree_per_row(index,:);
        elseif(sigma_current_best==sigma_best)
            tmp1=find(sigma_current==sigma_current_best);%�ҵ�����sigma��ͬ������        
            [Pe_min,tmp2]=min(Pe_current(tmp1));%ȡ��Сpe,���ҳ�����
            if(Pe_min<Pe_best)
                Pe_best=Pe_min;
                degree_per_col=m_degree_per_col(tmp1(tmp2),:);
                degree_per_row=m_degree_per_row(tmp1(tmp2),:);
            end

        end
        disp(sigma_best);
        disp(Pe_best);
    end
    i=i+1;
    if(mod(i,10)==0)
        [vn_degree,vn_edge_portion,cn_degree,cn_edge_portion]=degree_distribution(degree_per_col,degree_per_row);
        disp(vn_degree);
        disp(vn_edge_portion);
        disp(cn_degree);
        disp(cn_edge_portion);
    end
end




toc;

%         ebn0=1/(2*Rate*sigma^2);
%         EBN0=10*log10(ebn0);
%         disp(['The threshold EBN0 = ' num2str(EBN0)]);
