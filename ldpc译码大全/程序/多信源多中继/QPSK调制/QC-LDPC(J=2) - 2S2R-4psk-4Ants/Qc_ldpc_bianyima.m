clc;
clear all;
format long;

[H,p,J,L]=girth8_8_8();
[M,N] = size(H);
H1=H(1:(M/4),1:(N/2));
H2=H(((M/4)+1):(M/2),((N/2)+1):N);
A=H(((M/2)+1):(3*M/4),1:(N/2));
B=H(((M/2)+1):(3*M/4),((N/2)+1):N);
C=H(((3*M/4)+1):M,1:(N/2));
D=H(((3*M/4)+1):M,((N/2)+1):N);
[M1,N1] = size(H1);
[M2,N2] = size(H2);
 I = eye(M1);
 O1= zeros(M1,N1);
 O2= zeros(M1);
  ant = 4;% tianxianshu
%% S1 encoding 
L1=L/2;
J1=J/4;
for i=1:(L1*p-J1*p)              %随机生成码长为(n-m)的信息比特位
 s(1,i)=round(rand(1));
end  %%%随机产生最开始传入的原始信息比特，比特位长不能随意
s1=s';
%  a=size(s1)
[W1]=HuQC(H1,p,J1,L1,s);
W1=W1';
%  b=size(W1)
c1= mod(W1*s1,2);
u1 = [s1;c1];
%  c=size(u1)
z = mod(H1*u1,2);
if length(find(z)) == 0
    disp('S1 encoded');
end
%% S2 encoding
L2=L/2;
J2=J/4;
for i=1:(L2*p-J2*p)              %随机生成码长为(n-m)的信息比特位
 s(1,i)=round(rand(1));
end  %%%随机产生最开始传入的原始信息比特，比特位长不能随意
s2=s';
% a=size(s1)
[W2]=HuQC(H2,p,J2,L2,s);
W2=W2';
c2= mod(W2*s2,2);
u2 = [s2;c2];
z = mod(H2*u2,2);
if length(find(z)) == 0
    disp('S2 encoded');
end
%% R1 encoding
 u=[u1;u2];
 Hr1=[A B I];
 [M3,N3]=size(Hr1);
cr1 = zeros(M3,1);
for t = 1:M2
    sum2 = Hr1(t,1:N3-M3)*u;
    cr1(t) = mod(sum2,2);
    sum2 = 0;
end
 ur1=[u;cr1];
z = mod(Hr1*ur1,2);
if length(find(z)) == 0
    disp('R1 encoded');
else
    disp('wrong encoded');
end
%% R2 encoding
 u=[u1;u2];
 Hr2=[C D I];
 [M4,N4]=size(Hr2);
cr2 = zeros(M4,1);
for t = 1:M2
    sum2 = Hr2(t,1:N4-M4)*u;
    cr2(t) = mod(sum2,2);
    sum2 = 0;
end
 ur2=[u;cr2];
z = mod(Hr2*ur2,2);
if length(find(z)) == 0
    disp('R2 encoded');
else
    disp('wrong encoded');
end
%% Jointly encoding
  HD=[H1 O1 O2 O2;O1 H2 O2 O2;A B I O2;C D O2 I];
%    dd=size(HD)
  ud =[u1;u2;cr1;cr2];
%    uu=size(ud)
z = mod(HD*ud,2);
if length(find(z)) == 0
    disp('Jointly encoded');
else
    disp('Wrong encoder');
end

%% transmitting
Eb_N0= 0:5:25;
iter=10;
frame=1000;

qpskS1D=(2*u1-1)/sqrt(2);
qpskS2D=(2*u2-1)/sqrt(2);
qpskR1D=(2*cr1-1)/sqrt(2);
qpskR2D=(2*cr2-1)/sqrt(2);

for i=1:length(Eb_N0)
%    sigma_2=1/(2*(10^(Eb_N0(i)/10))*R);
    ber1(i)=0;
    ber5(i)=0;
    ber10(i)=0;
    for j=1:frame
        
        ray_H1 = wgn(ant,1,0,'dBW','complex'); 
        ray_H2 = wgn(ant,1,0,'dBW','complex'); 
        ray_Hr1 = wgn(ant,1,0,'dBW','complex');
        ray_Hr2 = wgn(ant,1,0,'dBW','complex');
        C1 = ray_H1';
        C2 = ray_H2';
        C3 = ray_Hr1';
        C4 = ray_Hr2';
        
        N0  = 1/(10^(Eb_N0(i)/10));
        N0r = 1/(10^((Eb_N0(i))/10));
        
        nos1=wgn(ant,N1,N0,'linear','complex');
        r1=ray_H1*qpskS1D'+nos1;
        tx1 = C1*r1;
        tx1=real(tx1);
        
        nos2=wgn(ant,N2,N0,'linear','complex');
        r2=ray_H2*qpskS2D'+nos2;
        tx2 = C2*r2;
        tx2=real(tx2);
        
        nos3 = wgn(ant,M3,N0r,'linear','complex');
        r3 =ray_Hr1*qpskR1D'+nos3;
        tx3=C3*r3;
        tx3=real(tx3);
        
        nos4 = wgn(ant,M4,N0r,'linear','complex');
        r4 =ray_Hr2*qpskR2D'+nos4;
        tx4=C4*r4;
        tx4=real(tx4);
        
        tx=[tx1 tx2 tx3 tx4];
%        tx = tx./(N0/2);
        tx=tx';
%         qq=size(tx)
%        [vhat1,vhat10] = decodeProbDomain(tx, H, iter);
        [vhat1,vhat5,vhat10] = decodeLogDomainSimple(tx, HD, iter);
        [num1, rat1] = biterr(vhat1, ud');
        ber1(i) = (ber1(i) + rat1);
        [num5, rat5] = biterr(vhat5, ud');
        ber5(i) = (ber5(i) + rat5);
        [num10, rat10] = biterr(vhat10, ud');
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

% semilogy(Eb_N0,BER,'o-');
semilogy(Eb_N0, ber1, '-ko',Eb_N0, ber5, '-ks',Eb_N0, ber10, '-kd');
xlabel('SNR (dB)');
ylabel('BER');
legend('Jointly QC-LDPC iter=1','Jointly QC-LDPC iter=5','Jointly QC-LDPC iter=10',3);
grid on;
hold off;
