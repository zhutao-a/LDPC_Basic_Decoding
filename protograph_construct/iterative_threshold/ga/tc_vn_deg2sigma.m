clear;
clear all;
tic;
%%
%GA���������ֵ�Ĳ���
R=0.8;
sigma_min = 0.2;%��С����
sigma_max = 0.7;%�������
Pe = 1e-20;%��С�������
iter = 8;%����������
%%
%�ȷֲ���ز���
number=1000;
vn_deg=linspace(2,9,number);
vn_edge_prop=1;
cn_deg=zeros(1,number);
cn_edge_prop=1;
%%
sigma_out=zeros(1,number);
%���ø�˹���Ƽ��������ֵ
for i=1:number
    cn_deg(i)=vn_deg(i)/(1-R);%�ڸ���ƽ�������ڵ�ȷֲ������ƽ��У��ڵ�ȷֲ�
    [sigma_out(i),~]=GA_threshold(sigma_min,sigma_max,iter,Pe,vn_deg(i),vn_edge_prop,cn_deg(i),cn_edge_prop);%���ַ����������ֵ
end
plot(vn_deg,sigma_out);%����sigma��av_vn_deg����

[sigma_best,index]=max(sigma_out);%�ҳ���ǰ���������ŵ�sigma
vn_deg_best=vn_deg(index);%����sigma��Ӧ��ƽ���ȵ�ֵ
cn_deg_best=cn_deg(index);
ebn0=1/(2*R*sigma_best^2);%������ת��Ϊ�����EBN0
EBN0=10*log10(ebn0);
%��ӡ��Ϣ
disp(['sigma_best=',num2str(sigma_best)]);
disp(['vn_deg_best=',num2str(vn_deg_best)]);
disp(['cn_deg_best=',num2str(cn_deg_best)]);
disp(['EBN0=',num2str(EBN0)]);

%%
%ͼ�����
legend(num2str(R),'Location','SouthEast');%��������
text(vn_deg_best,sigma_best,['vn\_deg=',num2str(vn_deg_best),',','sig=',num2str(sigma_best),',','EBN0=',num2str(EBN0)]);%�ڼ�ֵ����Ӽ�ֵ����Ϣ
set(gcf,'Position',[500,100,1000,1000]);%����ͼ���С
grid on;
grid minor;
xlabel('average variable degree');
ylabel('sigma/EBN0');

toc;








