%--------------------------------------------------------------------------
% the Demodulator function  
% by haitao liu
% 2008.08.20
% Copyright by cns/atm lab 
%--------------------------------------------------------------------------
function [tx_bits_hat] = Demodulator(Rx_signals, M)

ML = log2(M);
X  = Rx_signals.';

switch ML
    case 1
        %-------------------------------------------------------------------
        % the bpsk modulator
        demodObj    = modem.pskdemod('M', 2, 'SymbolOrder', 'Gray', 'OutputType', 'Bit');
        set(demodObj , 'DecisionType', 'Hard decision');
        Y = demodulate(demodObj,X);
        tx_bits_hat =Y.';

    case 2
        %-------------------------------------------------------------------
        % the qpsk modulator
        demodObj    = modem.pskdemod('M', 4, 'PhaseOffset', pi/2, 'SymbolOrder', 'Gray', 'OutputType', 'Bit');
        set(demodObj , 'DecisionType', 'Hard decision');
        Y = demodulate(demodObj,X);
        tx_bits_hat =Y.';

    case 3
        %-------------------------------------------------------------------
        % the 8psk modulator
        demodObj    = modem.pskdemod('M', 8, 'SymbolOrder', 'Gray', 'OutputType', 'Bit');
        set(demodObj , 'DecisionType', 'Hard decision');
        Y = demodulate(demodObj,X);
        tx_bits_hat =Y.';

    case 4
        %-------------------------------------------------------------------
        % the 16qam modulator
        demodObj    = modem.qamdemod('M', 16, 'SymbolOrder', 'Gray', 'OutputType', 'Bit');
        set(demodObj , 'DecisionType', 'Hard decision');
        Y = demodulate(demodObj,X);
        tx_bits_hat =Y.';
    case 6
        %-------------------------------------------------------------------
        % the 64qam modulator
        demodObj    = modem.qamdemod('M', 64, 'SymbolOrder', 'Gray', 'OutputType', 'Bit');
        set(demodObj , 'DecisionType', 'Hard decision');
        Y = demodulate(demodObj,X);
        tx_bits_hat =Y.';
    otherwise
        disp('Unknown modulation scheme.')
end


