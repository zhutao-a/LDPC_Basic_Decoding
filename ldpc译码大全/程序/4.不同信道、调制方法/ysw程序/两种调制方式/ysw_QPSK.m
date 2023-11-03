% 两种调制方式
clc,clear,close all
warning off
feature jit off
snrs = [0:5:30]; % SNR values
codeRate = 9/10; % 可能的取值 1/4, 1/3, 2/5, 1/2, 3/5, 2/3, 3/4, 4/5, 5/6, 8/9, and 9/10. The block length of the code is 64800
frames = 50;     % Number of frames (fame size is 64800 bits) to be simulated

rounds = size(snrs,2); % 取snrs的列数
messageLength = round(64800*codeRate);  % 码长

for rs=1:rounds
    rs
    framepattern = [];    
    snrvalue = snrs(rs);
    H = dvbs2ldpc(codeRate);
    errors = 0;
    hEnc = comm.LDPCEncoder(H);
    hMod = comm.QPSKModulator('PhaseOffset',pi/2);
    hChan = comm.MIMOChannel('MaximumDopplerShift', 0, 'NumTransmitAntennas',1,'NumReceiveAntennas',1, 'TransmitCorrelationMatrix', 1, 'ReceiveCorrelationMatrix', 1, 'PathGainsOutputPort', true, 'RandomStream', 'mt19937ar with seed');
    hAWGN = comm.AWGNChannel('NoiseMethod','Signal to noise ratio (SNR)','SNR',snrvalue);
    hDemod = comm.QPSKDemodulator('PhaseOffset',pi/2);                         
    hDec = comm.LDPCDecoder(H,'DecisionMethod', 'Soft decision');

    for counter = 1:frames
        receiveddataBits = [];
        data           = logical(randi([0 1], messageLength, 1));
        encodedData    = step(hEnc, data); 
        modSignal      = step(hMod, double(encodedData));
        % Transmit through Rayleigh and AWGN channels
        [chanOut, pathGains] = step(hChan, modSignal);  
        receivedSignal = step(hAWGN, chanOut);
        demodSignal    = step(hDemod, receivedSignal);
        receivedBits   = step(hDec, demodSignal);

        for i=1:1:messageLength
            if receivedBits(i,1) >= 0
                receiveddataBit = 0;
            else
                receiveddataBit = 1;
            end
            receiveddataBits = [receiveddataBits; receiveddataBit];
        end

        newErrors = nnz(receiveddataBits-data);
        errors = errors + newErrors;
        if newErrors == 0
            addFramepattern = 1;
        else
            addFramepattern = 0;
        end
        framepattern = [framepattern addFramepattern];
        code_errors = (size(framepattern,2) - nnz(framepattern));
    end

    SumErrors(rs) = errors;
    BER(rs) = errors/(frames*64800);
    FER(rs) = (size(framepattern,2) - nnz(framepattern))/size(framepattern,2);
    
end
QPSK_BER=BER; 
QPSK_FER=FER;
save QPSK_BER.mat snrs QPSK_BER QPSK_FER
figure(1)
plot(snrs,QPSK_BER,'bo-','linewidth',2);
xlabel('SNR');ylabel('BER');
figure(2)
plot(snrs,QPSK_FER,'bo-','linewidth',2)
xlabel('SNR');ylabel('FER');



