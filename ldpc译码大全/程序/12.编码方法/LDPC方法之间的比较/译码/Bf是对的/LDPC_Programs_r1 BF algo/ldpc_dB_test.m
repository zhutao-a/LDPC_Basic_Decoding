%function ldpc_dB_test(Go,Ho,max_ite,maxSNR,inc)               % use to test all BF Algo
load Ga.mat
load Ha.mat
max_ite=50;
maxSNR=1;
inc=0.5;
% Code to test codes for LDPC
% by Jinoe Morcilla Gavan=
% Rev 1 June 10, 2007
Go=Ga;
Ho=Ha;
% input
%   Go - Generator Matrix
%   Ho - Parity Check Matrix
%   max_ite - maximum number of iterations
%   maxSNR - maximum SNR value
%   inc - increment of SNR values

%close all

[Grow,Gcol]=size(Go);
[row,col] = size(Ho);
snr= [0:inc:maxSNR];

max = max_ite;
max_block=1;                 % can take >6 hours @ 3000

% For SNR/BER calculation
block=0;
biterrorsBF=0;                      % for BER calculations
biterrorsWBF=0;
biterrorsIWBF=0;
m=0;
%%%%%%%%%%%  Create a file %%%%%%%%%%%
serial=fix((datenum(clock))*1e3);         
for a=1:length(snr)
    a
    block=0;
                     % for BER calculations
    biterrorsWBF=0;
    biterrorsIWBF=0;
m=0;
        %%%%%%%% Generate random message bits by Igor %%%%%%%%
        u = (sign(randn(1,size(Go,1)))+1)/2

        %%%%%%%% Encode Message %%%%%%%%
       % [cw]=ldpc_encode(Go,u);
       [cw]= mod(u*Go,2);
         
        % BPSK modulation from Igor, another BPSK by Arun's
        % "1" --> -1     "0" --> -1
       % cw_bpsk = 2*cw-1;
for i=1:length(cw)
    if cw(1,i)>0
        cw_bpsk(1,i) =-1;
    else
        cw_bpsk(1,i) =1;
    end
end
        %%%%%%%% add AWGN %%%%%%%%
        % AWGN transmission, soft decision received sequence
        y_bpsk = awgn(cw_bpsk,snr(a));  %awgn is from the communication toolbox

        %%%%%%%% Decode Message %%%%%%%% 
        % Bit Flip algorithm (BF)
        [synBF,y_reBF] = ldpc_bf(Ho,y_bpsk,max);

        [numBF,ratioBF] = biterr(cw,y_reBF,'overall');        % from Comms Toolbox
        biterrorsBF(1,a) = numBF

       

end  
   semilogy(snr,biterrorsBF/200,'r-*')
      grid on