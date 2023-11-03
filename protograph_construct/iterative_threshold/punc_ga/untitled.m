clear;
clear all;
tic;
%%
%��Ϊ�����������
M=80;
N=368;
E=1313;%�ܱ���
vn_deg=[3,14,15,16,17,18];%�����ڵ�Ķ�d
vn_deg_num=[352,2,3,5,4,2];%�����ڵ��Ϊd��Ӧ�ı����ڵ����Ŀ
vn_edge_prop=vn_deg_num.*vn_deg/E;%��Ϊd�ı����ڵ�ı�ռ�ܱ����ı���
cn_deg=[12,13,14,15,16,17,18,19,20];%У��ڵ�Ķ�d
cn_deg_num=[1,2,3,15,18,22,16,2,1];%У��ڵ��Ϊd��Ӧ��У��ڵ����Ŀ
cn_edge_prop=cn_deg_num.*cn_deg/E;%��Ϊd��У��ڵ�ı�ռ�ܱ����ı���
punc_deg=[16,17,18];
punc_prop=[3/5,3/4,2/2];
punc_len=7;
rate=(N-M)/(N-punc_len);
%%
%GA���������ֵ�Ĳ���
sigma_min = 0.3;%��С����
sigma_max = 0.8;%�������
Pe = 1e-6;%��С�������
iter=8;%iterations numbers
%%
%����GA���㲻ͬ���������ĵ�����ֵ
    %���ַ����������ֵ
[sigma_out,~]=GA_threshold_punc(sigma_min,sigma_max,iter,Pe,vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop);
r_ber = normcdf(0, 1, sigma_out);
disp(r_ber);
ebn0=1/(2*rate*sigma_out^2);
EBN0=10*log10(ebn0);
disp(EBN0);


toc;








