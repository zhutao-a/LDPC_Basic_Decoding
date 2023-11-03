x=1:10;
encode_out(1,:) = 1:10;
ryuan(1,1:10)=awgn(encode_out(1,:),100);%后面的数字越大，性能越好
plot(x,encode_out(1,:))
hold on
plot(x,ryuan(1,1:10),'y-')
grid on