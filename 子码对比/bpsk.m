function mod=bpsk(x)
%ʵ��һ���򵥵�ӳ���ϵ
%����xΪ�����Ļ�����У�lenΪ�䳤
mod = zeros(size(x));
mod(x == 1) = -1;
mod(x == 0) = 1;
