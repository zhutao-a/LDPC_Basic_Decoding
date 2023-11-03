clear;
clear all;
tic;
%%
%protograph�Ĳ���
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
%GA�������ֵ����
global Pe;  global iter;    global sigma_min;   global sigma_max;
Pe = 1e-6;  iter = 8;       sigma_min=0.4;      sigma_max=0.6;
%%
global NP;
NP=10;
%��ʼ����Ⱥ
[pop_deg_per_col,pop_deg_per_row]=initial_population();%����NP����Ⱥ
[pop_sigma,pop_Pe]=population_fitness(pop_deg_per_col,pop_deg_per_row);%������Ⱥ����Ӧ��
%��¼��ǰ��Ⱥ�е����ֵ
[pop_sigma_best,index] = max(pop_sigma);
pop_deg_per_col_best=pop_deg_per_col(index,:);
pop_deg_per_row_best=pop_deg_per_row(index,:);
disp(['pop_sigma_best=',num2str(pop_sigma_best)]);
sigma_best=pop_sigma_best;
%%
global mutate_num;
mutate_num=150;%���ڵ��������У��У��ȷֲ���ͻ�����������Ŀ
run_times=1;%��¼���д���
hold_times=0;%sigma_best���ֲ���Ĵ���
%%
%����GA�������Ŷȷֲ�
while(hold_times<20)%��sigma_bestһֱ���ֲ��䣬֤����������
    disp(['run_times=',num2str(run_times)]);
    for i=1:2%�ı�ȷֲ��Ĳ�ͬ���ԣ���ȡ1��2��3��4
        for j=1:NP%����NP������ͻ�����
            [pop_deg_per_col(j,:),pop_deg_per_row(j,:),pop_sigma(j),pop_Pe(j)]=variant_iteration(pop_deg_per_col(j,:),pop_deg_per_row(j,:),pop_sigma(j),pop_Pe(j),i);
        end
        %��¼��ǰ��Ⱥ�е����ֵ
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


