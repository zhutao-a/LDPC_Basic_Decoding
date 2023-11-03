% Bit error rate of BPSK modulated LDPC codes under block Rayleigh fading
% channels with Multi-antenues 
%Perfect CSI
% Q-D-Matrix(Inovation)
% iter = 10
% RD_SNR = SD_SNR
%%%% revised by Shunwai Zhang   May 30th, 2012

clc; 
clear all;
format long;

M = 400;
N = 600;
g = 1;   %效率
a = 0;   %用于信息译码的功率比例
d = 2;   %即S-D的距离是R-D距离的d倍,即S-D=2，R-D=1
Ant = 1; % number of antenna

% EbN0 in dB
EbN0 = [5 10 15 20 25 30];

% Number of iteration;
iter = 10;

% Number of frame (N bits per frame)
frame = 10000;

%%%
load('HJ');  %%%%    [A D 0; B 0 D]
%%   encoding
dSource = round(rand(N-M, 1));
c = zeros(M,1);
dS = dSource;
for t = 1:M
    sum1 = HJ(t,1:N-M+t-1)*dS;
    c(t) = mod(sum1,2);
    dS = [dS;c(t)];
end %t
u = [dSource;c];
c1 = c(1:M/2);
c2 = c(M/2+1:M);
u1 = [dSource;c1];
u2 = c2;
%%
bpskSD = 2*u1 - 1;
bpskRD = 2*u2 - 1;
 for i = 1:length(EbN0)
     ber1(i) = 0;    % BER var iter
     ber10(i) = 0;
   for j = 1:frame
 %%%%%%%%%%%%%%%%%%%%%%%% S-D channel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
        ray_H = wgn(Ant,1,0,'dBW','complex');  
%%%%%%%%%%%%%%%%%%%%%%  R-D channel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ray_Hr = wgn(Ant,1,0,'dBW','complex');  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hsr = wgn(Ant,1,0,'dBW','complex');
        Hs = Hsr'*Hsr;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  S-D detect
      C = ray_H';%%%%%%% Perfect CSI
      N0 = 1/(10^(EbN0(i)/10));
      nos = wgn(Ant,M,N0,'linear','complex');
      r = ray_H*bpskSD'/d + nos;  % s-d = 2, r-d = 1
      tx1 = C*r;
      tx1 = conj(tx1'); 
      tx1=real(tx1);%取实部作为译码器的输入信号
 %%%%  R-D detect     
      C = ray_Hr';  
      nos = wgn(Ant,M/2,N0,'linear','complex');
   
      tx2 = sqrt(Hs*g*(1-a))*C*ray_Hr*bpskRD' + C*nos; % d1 = 2d2 = 1
      tx2 = conj(tx2'); 
      tx2=real(tx2);%acquire real part
     
%%%   joint iterative decoding      
      tx = [tx1;tx2];
      [vhat1,vhat10] = decodeLogDomainSimple(tx, HJ, iter);%Min Sum

      [num1, rat1] = biterr(vhat1', u);
      ber1(i) = (ber1(i) + rat1);
      [num10, rat10] = biterr(vhat10', u);
      ber10(i) = (ber10(i) + rat10);
      
      
   end % for j
    
   % Get average of BER
   ber1(i) = ber1(i)/frame;
   ber10(i) = ber10(i)/frame;
   
end % for i 
ber1,
ber10,
save ber1.mat ber1;
save ber10.mat ber10;

% Plot the result
figure(1);
semilogy(EbN0, ber1, '-ko',EbN0, ber10, '-kd');
xlabel('SNR (dB)');
ylabel('BER');
legend('iter=1','iter=10',2);


