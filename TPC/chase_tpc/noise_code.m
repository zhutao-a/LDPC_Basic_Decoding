%���Ѿ�������TPC���־�BPSK���ƺ����AWGN����
function n_code=noise_code(code,EBN0)%code����gf��N0Ϊƽ����������
%N0����������ȹ�ϵʽ����������1/2��N0 = 2/(exp(EbN0*log(10)/10))
bpskmod = 2*code - 1;%����BPSK����
R=(239/256)^2;
N0 = (1/R)*(1/(exp(EBN0*log(10)/10))); 
n_code = bpskmod + sqrt(N0/2)*randn(size(code));%��������