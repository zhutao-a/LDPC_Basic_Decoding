%--------------------------------------------------------------------------
% the Modulator function  
% by haitao liu
% 2008.08.20
% Copyright by cns/atm lab 
%--------------------------------------------------------------------------
function [tx_symbols] = Modulator(tx_bits, M)

ML = log2(M);
X  = tx_bits.';

switch ML 
   case 1
       %-------------------------------------------------------------------
       % the bpsk modulator
       modObj = modem.pskmod('M', 2, 'SymbolOrder', 'Gray', 'InputType', 'Bit');
       Y      = modulate(modObj,X);
       tx_symbols  = Y.';

   case 2
       %-------------------------------------------------------------------
       % the qpsk modulator
       modObj  = modem.pskmod('M', 4, 'PhaseOffset', pi/2, 'SymbolOrder', 'Gray', 'InputType', 'Bit');
       Y       = modulate(modObj,X);
       tx_symbols  = Y.';
       
   case 3
       %-------------------------------------------------------------------
       % the 8psk modulator
       modObj = modem.pskmod('M', 8, 'SymbolOrder', 'Gray', 'InputType', 'Bit');
       Y      = modulate(modObj,X);
       tx_symbols = Y.';
   
   case 4
       %-------------------------------------------------------------------
       % the 16qam modulator
       modObj = modem.qammod('M', 16, 'SymbolOrder', 'Gray', 'InputType', 'Bit');
       Y      = modulate(modObj,X);
       tx_symbols  = Y.';
    case 6
       %-------------------------------------------------------------------
       % the 64qam modulator
       modObj = modem.qammod('M', 64, 'SymbolOrder', 'Gray', 'InputType', 'Bit');
       Y      = modulate(modObj,X);
       tx_symbols  = Y.'; 
   otherwise
      disp('Unknown modulation scheme.')
end
end
