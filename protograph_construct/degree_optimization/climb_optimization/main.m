clear;
clear all;
tic;
%%
%protograph�Ĳ���
M=30;%protograph������
N=180;%protograph������
vn_deg_min=3;
vn_deg_max=20;
cn_deg_min=13;
cn_deg_max=30;
E0=700;
punc_idx=[1,2,3,4,5,6,7];%��puncture��������
punc_len=length(punc_idx);
rate=(N-M)/(N-punc_len);
%%
%GA���������ֵ�Ĳ���
Pe = 1e-6;%��С�������
iter = 8;%�������ĵ�������
sig_min=0.4;
sig_max=0.6;
%%
%��ʼ����Ⱥ
NP=100;
F=1;
CR=0.1;
[p_deg_per_col,p_deg_per_row]=init_pop(NP,N,M,E0,vn_deg_min,vn_deg_max,cn_deg_min,cn_deg_max);
%������Ⱥ����Ӧ��
[p_sigma,p_Pe]=cal_fitness(sig_min,sig_max,iter,Pe,p_deg_per_col,p_deg_per_row,punc_idx);
h_sigma=p_sigma;
h_Pe=p_Pe;
sigma_best=max(h_sigma);
disp(sigma_best);
for i=1:1000
    disp(['i=',num2str(i)]);
    %����������Ⱥ
    [v_deg_per_col,v_deg_per_row]=gen_variant(p_deg_per_col,p_deg_per_row,F);
    %��������Ⱥ��
    [u_deg_per_col,u_deg_per_row]=cross(p_deg_per_col,p_deg_per_row,v_deg_per_col,v_deg_per_row,CR);
    %�����ߵ���Ŀ������Ⱥ�Լ��
    [u_deg_per_col,u_deg_per_row]=E_adjust(E0,vn_deg_min,vn_deg_max,cn_deg_min,cn_deg_max,u_deg_per_col,u_deg_per_row); 
    %������Ⱥ����Ӧ��
    [p_sigma,p_Pe]=cal_fitness(sig_min,sig_max,iter,Pe,u_deg_per_col,u_deg_per_row,punc_idx);
    %ѡ����һ����Ⱥ
    for j=1:NP
        if((p_sigma(j)>h_sigma(j))||( (p_sigma(j)==h_sigma(j)) && (p_Pe(j)<h_Pe(j)) ))
            p_deg_per_col(j,:)=u_deg_per_col(j,:);
            p_deg_per_row(j,:)=u_deg_per_row(j,:);
            h_sigma(j)=p_sigma(j);
            h_Pe(j)=p_Pe(j);
        end
    end
    [sigma_best,index]=max(h_sigma);
    disp(['sigma_best=',num2str(sigma_best)]);
    
end
deg_per_col_best=p_deg_per_col(index,:);
deg_per_row_best=p_deg_per_row(index,:);

save('result','sigma_best','deg_per_col_best','deg_per_row_best');

toc;








