clear;
%load encode_in.mat;
generate_h;
m=252;
n=756;
%s=round(rand(1,504));
encode;              
for i=0:755
    encode_out(1,(i+1))=0.001*i;
end
for i=0:755
    if xyuan(1,(i+1))>0.5
        encode_out(2,(i+1))=-1;
    else encode_out(2,(i+1))=1;
    end
end
%save encode_out encode_out
snr=1;
ryuan(1,:)=encode_out(1,:);
outx1=encode_out;
%ryuan(1,1:756)=awgn(xyuan(1,1:756),10^(snr/10));
ryuan(2,6:761)=awgn(encode_out(2,:),1);