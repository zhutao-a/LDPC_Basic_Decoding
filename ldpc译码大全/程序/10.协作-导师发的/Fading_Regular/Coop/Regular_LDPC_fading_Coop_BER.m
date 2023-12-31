
% Regular LDPC codes over Raleigh fading channels vith M=500,N=1000,M2=500
%dv1=3,dc1=6,dv2=3.dc2=9
% stand BP
clc; 
clear all;
format long;



%%%%  matrice for encoding and decoding 
load('Hc1'); 
load('Hc2');
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
%% R encoding u2
c2 = zeros(M1,1);
for t = 1:M1
    sum2 = Hc2(t,1:N)*u;
    c2(t) = mod(sum2,2);
    sum2 = 0;
end
u2 = [u;c2];


%EbN0 = [0 5 10 15 20];
EbN0 = [1 1.5 2 2.5 3 3.5];
% Number of iteration;
iter = 10;
% Number of frame (N bits per frame)
frame = 1;
 

bpskSD = 2*u - 1;
bpskRD = 2*c2 - 1;%%%%%%%%%%%%%%%%%非协作系统里面没有中继的概念%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% detect
 for i = 1:length(EbN0)
     ber1(i) = 0;
     ber10(i) = 0;
   for j = 1:frame
       
      
  %    ray_H = wgn(1,1,0,'dBW','complex'); 
  %    ray_Hr = wgn(1,1,0,'dBW','complex');  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Hr代表中继的，所有R和r都是中继的，协作系统才有%%%%%%%%%%%%%%%%%%%%
 %     C1 = ray_H';
 %     C2 = ray_Hr';
      N0 = 1/(10^(EbN0(i)/10)); %%%%% 不考虑码率
      N0r = 1/(10^((EbN0(i))/10));  %
      
      nos1 = wgn(1,N,N0,'linear','complex');
      r1 = bpskSD'+nos1;
      tx1 = r1;
      tx1=real(tx1);%achieve the real part as decoder input IN ROW
      nos2 = wgn(1,M,N0r,'linear','complex');
      r2 = bpskRD'+nos2;
      tx2 = r2;
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
semilogy(EbN0, ber1, '-ko',EbN0, ber10, '-k+');
xlabel('SNR (dB)');
ylabel('BER');
%h=legend('Coop-G-LDPC-Hybird C-V','Coop-G-LDPC-NMS的改进''Coop-G-LDPC-NMS(a=0.8)');
legend('Coop Regular LDPC-Hybird C-V, iter=1','Coop Regular LDPC-Hybird C-V, iter=10');
hold on;
hold off;

