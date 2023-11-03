function mod=bpsk(x)
%实现一个简单的映射关系
%输入x为编码后的混合序列，len为其长
mod = zeros(size(x));
mod(x == 1) = -1;
mod(x == 0) = 1;
