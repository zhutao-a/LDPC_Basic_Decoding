%polarcode仿真的主程序
clear
clc
tic;%12.497872 seconds.
N=256;%编码比特长度
K=239;%信息比特长度
erframe=0;
L=4;
EbN0=5.0:0.5:8.0;%仿真信噪比
lE=length(EbN0);
frame=zeros(1,lE);
err_ber=zeros(1,lE);  %%程序开始之前没有误码，误比特个数
err_bler=zeros(1,lE);  %%误码块个数
err_ber1=zeros(1,lE);  %%程序开始之前没有误码，误比特个数
err_bler1=zeros(1,lE);  %%误码块个数
err_ber2=zeros(1,lE);  %%程序开始之前没有误码，误比特个数
err_bler2=zeros(1,lE);  %%误码块个数
errorrate_ber=zeros(1,lE);%误比特率
errorrate_ber1=zeros(1,lE);
errorrate_ber2=zeros(1,lE);
errorrate_bler=zeros(1,lE);%误码块率
errorrate_bler1=zeros(1,lE);%误码块率
errorrate_bler2=zeros(1,lE);%误码块率
rber=zeros(1,lE);%误码块率
eframe = [20,20,20,20];
rber_bit=zeros(1,lE);
for i=1:lE
    sigma=sqrt(N/(2*10^(EbN0(i)/10)*K));%高斯噪声标准差
    erframe=0;
    erframe1=0;
    erframe2=0;
    p=get_frozee(EbN0(i),K,N);
    while frame(i)<5000 %该值越大，跑出来的效果越好，但花费的时间越长（azt）
        frame(i)=frame(i)+1;
        u=ones(1,K);
        x1=polarEnc(u,N,p);%编码后的比特序列
        x11=bpsk(x1);%发送比特序列
        y=awgn(x11,N,sigma);%加入噪声后的接收比特序列
%         load('testy.mat')
        rber_num=error_count(y,x1);
        rber_bit(i)=rber_bit(i)+rber_num;
        [uyima,soft] = polarDecBP(u,y,p,sigma);
        %toc
        errbits=length(find(uyima(1,:)~=u));%译码后序列和信息序列不同bit的长度
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
        errbits1=length(find(uyima1(1,:)~=u));%译码后序列和信息序列不同bit的长度
        if errbits1~=0
            errblock1=1;
            erframe1=erframe1+1;
        else
            errblock1=0;
        end
        errbits2=length(find(uyima2(1,:)~=u));%译码后序列和信息序列不同bit的长度
        if errbits2~=0
            errblock2=1;
            erframe2=erframe2+1;
        else
            errblock2=0;
        end
        err_ber(i)=errbits+err_ber(i);%err用于统计当前的错误bit总个数
        err_bler(i)=errblock+err_bler(i);%统计误块个数
        err_ber1(i)=errbits1+err_ber1(i);%err用于统计当前的错误bit总个数
        err_bler1(i)=errblock1+err_bler1(i);%统计误块个数
        err_ber2(i)=errbits2+err_ber2(i);%err用于统计当前的错误bit总个数
        err_bler2(i)=errblock2+err_bler2(i);%统计误块个数
    end
    errorrate_ber(i)=err_ber(i)./(length(x1)*frame(i))%计算误码率
    errorrate_bler(i)=err_bler(i)./frame(i)%计算误块率
    errorrate_ber1(i)=err_ber1(i)./(length(x1)*frame(i))%计算误码率
    errorrate_bler1(i)=err_bler1(i)./frame(i)%计算误块率
    errorrate_ber2(i)=err_ber2(i)./(length(x1)*frame(i))%计算误码率
    errorrate_bler2(i)=err_bler2(i)./frame(i)%计算误块率
    rber(i)=rber_bit(i)./(frame(i)*N);
end

figure;semilogy(rber,errorrate_bler,'-ro',rber,errorrate_bler1,'--k+',rber,errorrate_bler2,':bs');grid on;
legend('SCAN','ASCL[1]','ASCL改');
xlabel('RBER');
ylabel('FER');
grid on;
figure;semilogy(rber,errorrate_ber,'-ro',rber,errorrate_ber1,'--k+',rber,errorrate_ber2,':bs');grid on;
legend('SCAN','ASCL[1]','ASCL改');
xlabel('RBER');
ylabel('FER');
grid on;