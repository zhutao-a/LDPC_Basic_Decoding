%bpsk:1-2x,�����������ּ���
function n_code=noise_code(code,sigma,seed)
%N0����������ȹ�ϵʽ����������1/2��N0 = 2/(exp(EbN0*log(10)/10))
rng(seed);
bpskmod = 1-2*code ;%����BPSK����
n_code = bpskmod + sigma*randn(size(code));%��������



