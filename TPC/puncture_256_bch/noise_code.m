%将已经编码后的TPC码字经BPSK调制后加上AWGN噪声
function n_code=noise_code(code,sigma,frame)%code不是gf域，N0为平均噪声功率
%N0与输入信噪比关系式，举例码率1/2：N0 = 2/(exp(EbN0*log(10)/10))
rng(frame);
bpskmod = 1-2*code ;%经过BPSK调制
n_code = bpskmod + sigma*randn(size(code));%加上噪声