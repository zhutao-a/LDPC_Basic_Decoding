function error_bit=error_count(n_code,code)
b=(n_code<0);
error_bit=sum(sum(mod(b+code,2)));

