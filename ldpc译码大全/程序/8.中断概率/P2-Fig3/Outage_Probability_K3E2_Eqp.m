%  Outage Probability analysis  for Noncoop and cooperative MIMO
% OK  2012 06 11
% note: ant = 1,2,3
clc;
clear all;
format long

a = 1/2;
b = 1/2;
r = 1/4;
K = 3; %number of antennas at relay;
KI = 1;


num = 10000;
Frame = 10000;
% Simulations   Point to Point
SNR = [0 5 10 15 20];  %dB
for i = 1:length(SNR)
   
  sum_Lvn = 0;
  sum_Lvc = 0;
  sum_Lvc1 = 0;
  sum_Lvc2 = 0;
      for fra = 1:Frame
        hs = wgn(1,num,0,'dBW','complex');    %hsd
        hr = wgn(K,num,0,'dBW','complex'); %hrd equel power
        hz = wgn(K-KI,num,0,'dBW','complex');    %hsr
        
        
        hs1 = conj(hs);
        hr1 = conj(hr);
        hz1 = conj(hz);
        hsd = hs1.*hs;
        hrd = hr1.*hr;
        hzd = hz1.*hz;
        h1 = sum(hsd,1);  %add by vector-sum  |hsd|^2
        h2 = sum(hrd,1);  % which is 1*num    |hrd|^2  
        h3 = sum(hzd,1);  %                   |hsr|^2 havesting energy
    
 % SNR_S1D = SNR_RD =SNR   
        snr(i) = 10^(SNR(i)/10);  % linea
        Cc = a*log2(1+h1.*snr(i)/4) + b*log2(1+ h2.*h3.*snr(i)/K);  % sd = 2, sr=rd=1,g=1
        vc = find(Cc<r);
        Lvc = length(vc);
        sum_Lvc = sum_Lvc + Lvc;
        
      end
      
  
     Pc(i) = sum_Lvc/(Frame*num);

       
end

semilogy(SNR,Pc,'-ko');
xlabel('SNR (dB)');
ylabel('Outage Probability');
legend('equip power',1)

Pc,


            
        
    
   
     
