clear;
clear all;

rate=111/128;%要求的码率
% N=120;%protograph的列数
% M=round((1-rate)*N);%%protograph的行数
% real_rate=1-M/N;%实际得到的码率
sigma=0.4994;

ebn0=1/(2*rate*sigma^2);
EBN0=10*log10(ebn0);
disp(['The threshold EBN0 = ' num2str(EBN0)]);

% IT_MAX=8;
% fixed_Rate=111/128;
% vn_degree=[2,3,4,5,16,20];
% vn_edge_portion=[4.0000e-04 0.2464    0.3155    0.4313    0.0050    0.0014];
% cn_degree=[30,31];
% cn_edge_portion=[0.6135    0.3865];
% [ch_degree,ch_index,~]=rate_redress2(vn_edge_portion,fixed_Rate,vn_degree);
% disp(ch_degree(ch_index));disp(ch_index);
% sigma=0.4876;


% Rate=calculate_Rate(vn_degree,vn_edge_portion,ch_index,ch_degree(ch_index))
