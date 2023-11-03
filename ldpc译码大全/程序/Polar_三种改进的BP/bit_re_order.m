function [ index ] = bit_re_order( N )
%BIT_RE_ORDER Summary of this function goes here
%   Detailed explanation goes here


index = zeros(N,1);
for n = 1:N
    tmp = bitget(n-1, log2(N):-1:1);
    tmp = fliplr(tmp);
    index(n) = sum(tmp.*2.^(log2(N)-1:-1:0))+1;
end

end

