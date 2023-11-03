clear;
clear all;
tic;
%%
%GA���������ֵ�Ĳ���
R=linspace(0.8,111/128,10);
sigma_min = 0.2;%��С����
sigma_max = 0.7;%�������
Pe = 1e-20;%��С�������
iter = 8;%����������
%%
%�ȷֲ���ز���
number=1000;
vn_deg=linspace(2.5,7,number);
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
    
    [sigma_best(j),index]=max(sigma_out);%�ҳ���ǰ���������ŵ�sigma
    vn_deg_best(j)=vn_deg(index);%����sigma��Ӧ��ƽ���ȵ�ֵ
    ebn0=1/(2*R(j)*sigma_best(j)^2);%������ת��Ϊ�����EBN0
    EBN0_best(j)=10*log10(ebn0);

    
    ebn0=1./(2*R(j)*sigma_out.^2);%������ת��Ϊ�����EBN0
    
    EBN0=10*log10(ebn0);
    plot(vn_deg,EBN0);%����sigma��av_vn_deg����
    
    text(vn_deg_best(j),EBN0_best(j),['vn\_deg=',num2str(vn_deg_best(j)),',','EBN0=',num2str(EBN0_best(j))]);%�ڼ�ֵ����Ӽ�ֵ����Ϣ
    
    hold on;
end
%%
legend(num2str(R.'),'Location','NorthEast');%��������
set(gcf,'Position',[500,100,1000,1000]);%����ͼ���С
grid on;
grid minor;

toc;








