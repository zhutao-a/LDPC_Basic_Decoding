%���Ѿ�������TPC���־�BPSK���ƺ����AWGN����
function n_code=noise_code(code,EBN0,frame)%code����gf��N0Ϊƽ����������
%N0����������ȹ�ϵʽ����������1/2��N0 = 2/(exp(EbN0*log(10)/10))
rng(frame);
bpskmod = 1-2*code ;%����BPSK����
R=111/128;
N0 = (1/R)*(1/(exp(EBN0*log(10)/10))); 
n_code = bpskmod + sqrt(N0/2)*randn(size(code));%��������