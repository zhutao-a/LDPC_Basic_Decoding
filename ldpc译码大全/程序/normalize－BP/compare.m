function[numoferr]=compare(decode_output,channel_input)
numoferr=0;
for k=1:20
    if decode_output(k)~=channel_input(k)
       numoferr=numoferr+1;
    end
end