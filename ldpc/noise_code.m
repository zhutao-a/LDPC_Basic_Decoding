%bpsk:1-2x,给编码后的码字加噪
function n_code=noise_code(code,sigma,seed)
%N0与输入信噪比关系式，举例码率1/2：N0 = 2/(exp(EbN0*log(10)/10))
rng(seed);
bpskmod = 1-2*code ;%经过BPSK调制
n_code = bpskmod + sigma*randn(size(code));%加上噪声



