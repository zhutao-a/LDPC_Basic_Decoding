function [pop_deg_per_col,pop_deg_per_row]=initial_population()%����NP����Ⱥ
%%
%ȫ�ֲ���
global  NP; 
global  N;              global  M;  
%%
%����NP����Ⱥ
pop_deg_per_col=zeros(NP,N);
pop_deg_per_row=zeros(NP,M);
for i=1:NP 
    [pop_deg_per_col(i,:),pop_deg_per_row(i,:)]=initial_degree();%��ʼ��protographÿ��ÿ�еĶ�
end


