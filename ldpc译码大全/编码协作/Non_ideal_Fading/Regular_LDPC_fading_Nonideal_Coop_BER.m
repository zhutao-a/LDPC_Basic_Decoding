
% Regular LDPC codes over Raleigh fading channels vith M=500,N=1000,M2=500
%dv1=3,dc1=6,dv2=3.dc2=9
% stand BP    
%%%  Note: every frame the relay should decode and re-encode

clc; 
clear all;
format long;



%%%%  matrice for encoding and decoding 
load('Hc1'); 
load('Hc2');
load('Hd1');
load('H');  % joint matrix
[M,N] = size(Hc1);% M=256,N=768,M1=256,N1=1024
[M1,N1] = size(Hc2);

%% S encoding  u
dSource1 = round(rand(N-M,1));
c1 = zeros(M,1);
for t = 1:M
    sum1 = Hc1(t,1:N-M)*dSource1;
    c1(t) = mod(sum1,2);
    sum1 = 0;
end %t
u = [dSource1;c1];
EbN0 = [0 5 10 15 20];
% Number of iteration;
iter = 10;
% Number of frame (N bits per frame)
frame = 10;%20000
bpskSD = 2*u - 1;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% detect
 for i = 1:length(EbN0)
     ber1(i) = 0;
     ber10(i) = 0;
   for j = 1:frame
    %%%%%%%%%%%%%%%%%%  R   decoding  %%%%%%%%%%%%%%%%
     EbN0_r = 50;%%%%%% S-R信噪比
     iter_r = 10;
     N0_r = 1/(10^(EbN0_r/10));
     nosr = wgn(1,N,N0_r,'linear','complex');
     bpskSR = 2*u - 1;
     ray_SR = wgn(1,1,0,'dBW','complex');
     C_SR = ray_SR';
     rs = ray_SR*bpskSR'+nosr;
     txs = C_SR*rs;
     txs=real(txs);
     txs = txs./(N0_r/2);
     ur = Relay_decodeProbDomain(txs, Hd1, iter_r);
     ur = ur';
    %% R re-encoding u2
     c2 = zeros(M1,1);
     for t = 1:M1
         sum2 = Hc2(t,1:N)*ur;
         c2(t) = mod(sum2,2);
         sum2 = 0;
     end
     u2 = [u;c2];
     bpskRD = 2*c2 - 1;
     
       
      
      ray_H = wgn(1,1,0,'dBW','complex'); 
      ray_Hr = wgn(1,1,0,'dBW','complex');  
      C1 = ray_H';
      C2 = ray_Hr';
      N0 = 1/(10^(EbN0(i)/10)); %%%%% 不考虑码率
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
     % tx = tx';% for Min-Sum
      tx = tx./(N0/2); % for Standard BP , complex noise
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Joint iterative decoding

    %[vhat1,vhat10] = decodeLogDomainSimple(tx, H, iter);%Min Sum
     [vhat1,vhat10] = decodeProbDomain(tx, H, iter);%% Standard BP
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
legend('Nonideal Coop,20dB, iter=1','Nonideal Coop,20dB,iter=10',2);

