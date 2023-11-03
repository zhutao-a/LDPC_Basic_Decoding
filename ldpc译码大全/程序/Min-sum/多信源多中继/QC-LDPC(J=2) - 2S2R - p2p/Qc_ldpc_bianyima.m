clc;
clear all;
format long;

[H,p,J,L]=girth8_6_9();
[M1,N1] = size(H);
% H1=H(1:(M/4),1:(N/2));
% H2=H(((M/4)+1):(M/2),((N/2)+1):N);
% A=H(((M/2)+1):(3*M/4),1:(N/2));
% B=H(((M/2)+1):(3*M/4),((N/2)+1):N);
% C=H(((3*M/4)+1):M,1:(N/2));
% D=H(((3*M/4)+1):M,((N/2)+1):N);
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
%% Jointly encoding
  HD = H;
  ud = u1;
% z = mod(HD*ud,2);
% if length(find(z)) == 0
%     disp('Jointly encoded');
% else
%     disp('Wrong encoder');
% end
%% transmitting
Eb_N0= 0:5:25;
iter=10;
frame=1;
bpskS1D=2*u1-1;
for i=1:length(Eb_N0)
%    sigma_2=1/(2*(10^(Eb_N0(i)/10))*R);
    ber1(i)=0;
    ber5(i)=0;
    ber10(i)=0;
    for j=1:frame
        
        ray_H1 = wgn(1,1,0,'dBW','complex'); 
        C1 = ray_H1';
        
        N0  = 1/(10^(Eb_N0(i)/10));
        N0r = 1/(10^((Eb_N0(i)+1)/10));
        
        nos1=wgn(1,N1,N0,'linear','complex');
        r1=ray_H1*bpskS1D'+nos1;
        tx1 = C1*r1;
        tx1=real(tx1);
        
        tx=[tx1];
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
legend('p2p QC-LDPC iter=1','p2p QC-LDPC iter=5','p2p QC-LDPC iter=10',3);
grid on;
hold off;
