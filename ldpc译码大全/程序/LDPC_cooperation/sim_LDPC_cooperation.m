%%%%regular LDPC code(3,6) rate 0.5, codeword's length 504,
%%%%cooperation commnunication
clear;
clc;
load PEGH_3_6_504.mat
K=252;                      
N=504;  %%% length of codeword
Rate=0.5;
M=round(N*(1-Rate));
for i=1:M
    Hrow_entity(i)=length(find(H_indexrow(i,:)~=0));
end
EsNodB1 =7.5:2.5:25;
EsNo1 = 10.^(EsNodB1/10);
EsNodB2 =7.5:2.5:25;
EsNo2 = 10.^(EsNodB2/10);
U12EsNodB = 20;
U12EsNo = 10.^(U12EsNodB/10);
Avg_energy=1;
variance1 = Avg_energy./(2*EsNo1);
variance2 = Avg_energy./(2*EsNo2);
varianceU12 = Avg_energy./(2*U12EsNo);
decode_iterations = 50;                   
number_frames = 5;
Num_SNR = length(EsNodB1);
test_Infober_u1 = zeros(Num_SNR,1);
test_Fer_u1 = zeros(Num_SNR,1);
test_Infober_u2 = zeros(Num_SNR,1);
test_Fer_u2 = zeros(Num_SNR,1);
for count_SNR=1:Num_SNR 
    bit_errors1 = 0;
    bit_errors2 = 0;
    Fer1 = 0;
    Fer2 = 0;
 for frame=1:number_frames
     %%send all zero codeword
     Codeword1=zeros(N,1);  %%%user1
     Codeword2=zeros(N,1);  %%%user2
     %% modulate signal
     sig1=-(2*Codeword1-1);  %%BPSK modulation [0 1;1 -1]
     sig2=-(2*Codeword2-1);
     %% add noise
     noise_U1B = sqrt(variance1(count_SNR))*randn(N,1);
     noise_U2B = sqrt(variance2(count_SNR))*randn(N,1);
     noise_U12 = sqrt(varianceU12)*randn(K,1);
     noise_U21 = sqrt(varianceU12)*randn(K,1);
     a1=sqrt((randn/sqrt(2))^2+(randn/sqrt(2))^2);  %%slow fading channel
     a2=sqrt((randn/sqrt(2))^2+(randn/sqrt(2))^2);  
     a3=sqrt((randn/sqrt(2))^2+(randn/sqrt(2))^2);
     a4=sqrt((randn/sqrt(2))^2+(randn/sqrt(2))^2);
     r1_1phase = sig1(1:K)*a1 + noise_U1B(1:K);
     r2_1phase = sig2(1:K)*a2 + noise_U2B(1:K);
     r12 = sig1(1:K)*a3 + noise_U12;
     r21 = sig2(1:K)*a4 + noise_U21;
     u1_e=zeros(K,1);
     for i=1:K
         if(r12(i)>=0)
             u1_e(i)=0;
         else
             u1_e(i)=1;
         end
     end
     u2_e=zeros(K,1);
     for i=1:K
         if(r21(i)>=0)
             u2_e(i)=0;
         else
             u2_e(i)=1;
         end
     end
     if u1_e==Codeword1(1:K)
         r2_2phase = sig1(K+1:N)*a2+noise_U2B(K+1:N);
         u2_indicator = 1;
     else
         r2_2phase = sig2(K+1:N)*a2+noise_U2B(K+1:N);
         u2_indicator = 0;
     end
     if u2_e==Codeword2(1:K)
         r1_2phase = sig2(K+1:N)*a1+noise_U1B(K+1:N);
         u1_indicator = 1;
     else
         r1_2phase = sig1(K+1:N)*a1+noise_U1B(K+1:N);
         u1_indicator = 0;
     end
     Lc1=4*a1*EsNo1(count_SNR);  %% channel reability value
     Lc2=4*a2*EsNo2(count_SNR);
     L_r1_1phase=Lc1*r1_1phase;
     L_r2_1phase=Lc2*r2_1phase;
     L_r1_2phase=Lc1*r1_2phase;
     L_r2_2phase=Lc2*r2_2phase;
     if u1_indicator==1 & u2_indicator==1
        L_r1=[L_r1_1phase;L_r2_2phase];
        L_r2=[L_r2_1phase;L_r1_2phase];
        L_u1=LDPC_decoding(L_r1,decode_iterations);
        L_u2=LDPC_decoding(L_r2,decode_iterations);        
     elseif u1_indicator==0 & u2_indicator==0
         L_r1=[L_r1_1phase;L_r1_2phase];
         L_r2=[L_r2_1phase;L_r2_2phase];
         L_u1=LDPC_decoding(L_r1,decode_iterations);
         L_u2=LDPC_decoding(L_r2,decode_iterations);
     elseif u1_indicator==1 & u2_indicator==0
         L_u1=L_r1_1phase;
         L_r2=[L_r2_1phase;L_r2_2phase+L_r1_2phase];
         L_u2=LDPC_decoding(L_r2,decode_iterations);
     else
         L_u2=L_r2_1phase;
         L_r1=[L_r1_1phase;L_r1_2phase+L_r2_2phase];
         L_u1=LDPC_decoding(L_r1,decode_iterations);
     end
     err1=0;
     for i=1:K
         if L_u1(i)>=0
             Info_dec(i)=0;
         else
             Info_dec(i)=1;
         end
         if Codeword1(i)~=Info_dec(i)
             err1=err1+1;
         end    
     end
     err2=0;
     for i=1:K
         if L_u2(i)>=0
             Info_dec(i)=0;
         else
             Info_dec(i)=1;
         end
         if Codeword2(i)~=Info_dec(i)
             err2=err2+1;
         end    
     end
     if err1~=0
         Fer1=Fer1+1;
     end
     if err2~=0
         Fer2=Fer2+1;
     end
     bit_errors1=bit_errors1+err1;
     bit_errors2=bit_errors2+err2;   
 end     %%%match "for (frame=1:number_frames)"               
 Infober1 = bit_errors1/(number_frames*K);
 Infober2 = bit_errors2/(number_frames*K);
 test_Infober_u1(count_SNR)=Infober1
 test_Infober_u2(count_SNR)=Infober2
 test_Fer_u1(count_SNR)=Fer1/number_frames;
 test_Fer_u2(count_SNR)=Fer2/number_frames;
 save LDPC_coorpe_50sim1_20dB test_Infober_u1 test_Infober_u2 test_Fer_u1 test_Fer_u2 EsNodB1   
end