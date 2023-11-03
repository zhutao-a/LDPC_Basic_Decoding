 x=[1.5:0.2:2.5];
%P2P&&COOP
%y1=[0.112675199999999	0.0431386000000001	0.0143354000000000	0.00458020000000001	0.00164700000000000	0.000362200000000000];
%y2=[0.0914019999999999	0.0281602222222220	0.00879622222222226	0.00289677777777779	0.000871222222222222	0.000237444444444444];
%y3=[0.102534000000000	0.0375792000000000	0.0120864000000000	0.00380940000000000	0.00142380000000000	0.000287200000000000];
%y4=[0.0593692222222222	0.0133488888888889	0.00375211111111111	0.00121200000000000	0.000387333333333333	0.00010642942222333333];

%AWGN
%y1=[0.050606666666666   0.037901333333334   0.027708444444444   0.020072222222222   0.014235666666667   0.009781444444445];
%y2=[0.008416333333333   0.004428111111111   0.002221000000000   0.000984111111111   0.000478555555556   0.000219777777778];
%y3=[0.004416333333333   0.002428111111111   0.001221000000000   0.000584111111111   0.000278555555556   0.000119777777778];
%REY
%y1=[0.102534000000000	0.0375792000000000	0.0120864000000000	0.00380940000000000	0.00142380000000000	0.000287200000000000];
%y2=[0.0914019999999999	0.0281602222222220	0.00879622222222226	0.00289677777777779	0.000871222222222222	0.000237444444444444];
%y3=[0.0593692222222222	0.0133488888888889	0.00375211111111111	0.00121200000000000	0.000387333333333333	0.00010642942222333333];

%MS-BP-DBP
y1=[2.53317797129891e-05,1.24215338427948e-05,6.74027740907884e-06,3.16509115462525e-06,1.81441311719077e-06,0.82251166407465e-06];
y2=[1.55503582802548e-05,7.80790711346267e-06,3.64709478832855e-06,1.66791204099061e-06,5.92890669527609e-07,1.90670276200526e-07];
y3 = [6.56919366259515e-06	2.57682986290369e-06	9.90390237647461e-07	4.26824072936593e-07	1.55532275494259e-07	5.75965662013790e-08];

 figure(gcf)
 semilogy(x,y1,'-ks',x,y2,'-k+',x,y3,'-kd');
 xlabel('SNR (dB)');
 ylabel('BER');
 %title('编码协作系统中不同译码算法的性能比较');
 legend('MS','BP','DBP(proposed)');
 hold on;
 hold off;