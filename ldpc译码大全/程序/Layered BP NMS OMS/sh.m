clear all
close all
clc
tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% H=[1 1 0 1 0 0;0 1 1 0 1 0;1 0 1 0 0 1]
%rows=3;
%cols=6;
[H]=genH(128,256)
%[H]=genH(64,128);
%[H]=genH112(8,16);
%[H]=genH05fen();
%load CMMB;
%load('CMMB.mat')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind=find(H==1);
[r,c]=ind2sub(size(H),ind);
[rows,cols]=size(H);
h=sparse(H);                         % for use with Matlab-based LDPC Decoder
n=cols;
k=n-rows;
[M,N]=size(h);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find 
% 1: maximum check degree
% 2: column indeces in each row which contain '1'
% 3: maximum variable degree
% 4: find column indeces in each row which contain '1'
%[max_check_degree,check_node_ones,BIGVALUE_COLS,max_variable_degree,variable_node_ones,BIGVALUE_ROWS]=one_finder(H);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rand('seed',584);
randn('seed',843);

dB=[1:0.5:4];                           % range of SNR values in dB
SNRpbit=10.^(dB/10);                % Eb/No conversion from dB to decimal
No_uncoded=1./SNRpbit;              % since Eb=1
R=k/n;                              % code rate 
No=No_uncoded./R;
%beta=0.65;
%alpha=1.25;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_iter=20;                   %maximum number of decoder iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
maximum_blockerror=20;      % maximum blockerrors per SNR point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

biterrors=0;
blockerrors=0;
    block=0;

%FER=zeros(1,length(dB));        % array for Frame Error Rate
BER=zeros(1,length(dB));        % array for Channel Error Rate
%block_array=zeros(1,length(dB));

    for z=1:length(SNRpbit) % loop for testing over range of SNR values
    biterrors=0;
    blockerrors=0;
    block=0;

    while(blockerrors<maximum_blockerror)  %while loop

        %%%%%%%%%%%%%%% u is the codeword to be transmitted %%%%%%%%%%%%%%%%%%
        u=zeros(1,cols);  %%all zero codeword
        tx_waveform=bpsk(u);
        sigma=sqrt(No(z)/2);       % 因为N0＝2*sigma^2
        rx_waveform=tx_waveform + sigma*randn(1,length(tx_waveform))  %产生一个服从N(0,1)分布的量，然后用它乘上sigma就表示服从N（0，sigma^2）分布
       %%%%%%%%%%%%%%%%%%%%%% decode %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %vhat=Offset_Min_Sum(rx_waveform,SNRpbit(z),H,M,N,beta)
       %vhat=Normalized_Min_Sum(rx_waveform,SNRpbit(z),H,M,N,alpha)
      % vhat=Min_Sum(rx_waveform,SNRpbit(z),H,M,N)
    
     %[vHat,n1]=decode1_NMS(rx_waveform,H, max_iter)
     %[vHat,n1]= decodeLLR_BP(rx_waveform',H, max_iter);
    % [vHat,n1]= Layered(rx_waveform',H, max_iter);
    %[vHat]=group(rx_waveform',H, max_iter);
                % [vHat,n3]= LayeredDecoding(rx_waveform',H, max_iter);
      vhat = decodeProbDomain(rx_waveform',H, No,max_iter)
     %vhat = decode_MS(rx_waveform',H,max_iter)
     %  vhat = decodeLogDomainSimple(rx_waveform, H,max_iter)
       
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
        Errors=zeros(1,length(vHat));
        Errors(find(u~=vHat))=1;
        
        biterrors=sum(Errors) ;
        block=block+1;
  
        

      
         if sum(Errors)~=0
            blockerrors=blockerrors+1;
            
      
            if rem(blockerrors,5)==0; %save statistics after every 5 blockerrors
                
                ber=biterrors/(block*n);
                %fer=blockerrors/block;
                
                s=sprintf('%dx%d_regular_results.txt',n-k,n);
                fid = fopen(s,'a');   %%新建一个文件夹，写入数据
                fprintf(fid,'\n');
                fprintf(fid,'%s %2.1EdB\n','SNR =',dB(z));
                fprintf(fid,'%s %6.3E\n','BER =',ber);
               % fprintf(fid,'%s %6.3E\n','FER =',fer);
                fprintf(fid,'%s %d\n','blocks =',block);
                fprintf(fid,'%s %d\n','blockerrors =',blockerrors);
                fprintf(fid,'%s %d\n','biterrors =',biterrors);
                fclose(fid);      %%关闭这个文件夹
            end
         end
   
       
     end     %while loop

    %block_array(z)=block; %counting blocks per SNR point
    BER(z)=biterrors/(block*n);
    %FER(z)=blockerrors/block;
    %fprintf(1,'\n\n Simulation finished for SNR: %d \n',dB(z))
    
%     save results.mat dB BER FER block_array
end    
% loop for testing over range of SNR values
%semilogy(dB,d,'b-o')
semilogy(dB,BER,'b-+');
hold on
title('Bit Error Rate')
ylabel('BER')
xlabel('Eb/No (dB)')
grid
toc
%figure
%semilogy(dB,FER,'b-o')
%title('Frame Error Rate')
%ylabel('FER')
%xlabel('Eb/No (dB)')
%grid



%toc

