clear;
clear all;
tic;
%%
%protograph的参数
global  M;              global  N;  
global  vn_deg_min;     global  vn_deg_max;
global  cn_deg_min;     global  cn_deg_max;  
global  punc_len;       global  E0;
M=17;                   N=128;      
vn_deg_min=3;           vn_deg_max=17;      
cn_deg_min=15;          cn_deg_max=30;
punc_len=0;             E0=505;
rate=(N-M)/(N-punc_len);
%%
%GA求迭代阈值参数
global Pe;  global iter;    global sigma_min;   global sigma_max;
Pe = 1e-6;  iter = 8;       sigma_min=0.4;      sigma_max=0.6;
%%
global NP;
NP=10;
%初始化种群
[pop_deg_per_col,pop_deg_per_row]=initial_population();%产生NP个种群
[pop_sigma,pop_Pe]=population_fitness(pop_deg_per_col,pop_deg_per_row);%计算种群的适应度
%记录当前种群中的最好值
[pop_sigma_best,index] = max(pop_sigma);
pop_deg_per_col_best=pop_deg_per_col(index,:);
pop_deg_per_row_best=pop_deg_per_row(index,:);
disp(['pop_sigma_best=',num2str(pop_sigma_best)]);
sigma_best=pop_sigma_best;
%%
global mutate_num;
mutate_num=150;%对于单个个体行（列）度分布的突变产生个体数目
run_times=1;%记录运行次数
hold_times=0;%sigma_best保持不变的次数
%%
%利用GA来找最优度分布
while(hold_times<20)%若sigma_best一直保持不变，证明基本收敛
    disp(['run_times=',num2str(run_times)]);
    for i=1:2%改变度分布的不同策略，可取1，2，3，4
        for j=1:NP%对于NP个个体突变迭代
            [pop_deg_per_col(j,:),pop_deg_per_row(j,:),pop_sigma(j),pop_Pe(j)]=variant_iteration(pop_deg_per_col(j,:),pop_deg_per_row(j,:),pop_sigma(j),pop_Pe(j),i);
        end
        %记录当前种群中的最好值
        [pop_sigma_best,index] = max(pop_sigma);
        pop_deg_per_col_best=pop_deg_per_col(index,:);
        pop_deg_per_row_best=pop_deg_per_row(index,:);
        disp(['pop_sigma_best=',num2str(pop_sigma_best)]);
    end
    run_times=run_times+1;
    if(pop_sigma_best>sigma_best)
        sigma_best=pop_sigma_best;
        hold_times=0;
    else
        hold_times=hold_times+1;
    end
end

% save('result','sigma_best','deg_per_col_best','deg_per_row_best');


toc;


