% Bit error rate of BPSK modulated LDPC codes under AWGN channel
%
%
% Copyright Bagawan S. Nugroho, 2007 
% http://bsnugroho.googlepages.com

clc; 
clear all;

% LDPC matrix size, rate must be 1/2
% Warning: encoding - decoding can be very long for large LDPC matrix!
M = 256;
N = 512;

% Method for creating LDPC matrix (0 = Evencol; 1 = Evenboth)
method = 1;

% Eliminate length-4 cycle
noCycle = 1;

% Number of 1s per column for LDPC matrix
onePerCol = 3;

% LDPC matrix reorder strategy (0 = First; 1 = Mincol; 2 = Minprod)
strategy = 2;

% EbN0 in dB
EbN0 = [1:0.5:3];

% Number of iteration;
iter = 10;

% Number of frame (N bits per frame)
frame = 100;

% Make the LDPC matrix
H = makeLdpc(M, N, 1, 1, onePerCol);

for i = 1:length(EbN0)
    ber(i) = 0; 
   % Make random data (0/1)
   dSource = round(rand(M, frame));
   
   for j = 1:frame
     % fprintf('Frame : %d\n', j);
      
      % Encoding message
      [c, newH] = makeParityChk(dSource(:, j), H, strategy);
      u = [c; dSource(:, j)];

      % BPSK modulation
      bpskMod = 2*u - 1;
      % Additional white gaussian noise
      N0 = 1/(exp(EbN0(i)*log(10)/10));
      tx = bpskMod + sqrt(N0/2)*randn(size(bpskMod));%%%%%%%(real noise)

      % Decoding (select decoding method)
      vhat = decodeProbDomain(tx, newH, N0);
   %  vhat1 = decodeLogDomain(tx, newH, N0, iter);
   %  vhat = decodeLogDomainSimple(tx, newH, iter);
      %vhat = decodeBitFlip(tx, newH, ter);
   
      % Get bit error rate (for brevity, BER calculation includes parity bits)
      [num, rat] = biterr(vhat', u);
      ber(i) = (ber(i) + rat);
     
     % [num1, rat1] = biterr(vhat1', u);
     % ber1(i) = (ber1(i) + rat1);
      
  %  [num2, rat2] = biterr(vhat2', u);
  %   ber2(i) = (ber2(i) + rat2);
      
   end % for j
   
   % Get average of BER
  ber(i) = ber(i)/frame;
   %ber1(i) = ber1(i)/frame;
%   ber2(i) = ber2(i)/frame;
   
end % for i

% Plot the result
%semilogy(EbN0, ber, 'o-k');
title('Bit Error Rate');
xlabel('SNR (dB)');
ylabel('BER');
%semilogy(EbN0, ber1, 's-k');
semilogy(EbN0, ber, 's--k');
%legend('BP“Î¬Î','Log-BP','MS◊Ó–°∫Õ“Î¬Î');
%legend('BP');
%grid on;
%hold on;
hold off;
