% Bit error rate of BPSK modulated LDPC codes under AWGN channel
%
%
% Copyright Bagawan S. Nugroho, 2007 
% http://bsnugroho.googlepages.com

clc; 
clear all;

% LDPC matrix size, rate must be 1/2
% Warning: encoding - decoding can be very long for large LDPC matrix!
M =  600;
N =  1200;

% Method for creating LDPC matrix (0 = Evencol; 1 = Evenboth)
method = 1;

% Eliminate length-4 cycle
noCycle = 1;

%bit rate R
R=1/2;

% Number of 1s per column for LDPC matrix
onePerCol = 3;

% LDPC matrix reorder strategy (0 = First; 1 = Mincol; 2 = Minprod)
strategy = 2;

% EbN0 in dB
EbN0_dB = -2:0.5:1.5;

% Number of iteration;
iter =10;

% Number of frame (N bits per frame)
frame = 1;

% Make the LDPC matrix
H = makeLdpc(M, N, 1, 1, onePerCol);


   
for i = 1:length(EbN0_dB)
   
      ber1(i) = 0;
      ber2(i) = 0;
      ber3(i) = 0;
      ber4(i) = 0;
%       ber5(i) = 0;
      
   % Make random data (0/1)
   dSource = round(rand(M, frame));
   
   for j = 1:frame
      fprintf('Frame : %d\n', j);
      
      % Encoding message
      [c, newH] = makeParityChk(dSource(:, j), H, strategy);
      u = [c; dSource(:, j)];

      % BPSK modulation
      %bpskMod = 2*u - 1;
      bpskMod = (-1).^u;
      % Additional white gaussian noise
      %N0 = 1/(exp(EbN0(i)*log(10)/10));
      EbN0 = 10^(EbN0_dB(i)/10);    % 比特信噪比，十进制表示
      SNR = EbN0_dB(i)+10*log10(R)-10*log10(0.5);  %比特信噪比换算成高斯信道中的SNR
      N0= 1/(2*R*EbN0);   % 求出方差值
      tx = awgn(bpskMod,SNR,'measured');    % AWGN信道加噪
       
     % tx = bpskMod + sqrt(N0/2)*randn(size(bpskMod));

      % Decoding (select decoding method)
     
      vhat1 = decode_SPA(tx, newH, N0, iter);
    %  vhat2 = decode_MS(tx, newH, iter);
   %   vhat3 = decode_OMS(tx, newH, iter);
   %   vhat4 = decode_NMS(tx, newH, iter);
%       vhat5= decode_ANOMS(tx, newH, iter);
    
   
      % Get bit error rate (for brevity, BER calculation includes parity bits)
      [num1, rat1] = biterr(vhat1', u);
      ber1(i) = (ber1(i) + rat1);
      
  %    [num2, rat2] = biterr(vhat2', u);
  %    ber2(i) = (ber2(i) + rat2);
      
    %  [num3, rat3] = biterr(vhat3', u);
    %  ber3(i) = (ber3(i) + rat3);
      
    %  [num4, rat4] = biterr(vhat4', u);
   %   ber4(i) = (ber4(i) + rat4);
     
%       [num5, rat5] = biterr(vhat5', u);
%       ber5(i) = (ber5(i) + rat5);
      
   end % for j
   
   % Get average of BER
   ber1(i) = ber1(i)/frame;
   ber2(i) = ber2(i)/frame;
   ber3(i) = ber3(i)/frame;
   ber4(i) = ber4(i)/frame;
%    ber5(i) = ber5(i)/frame;
   
end % for i

% Plot the result
%h=legend('Sum-product','Min-sum','offset min-sum(offset factor 0.2)','nomalize min-sum(nomalize factor 0.8)');   %,'Adaptive Nomolize- offset min-sum',1
%h=legend('Nomalize Bp-based(factor=0.8)','Hybird C-V Processing(factor=0.8)');
%h=legend('码长512-码率1/2','码长1024-码率1/2','码长2048-码率1/2');
%h=legend('Hybird C-V Processing(a=0.8,r=0.8)','Hybird C-V Processing(r=0.8)','Hybird C-V Processing(a=0.8)')
%h=legend('Min-sum','offset min-sum','normalized min-sum');
%h=legend('normalized min-sum（factor = 0.6）','normalized min-sum（factor = 0.7）','normalized min-sum（factor = 0.8）','normalized min-sum（factor = 0.9）');
h=legend('Coop-G-LDPC-Bp','Coop-G-LDPC-MS','Coop-G-LDPC-Normalized Bp-Based');

%title('LDPC Decoders Performance');
%title('相同码率不同码长的Normalized-Bp based译码性能');
%title('NMS中不同校正因子对性能的影响');
title('编码协作系统中不同译码算法性能比较');
xlabel('SNR (dB)');ylabel('Bit Error Rate');
semilogy(EbN0_dB, ber1, '-ko');
%semilogy(EbN0_dB, ber2, '-ks');
%semilogy(EbN0_dB, ber4, '-k+');
grid on;
figure(gcf)
grid on;
hold on;
hold off;
