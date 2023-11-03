clear;
clear all;
tic;
%%
%protograph�Ĳ���
vn_degree_max=20;
cn_degree_max=20;
% average_dc=27.85;
rate=1-80/368;%Ҫ�������
M=80;%protograph������
N=368;%protograph������

% real_rate=1-M/N;%ʵ�ʵõ�������
% disp(N);disp(M);disp(real_rate);
%%
%GA���������ֵ�Ĳ���
Pe = 1e-20;%��С�������
max_iter = 50;%�������ĵ�������
NP=300;
%%
%��ʼ��protographÿ��ÿ�еĶȣ���Ҫ����sum(degree_per_col)=sum(degree_per_row)
% [degree_per_col,degree_per_row]=initial_degree(N,M,average_dc,vn_degree_max,cn_degree_max);
%ͨ��ÿ��ÿ�еĶȼ�����ȷֲ�

vn_degree=[3,14,15,16,17,18];%�����ڵ�Ķ�d
vn_degree_num=[352,2,3,5,4,2];%�����ڵ��Ϊd��Ӧ�ı����ڵ����Ŀ
cn_degree=[12,13,14,15,16,17,18,19,20];%У��ڵ�Ķ�d
cn_degree_num=[1,2,3,15,18,22,16,2,1];%У��ڵ��Ϊd��Ӧ��У��ڵ����Ŀ
degree_per_col=zeros(1,368);
j=1;
i=1;
while(i<=368)
    if(vn_degree_num(j)~=0)
        degree_per_col(i)=vn_degree(j);
        vn_degree_num(j)=vn_degree_num(j)-1;
        i=i+1;
    else
        j=j+1;
    end
end
degree_per_row=zeros(1,80);
j=1;
i=1;
while(i<=80)
    if(cn_degree_num(j)~=0)
        degree_per_row(i)=cn_degree(j);
        cn_degree_num(j)=cn_degree_num(j)-1;
        i=i+1;
    else
        j=j+1;
    end
end

[vn_degree,vn_edge_portion,cn_degree,cn_edge_portion]=degree_distribution(degree_per_col,degree_per_row);
%�����ȷֲ��Ͳ������ø�˹���Ƽ��������ֵ(���ַ�)
[sigma,Pe_best]=calculate_threshold_GA(0.3,0.7,max_iter,Pe,vn_degree,vn_edge_portion,cn_degree,cn_edge_portion);
sigma_best=sigma;
disp(sigma_best);
disp(Pe_best);

sigma_current=zeros(NP,1);
Pe_current=zeros(NP,1);
i=0;
while(i<300)
    disp(i);
    for j=1:4
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
