%%%%
%%%% joint design RA codes
   % energy harvesting at the relay with muti-antennuas
   % optimal antennuas selection at the relay
   % dsr,dsd, drd are unified as dsd=2
%%%% revised by Shunwai Zhang   Jan 18th, 2016;   Feb 26th, 2016

clc; 
clear all;
format long;

%M = 600; 
%N = 800;
g = 1;   %效率
d = 1;   %即S-D的距离是R-D距离的d倍，那么功率衰减为d^2，但接受表达式为d
Ant = 1; % number of antenna at the relay

% EbN0 in dB
EbN0 = [0 5 10 15 20 25];

% Number of iteration;
iter = 10;

% Number of frame (N bits per frame)
frame = 10000;

%%%
load('HJ');  %%%%    [A D 0; B 0 D]
%%   encoding
M = 200;
N = 600;
dSource = round(rand(M, 1)); %信源信息位 200
c = zeros(N,1);  % 产生校验位600位（200+400）
dS = dSource;
for t = 1:N
    sum1 = HJ(t,1:M+t-1)*dS;
    c(t) = mod(sum1,2);
    dS = [dS;c(t)];
end %t
u = [dSource;c];
c1 = c(1:M);
c2 = c(M+1:N);
u1 = [dSource;c1];
u2 = c2;
%%
bpskSD = 2*u - 1;

 for i = 1:length(EbN0)
     ber1(i) = 0;    % BER var iter
     ber10(i) = 0;
   for j = 1:frame
 %%%%%%%%%%%%%%%%%%%%%%%% S-D channel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
        ray_H = wgn(1,1,0,'dBW','complex');  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  S-D detect
      C = ray_H';%%%%%%% Perfect CSI
      N0 = 1/(10^(EbN0(i)/10));
      nos = wgn(1,N+M,N0,'linear','complex');
      r = ray_H/2*bpskSD'+nos;   % sd=2,sr=rd=1
      tx1 = C*r;
      tx1 = conj(tx1'); 
      tx1=real(tx1);%取实部作为译码器的输入信号
 
      [vhat1,vhat10] = decodeLogDomainSimple(tx1, HJ, iter);%Min Sum

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


