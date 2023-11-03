function [sigma,deg_per_col,deg_per_row]=E_fixed(E)
global N;           global M;
global vn_deg_min;  global vn_deg_max;
global cn_deg_min;  global cn_deg_max;
global sig_min;     global sig_max;
global iter;        global Pe;
global punc_idx;    global NP;
global F;           global CR;
%��ʼ����Ⱥ
[p_deg_per_col,p_deg_per_row]=init_pop(NP,N,M,E,vn_deg_min,vn_deg_max,cn_deg_min,cn_deg_max);
%������Ⱥ����Ӧ��
[last_sigma,last_Pe]=cal_fitness(sig_min,sig_max,iter,Pe,p_deg_per_col,p_deg_per_row,punc_idx);
%��¼����ֵ
[sigma,index]=max(last_sigma);
deg_per_col=p_deg_per_col(index,:);
deg_per_row=p_deg_per_row(index,:);
for i=1:1000
    %����������Ⱥ
    [v_deg_per_col,v_deg_per_row]=gen_variant(p_deg_per_col,p_deg_per_row,F);
    %��������Ⱥ��
    [u_deg_per_col,u_deg_per_row]=cross(p_deg_per_col,p_deg_per_row,v_deg_per_col,v_deg_per_row,CR);
    %�����ߵ���Ŀ������Ⱥ�Լ��
    [u_deg_per_col,u_deg_per_row]=E_adjust(E,vn_deg_min,vn_deg_max,cn_deg_min,cn_deg_max,u_deg_per_col,u_deg_per_row); 
    %������Ⱥ����Ӧ��
    [next_sigma,next_Pe]=cal_fitness(sig_min,sig_max,iter,Pe,u_deg_per_col,u_deg_per_row,punc_idx);
    %ѡ����һ����Ⱥ
    for j=1:NP
        if((next_sigma(j)>last_sigma(j))||( (next_sigma(j)==last_sigma(j)) && (next_Pe(j)<last_Pe(j)) ))
            p_deg_per_col(j,:)=u_deg_per_col(j,:);
            p_deg_per_row(j,:)=u_deg_per_row(j,:);
            last_sigma(j)=next_sigma(j);
            last_Pe(j)=next_Pe(j);
        end
    end
    %��¼����ֵ
    [sigma,index]=max(last_sigma);
    deg_per_col=p_deg_per_col(index,:);
    deg_per_row=p_deg_per_row(index,:);
end