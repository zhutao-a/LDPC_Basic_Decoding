%将已经编码后的TPC码字经BPSK调制后加上AWGN噪声
function n_code=noise_code(code,EBN0)%code不是gf域，N0为平均噪声功率
%N0与输入信噪比关系式，举例码率1/2：N0 = 2/(exp(EbN0*log(10)/10))
bpskmod = 2*code - 1;%经过BPSK调制
R=(239/256)^2;
N0 = (1/R)*(1/(exp(EBN0*log(10)/10))); 
n_code = bpskmod + sqrt(N0/2)*randn(size(code));%加上噪声