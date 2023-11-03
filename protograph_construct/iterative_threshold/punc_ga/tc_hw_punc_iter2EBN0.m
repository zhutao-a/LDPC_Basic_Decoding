clear;
clear all;
tic;
%%
filename='tc_hwmatrix_punc_iter2EBN0';
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
% punc_deg=[];
% punc_prop=[];
punc_len=8;
rate=(N-M)/(N-punc_len);
%%
%GA���������ֵ�Ĳ���
sigma_min = 0.3;%��С����
sigma_max = 0.8;%�������
Pe = 1e-9;%��С�������
iter=[8,10,15,20,30,40,50,100,150,200,250];%iterations numbers
sigma_out=zeros(1,length(iter));
EBN0=zeros(1,length(iter));
%%
%����GA���㲻ͬ���������ĵ�����ֵ
for i=1:length(iter)
    disp(i);
    %���ַ����������ֵ
    [sigma_out(i),~]=GA_threshold_punc(sigma_min,sigma_max,iter(i),Pe,vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop);
    ebn0=1/(2*rate*sigma_out(i)^2);
    EBN0(i)=10*log10(ebn0);
end
%%
%��ͼ
plot(iter,EBN0,'-ro','LineWidth',1.5,'MarkerSize',5);
hold on;
text(iter,EBN0,num2str(EBN0.'),'color','b');%��Ӧλ����ʾ��ֵ
%ͼ�����
set(gcf,'Position',[500,100,1000,1000]);%����ͼ���С
xlabel('iter');
ylabel('EBN0');
title(['rate=',num2str(rate)]);
grid on;
grid minor;
%��������
saveas(gcf,filename,'bmp');
save(filename,'iter','sigma_out','EBN0');


toc;








