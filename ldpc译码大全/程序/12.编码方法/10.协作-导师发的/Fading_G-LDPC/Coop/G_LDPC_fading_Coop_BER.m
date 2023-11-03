
% Regular LDPC codes over Raleigh fading channels vith M=500,N=1000,M2=500
%dv1=3,dc1=6,dv2=3.dc2=9
% stand BP
clc; 
clear all;
format long;



%%%%  matrice for encoding and decoding 
load('H1'); 
load('H2');
load('H');  % joint matrix
[M,N] = size(H1);% M=500,N=1000;M1=500,N1=1000
[M1,N1] = size(H2);

%% S encoding  u
dSource1 = round(rand(N-M,1));
c1 = zeros(M,1);
for t = 1:M
    sum1 = H1(t,1:N-M)*dSource1;
    c1(t) = mod(sum1,2);
    sum1 = 0;
end %t
u = [dSource1;c1];
%% R encoding u2
c2 = zeros(M1,1);
for t = 1:M1
    sum2 = H2(t,1:N1-M1)*dSource1;% only information bits
    c2(t) = mod(sum2,2);
    sum2 = 0;
end
u2 = [u;c2];


%EbN0 = [0 5 10 15 20];
EbN0 = [0 1 1.5 2 2.5 3 3.5];
% Number of iteration;
iter = 10;
% Number of frame (N bits per frame)
frame = 2;
 

bpskSD = 2*u - 1; %%%%%%%%%% bpskSD = 2 *u2-1%%%%%%%%%%%P2P系统
bpskRD = 2*c2 - 1;%%%%%%%%%%%%%%%%%%%%%%%如若是P2P系统，即无需加上中继

fout = fopen('LDPC_chk_mat_H_.txt','wb');%自动生成.dat文件，文件名为cov_1_2_corr_para0.50.dat相关噪声的协方差矩阵文件
fwrite(fout,H, 'single');
fclose(fout);

fout = fopen('LDPC_chk_mat_H1_.txt','wb');%自动生成.dat文件，文件名为cov_1_2_corr_para0.50.dat相关噪声的协方差矩阵文件
fwrite(fout,H1, 'single');
fclose(fout);
fout = fopen('LDPC_chk_mat_H2_.txt','wb');%自动生成.dat文件，文件名为cov_1_2_corr_para0.50.dat相关噪声的协方差矩阵文件
fwrite(fout,H2, 'single');
fclose(fout);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% detect
 for i = 1:length(EbN0)
     ber1(i) = 0;
     ber2(i) = 0;
     ber3(i) = 0;
   for j = 1:frame
       
      
    %  ray_H = wgn(1,1,0,'dBW','complex'); 
    %  ray_Hr = wgn(1,1,0,'dBW','complex');  
   %   C1 = ray_H';
    %  C2 =
    %  ray_Hr';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%C2和Hr都表示中继%%%%%%%%%%%%
      N0 = 1/(10^(EbN0(i)/10)); %%%%% 不考虑码率
      N0r = 1/(10^((EbN0(i))/10));  %
      
      nos1 = wgn(1,N,N0,'linear','complex');
     % r1 = ray_H*bpskSD'+nos1;
     r1 =bpskSD'+nos1;
   %   tx1 = C1*r1;
      tx1 =r1;
      tx1=real(tx1);%achieve the real part as decoder input IN ROW
      nos2 = wgn(1,M,N0r,'linear','complex');        %%%%%%%%%%%%%%%%%%%%%%只有协作系统才有，P2P下面都没有2 2 2 2
      r2 =bpskRD'+nos2;
      tx2 =r2;
      tx2=real(tx2);%achieve the real part as decoder input IN ROW
      
      tx = [tx1 tx2];
   %   tx = tx';% for Min-Sum
      tx = tx./(N0/2); % for Standard BP , complex noise
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Joint iterative decoding

    %[vhat1,vhat10] = decodeLogDomainSimple(tx, H, iter);%Min Sum
    % [vhat1,vhat10] = decodeProbDomain(tx, H, iter);%% Standard BP
    % [vhat1,vhat5,vhat10] =decode_NMS(tx, H, iter);
    
     vhat1 = decodeProbDomain(tx, H, iter);
 %    vhat2 = decodeLogDomainSimple(tx, H, iter);
    % vhat2 = decode_MS(tx, H, iter);
%     vhat2 = decode_NMS(tx, H, iter);
 % calculate the BER of information bits
 
      [num1, rat1] = biterr(vhat1, u2');
      ber1(i) = (ber1(i) + rat1);
%      [num2, rat2] = biterr(vhat2, u2');
%      ber2(i) = (ber2(i) + rat2);
    % [num3, rat3] = biterr(vhat3, u2');
    %  ber3(i) = (ber3(i) + rat3);
   end % for j
    
   % Get average of BER
   ber1(i) = ber1(i)/frame;
 %ber2(i) = ber2(i)/frame;
 %  ber3(i) = ber3(i)/frame;
   
   ber1(i),
%   ber2(i),
 %  ber3(i),
   save ber1.mat ber1;
%   save ber2.mat ber2;
  % save ber3.mat ber3;
   
end % for i 
ber1(i),
%ber2(i),
%ber3(i),


% Plot the result
% semilogy(Eb_N0,BER,'o-');
%title('编码协作系统中不同译码算法性能比较');
title('编码协作系统中译码算法的改进');
semilogy(EbN0, ber1, '-ks');
%semilogy(EbN0, ber2, '-ko');
%semilogy(EbN0, ber3, '-kd');
%legend('BP-G-LDPC-Coop','MS-G-LDPC-Coop','Normalized-Bp-based-G-LDPC-Coop');
%h=legend('Coop-G-LDPC-Hybird C-V','Coop-G-LDPC-NMS的改进''Coop-G-LDPC-NMS(a=0.8)');
legend('Hybrid C-V G-LDPC-Coop');
xlabel('SNR (dB)');
ylabel('BER');
grid on;
hold on;
hold off;

