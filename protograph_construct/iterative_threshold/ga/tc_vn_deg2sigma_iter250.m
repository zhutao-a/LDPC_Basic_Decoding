clear;
clear all;
tic;
%%
filename='tc_vn_deg2sigma_iter250';
%GA���������ֵ�Ĳ���
R=[0.5,0.55,0.60,0.65,0.70,0.75,0.80,0.83333,0.85,111/128,0.90,0.95];
sigma_min = 0.2;%��С����
sigma_max = 0.9;%�������
Pe = 1e-20;%��С�������
iter = 250;%����������
%%
%�ȷֲ���ز���
number=1000;
vn_deg=linspace(2,9,number);
vn_edge_prop=1;
cn_deg=zeros(1,number);
cn_edge_prop=1;
%%
sigma_best=zeros(1,length(R));
vn_deg_best=zeros(1,length(R));
EBN0_best=zeros(1,length(R));
%������ͬ�����ڹ���ȷֲ��£�������ڵ�ȴ�С�仯���仯
for j=1:length(R)
    disp(j);
    sigma_out=zeros(1,number);
    %���ø�˹���Ƽ��������ֵ
    for i=1:number
        cn_deg(i)=vn_deg(i)/(1-R(j));%�ڸ���ƽ�������ڵ�ȷֲ������ƽ��У��ڵ�ȷֲ�
        [sigma_out(i),~]=GA_threshold(sigma_min,sigma_max,iter,Pe,vn_deg(i),vn_edge_prop,cn_deg(i),cn_edge_prop);%���ַ����������ֵ
    end
    plot(vn_deg,sigma_out);%����sigma��av_vn_deg����
    hold on;
    [sigma_best(j),index]=max(sigma_out);%�ҳ���ǰ���������ŵ�sigma
    vn_deg_best(j)=vn_deg(index);%����sigma��Ӧ��ƽ���ȵ�ֵ
    
    ebn0=1/(2*R(j)*sigma_best(j)^2);%������ת��Ϊ�����EBN0
    EBN0_best(j)=10*log10(ebn0);
    
    text(vn_deg_best(j),sigma_best(j),['vn\_deg=',num2str(vn_deg_best(j)),',','sig=',num2str(sigma_best(j)),',','EBN0=',num2str(EBN0_best(j))]);%�ڼ�ֵ����Ӽ�ֵ����Ϣ
end
%%
%ͼ�����
legend(num2str(R.'),'Location','SouthEast');%��������
set(gcf,'Position',[500,100,1000,1000]);%����ͼ���С
grid on;
grid minor;
xlabel('average variable degree');
ylabel('sigma/EBN0');
title(['iter=',num2str(iter),',','Pe=',num2str(Pe)]);
%��������
saveas(gcf,filename,'bmp');
save(filename,'vn_deg_best','sigma_best','EBN0_best');

toc;








