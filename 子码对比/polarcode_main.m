%polarcode�����������
clear
clc
tic;%12.497872 seconds.
N=256;%������س���
K=239;%��Ϣ���س���
erframe=0;
L=4;
EbN0=5.0:0.5:8.0;%���������
lE=length(EbN0);
frame=zeros(1,lE);
err_ber=zeros(1,lE);  %%����ʼ֮ǰû�����룬����ظ���
err_bler=zeros(1,lE);  %%��������
err_ber1=zeros(1,lE);  %%����ʼ֮ǰû�����룬����ظ���
err_bler1=zeros(1,lE);  %%��������
err_ber2=zeros(1,lE);  %%����ʼ֮ǰû�����룬����ظ���
err_bler2=zeros(1,lE);  %%��������
errorrate_ber=zeros(1,lE);%�������
errorrate_ber1=zeros(1,lE);
errorrate_ber2=zeros(1,lE);
errorrate_bler=zeros(1,lE);%�������
errorrate_bler1=zeros(1,lE);%�������
errorrate_bler2=zeros(1,lE);%�������
rber=zeros(1,lE);%�������
eframe = [20,20,20,20];
rber_bit=zeros(1,lE);
for i=1:lE
    sigma=sqrt(N/(2*10^(EbN0(i)/10)*K));%��˹������׼��
    erframe=0;
    erframe1=0;
    erframe2=0;
    p=get_frozee(EbN0(i),K,N);
    while frame(i)<5000 %��ֵԽ���ܳ�����Ч��Խ�ã������ѵ�ʱ��Խ����azt��
        frame(i)=frame(i)+1;
        u=ones(1,K);
        x1=polarEnc(u,N,p);%�����ı�������
        x11=bpsk(x1);%���ͱ�������
        y=awgn(x11,N,sigma);%����������Ľ��ձ�������
%         load('testy.mat')
        rber_num=error_count(y,x1);
        rber_bit(i)=rber_bit(i)+rber_num;
        [uyima,soft] = polarDecBP(u,y,p,sigma);
        %toc
        errbits=length(find(uyima(1,:)~=u));%��������к���Ϣ���в�ͬbit�ĳ���
        if errbits~=0
            errblock=1;
            erframe=erframe+1;
            uyima1 = ASOL1(soft,L,y,p,sigma,u);
            uyima2 = ASOL(soft,L,y,p,sigma,u);
        else
            uyima1 = uyima;
            uyima2 = uyima;
            errblock=0;
        end
        errbits1=length(find(uyima1(1,:)~=u));%��������к���Ϣ���в�ͬbit�ĳ���
        if errbits1~=0
            errblock1=1;
            erframe1=erframe1+1;
        else
            errblock1=0;
        end
        errbits2=length(find(uyima2(1,:)~=u));%��������к���Ϣ���в�ͬbit�ĳ���
        if errbits2~=0
            errblock2=1;
            erframe2=erframe2+1;
        else
            errblock2=0;
        end
        err_ber(i)=errbits+err_ber(i);%err����ͳ�Ƶ�ǰ�Ĵ���bit�ܸ���
        err_bler(i)=errblock+err_bler(i);%ͳ��������
        err_ber1(i)=errbits1+err_ber1(i);%err����ͳ�Ƶ�ǰ�Ĵ���bit�ܸ���
        err_bler1(i)=errblock1+err_bler1(i);%ͳ��������
        err_ber2(i)=errbits2+err_ber2(i);%err����ͳ�Ƶ�ǰ�Ĵ���bit�ܸ���
        err_bler2(i)=errblock2+err_bler2(i);%ͳ��������
    end
    errorrate_ber(i)=err_ber(i)./(length(x1)*frame(i))%����������
    errorrate_bler(i)=err_bler(i)./frame(i)%���������
    errorrate_ber1(i)=err_ber1(i)./(length(x1)*frame(i))%����������
    errorrate_bler1(i)=err_bler1(i)./frame(i)%���������
    errorrate_ber2(i)=err_ber2(i)./(length(x1)*frame(i))%����������
    errorrate_bler2(i)=err_bler2(i)./frame(i)%���������
    rber(i)=rber_bit(i)./(frame(i)*N);
end

figure;semilogy(rber,errorrate_bler,'-ro',rber,errorrate_bler1,'--k+',rber,errorrate_bler2,':bs');grid on;
legend('SCAN','ASCL[1]','ASCL��');
xlabel('RBER');
ylabel('FER');
grid on;
figure;semilogy(rber,errorrate_ber,'-ro',rber,errorrate_ber1,'--k+',rber,errorrate_ber2,':bs');grid on;
legend('SCAN','ASCL[1]','ASCL��');
xlabel('RBER');
ylabel('FER');
grid on;