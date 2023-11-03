function[channel_output]=channel(channel_input,sgma)
%sgma=sqrt((1/(2*(10^(snr/10)))));                 %AWGN       
modulation=2*channel_input-1;
for i=1:length(channel_input)
  channel_output(i)=modulation(i)+gngauss(sgma);
end;
