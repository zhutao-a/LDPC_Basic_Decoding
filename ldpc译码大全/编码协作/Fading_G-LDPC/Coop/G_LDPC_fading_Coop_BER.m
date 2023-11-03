
% Regular LDPC codes over Raleigh fading channels vith M=500,N=1000,M2=500
%dv1=3,dc1=6,dv2=3.dc2=9
% stand BP
clc; 
clear all;
format long;



%%%%  matrice for encoding and decoding 
load('H1'); 
load('H2');
load('H');  % joint matrix
[M,N] = size(H1);% M=500,N=100;M1=500,N1=1500
[M1,N1] = size(H2);

%% S encoding  u
dSource1 = round(rand(N-M,1));
c1 = zeros(M,1);
for t = 1:M
    sum1 = H1(t,1:N-M)*dSource1;
    c1(t) = mod(sum1,2);
    sum1 = 0;
end %t
u = [dSource1;c1];
%% R encoding u2
c2 = zeros(M1,1);
for t = 1:M1
    sum2 = H2(t,1:N1-M1)*dSource1;% only information bits
    c2(t) = mod(sum2,2);
    sum2 = 0;
end
u2 = [u;c2];


EbN0 = [0 5 10 15 20];
% Number of iteration;
iter = 10;
% Number of frame (N bits per frame)
frame = 2;
 

bpskSD = 2*u - 1;
bpskRD = 2*c2 - 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% detect
 for i = 1:length(EbN0)
     ber1(i) = 0;
     ber10(i) = 0;
   for j = 1:frame
       
      
      ray_H = wgn(1,1,0,'dBW','complex'); 
      ray_Hr = wgn(1,1,0,'dBW','complex');  
      C1 = ray_H';
      C2 = ray_Hr';
      N0 = 1/(10^(EbN0(i)/10)); %%%%% ²»¿¼ÂÇÂëÂÊ
      N0r = 1/(10^((EbN0(i))/10));  %
      
      nos1 = wgn(1,N,N0,'linear','complex');
      r1 = ray_H*bpskSD'+nos1;
      tx1 = C1*r1;
      tx1=real(tx1);%achieve the real part as decoder input IN ROW
      nos2 = wgn(1,M,N0r,'linear','complex');
      r2 = ray_Hr*bpskRD'+nos2;
      tx2 = C2*r2;
      tx2=real(tx2);%achieve the real part as decoder input IN ROW
      
      tx = [tx1 tx2];
      tx = tx';% for Min-Sum
     % tx = tx./(N0/2); % for Standard BP , complex noise
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Joint iterative decoding

    [vhat1,vhat10] = decodeLogDomainSimple(tx, H, iter);%Min Sum
    % [vhat1,vhat10] = decodeProbDomain(tx, H, iter);%% Standard BP
 % calculate the BER of information bits
      [num1, rat1] = biterr(vhat1, u2');
      ber1(i) = (ber1(i) + rat1);
     [num10, rat10] = biterr(vhat10, u2');
      ber10(i) = (ber10(i) + rat10);
   end % for j
    
   % Get average of BER
   ber1(i) = ber1(i)/frame;
   ber10(i) = ber10(i)/frame;
   ber1(i),
   ber10(i),
   save ber1.mat ber1;
   save ber10.mat ber10;
   
end % for i 
ber1,
ber10,


% Plot the result
figure(1);
semilogy(EbN0, ber1, '-ko',EbN0, ber10, '-kd');
xlabel('SNR (dB)');
ylabel('BER');
legend('G_LDPC_fading_Coop, iter=1','G_LDPC_fading_Coop,iter=10');

