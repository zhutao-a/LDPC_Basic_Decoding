clc;
clear all;
format long;

[H,p,J,L]=girth8_3_5();
[M,N] = size(H);
% H1=H(1:(M/3),1:(N/2));
% H2=H(((M/3)+1):(2*M/3),((N/2)+1):N);
% A=H(((2*M/3)+1):M,1:(N/2));
% B=H(((2*M/3)+1):M,((N/2)+1):N);
% [M1,N1] = size(H1);
% [M2,N2] = size(H2);
%  I = eye(M1);
%  O1= zeros(M1,N1);
%  O2= zeros(M1);
%% S1 encoding 
L1=L;
J1=J;
for i=1:(L1*p-J1*p)              %随机生成码长为(n-m)的信息比特位
 s(1,i)=round(rand(1));
end  %%%随机产生最开始传入的原始信息比特，比特位长不能随意
s1=s';
%  a=size(s1)
[W1]=HuQC(H,p,J1,L1,s);
W1=W1';
%  b=size(W1)
c1= mod(W1*s1,2);
u1 = [s1;c1];
%  c=size(u1)
z = mod(H*u1,2);
if length(find(z)) == 0
    disp('S1 encoded');
end
%% S2 encoding
% L2=L/2;
% J2=J/3;
% for i=1:(L2*p-J2*p)              %随机生成码长为(n-m)的信息比特位
%  s(1,i)=round(rand(1));
% end  %%%随机产生最开始传入的原始信息比特，比特位长不能随意
% s2=s';
% % a=size(s1)
% [W2]=HuQC(H2,p,J2,L2,s);
% W2=W2';
% c2= mod(W2*s2,2);
% u2 = [s2;c2];
% z = mod(H2*u2,2);
% if length(find(z)) == 0
%     disp('S2 encoded');
% end
% %% R encoding
%  u=[u1;u2];
%  Hr=[A B I];
%  [M3,N3]=size(Hr);
% cr = zeros(M3,1);
% for t = 1:M2
%     sum2 = Hr(t,1:N3-M3)*u;
%     cr(t) = mod(sum2,2);
%     sum2 = 0;
% end
%  ur=[u;cr];
% z = mod(Hr*ur,2);
% if length(find(z)) == 0
%     disp('R encoded');
% else
%     disp('wrong encoded');
% end
% %% Jointly encoding
% HD=[H1 O1 O2;O1 H2 O2;A B I];
% %    dd=size(HD)
%   ud =[u1;u2;cr];
% %    uu=size(ud)
% z = mod(HD*ud,2);
% if length(find(z)) == 0
%     disp('Jointly encoded');
% else
%     disp('Wrong encoder');
% end
%% transmitting
Eb_N0= -2:0.5:1.5;
iter=10;
frame=4000;

bpskS1D=2*u1-1;
% bpskS2D=2*u2-1;
% bpskRD=2*cr-1;

for i=1:length(Eb_N0)
   % sigma_2=1/(2*(10^(Eb_N0(i)/10))*R);
    ber1(i)=0;
    ber5(i)=0;
    ber10(i)=0;
    for j=1:frame
        N0=1/(10^(Eb_N0(i)/10));
        N0r = 1/(10^((Eb_N0(i)+1)/10));
        nos=wgn(1,N,N0,'linear','complex');
        r1=bpskS1D'+nos;
        tx1=real(r1);
%         nos1=wgn(1,N2,N0,'linear','complex');
%         r2=bpskS2D'+nos1;
%         tx2=real(r2);
%         nos2 = wgn(1,M3,N0r,'linear','complex');
%         r3 = bpskRD'+nos2;
%         tx3=real(r3);
%         tx=[tx1 tx2 tx3];
       %tx = tx./(N0/2);
        tx=tx1';          %mins--um
%         qq=size(tx)
      % [vhat1,vhat10] = decodeProbDomain(tx, H, iter);
        [vhat1,vhat5,vhat10] = decodeLogDomainSimple(tx, H, iter);
        [num1, rat1] = biterr(vhat1, u1');
        ber1(i) = (ber1(i) + rat1);
        [num5, rat5] = biterr(vhat5, u1');
        ber5(i) = (ber5(i) + rat5);
        [num10, rat10] = biterr(vhat10, u1');
        ber10(i) = (ber10(i) + rat10);
  end %for j
   ber1(i) = ber1(i)/frame;
   ber5(i) = ber5(i)/frame;
   ber10(i) = ber10(i)/frame;
   ber1(i),
   ber5(i),
   ber10(i),
   save ber1.mat ber1;
   save ber5.mat ber5;
   save ber10.mat ber10;
 end % for i
% 
% semilogy(Eb_N0,BER,'o-');
semilogy(Eb_N0, ber1, '-ko',Eb_N0, ber5, '-k+',Eb_N0, ber10, '-ks');
%semilogy(Eb_N0, ber1, '-ro',Eb_N0, ber10, '-rs');
%semilogy(Eb_N0, ber1, '-bo',Eb_N0, ber10, '-bs');
title('编码协作系统中不同译码算法性能比较');
xlabel('SNR (dB)');
ylabel('BER');
%legend('G-LDPC-Bp-iter=1','G-LDPC-Bp-iter=10','G-LDPC-MS-iter=1','G-LDPC-MS-iter=10','G-LDPC-Normalized-Bp-Based-iter=1','G-LDPC-Normalized-Bp-Based-iter=10');
grid on;
hold on;
hold off;
