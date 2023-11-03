function data_hout = func_bin2hex(data_bin)  
data_len = size(data_bin,2);  
data_hout=zeros(1,data_len/4);

for t = 1:4:data_len-1
    temp = data_bin(t) * 2^3 +  data_bin(t +1) * 2^2 +  data_bin(t+2) * 2 +  data_bin(t +3) ;
   
    temp = lower(dec2hex(temp));
     disp(temp);
    data_hout((t-1)/4+1)=temp;
end
