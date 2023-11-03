%load carrier_demod_out.mat;
%load matrix_h.mat;
% main_encode;

clear;



generate_h;

%m=252;
%n=756;
%s=round(rand(1,504));
%encode;              
for i=0:(n-1)
    encode_out(1,(i+1))=0.001*i;
end
for i=0:(n-1)
    if xyuan(1,(i+1))>0.5
        encode_out(2,(i+1))=-1;
    else encode_out(2,(i+1))=1;
    end
end
%save encode_out encode_out
ryuan(1,:)=encode_out(1,:);
outx1=encode_out;
%ryuan(1,1:756)=awgn(xyuan(1,1:756),10^(snr/10));
err=zeros(1,7);
snr=[1:0.5:4]
for z=1:7
    
ryuan(2,1+5:n+5)=awgn(encode_out(2,:),snr(z));

% snr=1;%db
%xxw=504;
%m=252;
%n=756;
Es=2;
r=2/3;
M=1;
Eb=Es/(r*M);
liezhong=j;
hangzhong=k;


sigma=sqrt(Eb/(3*10^(snr(z)/10)));

hanglieH=size(H);
hangH=hanglieH(1);
lieH=hanglieH(2);
ncol=zeros(liezhong,lieH);
nrow=zeros(hangH,hangzhong);

lie1wei=find(H);
for a=1:lieH
    for b=1:liezhong
        ncol(b,a)=(lie1wei((a-1)*liezhong+b)-(a-1)*hangH);
    end
end

hang1wei=find(H');
for a=1:hangH
    for b=1:hangzhong
        nrow(a,b)=(hang1wei((a-1)*hangzhong+b)-(a-1)*lieH);
    end
end


%xyuan=x;
quweishu=5;
demodz(1,:)=ryuan(2,(quweishu+1):(quweishu+n));

decode;

for i=1:n
    if demodz(1,i)>0
        demodz(1,i)=0;
    else demodz(1,i)=1;
    end
end

derr=0;
for i=1:n
    if demodz(1,i)~=xyuan(1,i)
        derr=derr+1;
    end
end


for i=1:n
    if decoded(1,i)~=xyuan(1,i)
        err(z)=err(z)+1;
    end
end

end



semilogy(snr,err/(n-m))
hold on
semilogy(snr,err/(n-m),'*')
grid on
%derr
xlabel('Eb/No(db)')
ylabel('BER')

decode_out=decoded(1,1:(n-m));
save decode_out decode_out


