clear;
clear all;
tic;
%%
%protograph的参数
M=30;%protograph的行数
N=180;%protograph的列数
vn_deg_min=3;
vn_deg_max=20;
cn_deg_min=13;
cn_deg_max=30;
E0=700;
punc_idx=[1,2,3,4,5,6,7];%被puncture的列索引
punc_len=length(punc_idx);
rate=(N-M)/(N-punc_len);
%%
%GA计算迭代阈值的参数
Pe = 1e-6;%最小错误概率
iter = 8;%设置最大的迭代次数
sig_min=0.4;
sig_max=0.6;
%%
%初始化种群
NP=100;
F=1;
CR=0.1;
[p_deg_per_col,p_deg_per_row]=init_pop(NP,N,M,E0,vn_deg_min,vn_deg_max,cn_deg_min,cn_deg_max);
%计算种群的适应度
[p_sigma,p_Pe]=cal_fitness(sig_min,sig_max,iter,Pe,p_deg_per_col,p_deg_per_row,punc_idx);
h_sigma=p_sigma;
h_Pe=p_Pe;
sigma_best=max(h_sigma);
disp(sigma_best);
for i=1:1000
    disp(['i=',num2str(i)]);
    %产生变异种群
    [v_deg_per_col,v_deg_per_row]=gen_variant(p_deg_per_col,p_deg_per_row,F);
    %产生交叉群体
    [u_deg_per_col,u_deg_per_row]=cross(p_deg_per_col,p_deg_per_row,v_deg_per_col,v_deg_per_row,CR);
    %调整边的数目以满足等号约束
    [u_deg_per_col,u_deg_per_row]=E_adjust(E0,vn_deg_min,vn_deg_max,cn_deg_min,cn_deg_max,u_deg_per_col,u_deg_per_row); 
    %计算种群的适应度
    [p_sigma,p_Pe]=cal_fitness(sig_min,sig_max,iter,Pe,u_deg_per_col,u_deg_per_row,punc_idx);
    %选择下一代种群
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








