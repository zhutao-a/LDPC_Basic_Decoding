clc
clear
EbN0=4.0:0.4:6.0;
lE=length(EbN0);
N=256;
K=239;
R=K/N;
error_bit=zeros(1,lE);
error_frame=zeros(1,lE);
stop_frame=50;
erframe=0;
L=16;
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
rber_bit=zeros(1,lE);
N0 = (1/R)*(1./exp(EbN0*(log(10)/10)));
sigma=sqrt(N0/2);
r_ber = normcdf(0, 1, sigma);
for n=1:lE
    disp(n);
    erframe=0;
    erframe1=0;
    erframe2=0;
    p=get_frozee(EbN0(n),K,N);
    while frame(n)<20000
        frame(n)=frame(n)+1;
%         rng(frame(n));disp(frame(n)); 
        msg=round(rand(1,K));
%         msg=ones(1,K);
        x1=polarEnc(msg,N,p);%�����ı�������
        x11=bpsk(x1);%���ͱ�������
        y=awgn(x11,N,sigma(n));%����������Ľ��ձ�������
        ecode=lfsr_encoder(msg,N,K);%��ɱ���
        n_code=noise_code(ecode,EbN0(n),frame(n));%�������
        rber_num=error_count(y,msg);
        rber_bit(n)=rber_bit(n)+rber_num;
        [uyima,soft] = polarDecBP(msg,y,p,sigma(n));
        [~,uyima1]=BCHdecoder(n_code,ecode);%������
        errbits=length(find(uyima(1,:)~=msg));%��������к���Ϣ���в�ͬbit�ĳ���
        if errbits~=0
            errblock=1;
            erframe=erframe+1;
            uyima2 = ASOL(soft,L,y,p,sigma(n),msg);
        else
            uyima2 = uyima;
            errblock=0;
        end
        errbits1=length(find(uyima1~=ecode));%��������к���Ϣ���в�ͬbit�ĳ���
        if errbits1~=0
            errblock1=1;
            erframe1=erframe1+1;
        else
            errblock1=0;
        end
        errbits2=length(find(uyima2(1,:)~=msg));%��������к���Ϣ���в�ͬbit�ĳ���
        if errbits2~=0
            errblock2=1;
            erframe2=erframe2+1;
        else
            errblock2=0;
        end
        err_ber(n)=errbits+err_ber(n);%err����ͳ�Ƶ�ǰ�Ĵ���bit�ܸ���
        err_bler(n)=errblock+err_bler(n);%ͳ��������
        err_ber1(n)=errbits1+err_ber1(n);%err����ͳ�Ƶ�ǰ�Ĵ���bit�ܸ���
        err_bler1(n)=errblock1+err_bler1(n);%ͳ��������
        err_ber2(n)=errbits2+err_ber2(n);%err����ͳ�Ƶ�ǰ�Ĵ���bit�ܸ���
        err_bler2(n)=errblock2+err_bler2(n);%ͳ��������
    end
    errorrate_ber(n)=err_ber(n)./(length(x1)*frame(n));%����������
    errorrate_bler(n)=err_bler(n)./frame(n);%���������
    errorrate_ber1(n)=err_ber1(n)./(length(x1)*frame(n));%����������
    errorrate_bler1(n)=err_bler1(n)./frame(n);%���������
    errorrate_ber2(n)=err_ber2(n)./(length(x1)*frame(n));%����������
    errorrate_bler2(n)=err_bler2(n)./frame(n);%���������
    rber(n)=rber_bit(n)./(frame(n)*N);
end
figure;semilogy(r_ber,errorrate_ber,'-ro',r_ber,errorrate_ber1,'--k+',r_ber,errorrate_ber2,':bs');grid on;
legend('SCAN','BCH','ISOL');
xlabel('RBER');
ylabel('BER');
grid on;




