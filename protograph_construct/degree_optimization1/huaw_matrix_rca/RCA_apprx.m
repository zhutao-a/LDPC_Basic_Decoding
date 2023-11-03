function [flag] = RCA_apprx(H,snr_dB,puncture_idx,R,snr_R,iter)  
%function description:to find whether base_matrix:H is decodable with iteration number:iter in SNR_dB 
%H:base_matrix
%SNR_dB:signal-to-noise-ratio described in dB
%puncture_idx:which columns have been punctured,a vector with elements belong to 1...length(H(1,:)),[] represents no punctured column 
%R and snr_R is a lut to the function R(snr_R) in RCA
%iter:maximum iteration number
%flag:1 means decodable,0 otherwise
snr = 2*10^(snr_dB/10);
mvout_threshold = 30;
[m,n] = size(H);
mu0 = ones(1,n) * snr;%initialize
if(~isempty(puncture_idx)) 
    mu0 (puncture_idx) = zeros(1,length(puncture_idx));%set punctured messages(variable nodes) to 0
end
mv = zeros(m,n);%V2C message:varible nodes to check nodes
mu = zeros(m,n);%C2V message:check nodes to varible nodes
%initialize V2C message
for j = 1:n
    mv(:,j) = mu0(j) * H(:,j);
end 
mvout = mu0;
muout = zeros(m,1);
flag = 0;
%use flooding schedule
for l = 1:iter 
    %row iteration update mu(C2V)
    for i = 1:m
        idx = find(H(i,:) ~= 0);
        mvidx = mv(i,idx);
        mvtmp = interp1(snr_R,R,mvidx);%Vq = interp1(X,V,Xq)
        muout(i) = sum(H(i,idx).*mvtmp);
        for j = 1:length(idx)
            mu(i,idx(j)) = muout(i) -  mvtmp(j);
        end
    end
    mu(mu>50) = 50;
    %column iteration update mv(V2C)
    for j = 1:n
        idx = find(H(:,j) ~= 0);
        muidx = mu(idx,j);
        mutmp = interp1(snr_R,R,muidx);
        mvout(j) = mu0(j) + sum(H(idx,j).*mutmp);
        for i = 1:length(idx)
            mv(idx(i),j) = mvout(j) - mutmp(i);
        end
    end
    mv(mv>50) = 50;
    if(min(mvout)>mvout_threshold)
        flag = 1;
        break;
    end
end

