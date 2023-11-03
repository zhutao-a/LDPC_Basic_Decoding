function [ output ] = f_fun( L1, L2 )
%F_FUN Summary of this function goes here
%   Detailed explanation goes here

output = sign(L1*L2)*min(abs(L1), abs(L2));


end

