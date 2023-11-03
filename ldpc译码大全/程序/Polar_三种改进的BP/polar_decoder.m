function [decode_out] = polar_decoder(z, N, info_bit_index)
%POLAR_DECODER Summary of this function goes here
%   Detailed explanation goes here

u = zeros(N, 1);
M = numel(info_bit_index);

for m = 1:M
    %tmp = decomposeC(N, info_bit_index(m), z, u);
     tmp = decompose2(N, info_bit_index(m), z, u);
    if tmp>0
        u(info_bit_index(m)) = 0;
    else
        u(info_bit_index(m)) = 1;
    end
end
decode_out = u;
%decode_out = u(info_bit_index);

end

