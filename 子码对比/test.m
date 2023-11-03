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
        x1=polarEnc(msg,N,p);%编码后的比特序列
        x11=bpsk(x1);%发送比特序列
        y=awgn(x11,N,sigma(n));%加入噪声后的接收比特序列
        ecode=lfsr_encoder(msg,N,K);%完成编码
        n_code=noise_code(ecode,EbN0(n),frame(n));%添加噪声
        rber_num=error_count(y,msg);
        rber_bit(n)=rber_bit(n)+rber_num;
        [uyima,soft] = polarDecBP(msg,y,p,sigma(n));
        [~,uyima1]=BCHdecoder(n_code,ecode);%译码器
        errbits=length(find(uyima(1,:)~=msg));%译码后序列和信息序列不同bit的长度
        if errbits~=0
            errblock=1;
            erframe=erframe+1;
            uyima2 = ASOL(soft,L,y,p,sigma(n),msg);
        else
            uyima2 = uyima;
            errblock=0;
        end
        errbits1=length(find(uyima1~=ecode));%译码后序列和信息序列不同bit的长度
        if errbits1~=0
            errblock1=1;
            erframe1=erframe1+1;
        else
            errblock1=0;
        end
        errbits2=length(find(uyima2(1,:)~=msg));%译码后序列和信息序列不同bit的长度
        if errbits2~=0
            errblock2=1;
            erframe2=erframe2+1;
        else
            errblock2=0;
        end
        err_ber(n)=errbits+err_ber(n);%err用于统计当前的错误bit总个数
        err_bler(n)=errblock+err_bler(n);%统计误块个数
        err_ber1(n)=errbits1+err_ber1(n);%err用于统计当前的错误bit总个数
        err_bler1(n)=errblock1+err_bler1(n);%统计误块个数
        err_ber2(n)=errbits2+err_ber2(n);%err用于统计当前的错误bit总个数
        err_bler2(n)=errblock2+err_bler2(n);%统计误块个数
    end
    errorrate_ber(n)=err_ber(n)./(length(x1)*frame(n));%计算误码率
    errorrate_bler(n)=err_bler(n)./frame(n);%计算误块率
    errorrate_ber1(n)=err_ber1(n)./(length(x1)*frame(n));%计算误码率
    errorrate_bler1(n)=err_bler1(n)./frame(n);%计算误块率
    errorrate_ber2(n)=err_ber2(n)./(length(x1)*frame(n));%计算误码率
    errorrate_bler2(n)=err_bler2(n)./frame(n);%计算误块率
    rber(n)=rber_bit(n)./(frame(n)*N);
end
figure;semilogy(r_ber,errorrate_ber,'-ro',r_ber,errorrate_ber1,'--k+',r_ber,errorrate_ber2,':bs');grid on;
legend('SCAN','BCH','ISOL');
xlabel('RBER');
ylabel('BER');
grid on;




