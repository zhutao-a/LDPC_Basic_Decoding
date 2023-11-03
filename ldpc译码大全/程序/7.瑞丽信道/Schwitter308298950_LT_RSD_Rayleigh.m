%Simulation of an LT code over fading channel
%Bryan Schwitter 308298950

clear all
close all
clc


%definee number of information symbols
k = 100;
%--------DESIGN THE DEGREE DISTRIBUTION-------------

%number of degree one checks => S
delta =0.5;
c=0.02;
S = c*sqrt(k)*log(k/delta); 

% define ideal solition distribution (IDS)
p(1)=1/k;
for i=2:k
    p(i)=1/(i*(i-1));
end

%modification of ISD to Robudt solition Distribution RSD
for i = 1:(round(k/S)-1)
    T(i) = S/(i*k);
end

T(round(k/S))=S*log(S/delta)/k;

for i= (round(k/S)+1):k
    T(i)= 0;
end

% B is used to normalize ie ensure u is a probability distribution
% B = 0;
% for i=1:k
%     b = p(i) + T(i);
%     B=B+b;
% end
% the distribution
u = (p + T);
B = sum(u);
u = u/B;
%---------------------------------------------------

%divide u by the smallest entry so all 100 degree values have a frequency
%>1. Also have to round the values so they are integers
u = u/min(u);
u = round(u*100); %this is the degree distribution...now redo it so you ave a vector of numbers between 1 and k for the length of the sum of u

for n = 1:k
    val = u(n);
    ddist{n}(1,1:val) = ones(1,val)*n;  
end
%make a single row vector with all possible degree distributions
dist = cat(1,ddist{1}',ddist{2}')';
for n = 3:50
    dist = cat(1,dist',ddist{n}')';
end


%--------------
%Create Modulator
modul = modem.pskmod('M',2,'InputType','Bit');

for frames = 1:2
    %create random message for each frame
   % msg = randint(1,k,2);
   msg(1,k,2)=round(rand(1));
    disp(strcat(['Frame ' num2str(frames)]) )
    for snr=-4:2:10 % These are the Eb/N0 values

        disp(strcat(['Simulating BPSK in AWGN Channel with Eb/N0 of ' num2str(snr) ' dB']) )
        %reset variables for each round of snr
        G=zeros(k); 
        halt=0;
        n=0;
        while halt ==0
            
                %create encode and add noise to each symbol as you are transmitting symbols
                %sequentially
                n=n+1;
                
                %have to randomly choose a degree value out of dist
                choose = randperm(length(dist));
                degree(n) = dist(choose(1));%keep track of degree values to make G
                %
                c=randperm(k);
                encoded = msg(c(1:degree(n))); 
                encodedsymbols(n) = mod(sum(encoded),2);%XOR

                G(c(1:degree(n)),n)=1;%G has c rows and you set values of c to 1

                %modulate
                modsig(n) = modulate(modul,encodedsymbols(n));

                sigma = sqrt(10^(-snr/10));
                awgnnoise = 1/sqrt(2)*[randn(1,length(modsig)) + j*randn(1,length(modsig))]; % white gaussian noise, 0dB variance
                raynoise = 1/sqrt(2)*abs([randn(1,length(modsig)) + j*randn(1,length(modsig))]); % Rayleigh channel
                %awgnnoise = sqrt(sigma/2)*[randn(1,length(modsig)) + j*randn(1,length(modsig))]; % white gaussian noise, 0dB variance

                % Add noise - AWGN + Rayleigh
                channelsig = raynoise.*modsig + 10^(-snr./20)*randn(1);
                channelsig_eq = channelsig./raynoise;%equalise

                % Demodulate
                demod = modem.pskdemod(modul,'DecisionType','llr','NoiseVariance',sigma^2);
                % Compute log-likelihood ratios (AWGN channel)
                demodsig(n) = demodulate(demod, channelsig(n));


                
            
            if n>k
            %DECODING
            mio = zeros(k,length(G));
            for count = 1:50
                decmsg=zeros(1,length(msg));
                %column processing
                for col = 1:size(G,2)
                    rowind = find(G(:,col));%for each col find the rows contating a 1 ie a connection in tanner graph
                    A = mio(rowind,col); %single element of matrix
                    

                    if sum((A))%if this is zero then its bypassed
                        A(A==0)=1e-20;%avoid Inf and NaN
                        a=tanh(demodsig(col)./2)*prod(tanh(A./2))./tanh(A./2);;%divide to satisfy conditon of algorith
                        
                        %X=(beta(col))*prod((mio(rowind,col)))./((mio(rowind,col)));%divide to satisfy conditon of algorith
                        for b=1:length(a)
                            if a(b)==1
                                a(b)=1-1e-16;
                            elseif a(b)==-1
                                a(b)=-1+1e-16;
                            end
                        end
                        %Update moi->moi=var node
                        moi(rowind,col) = 2*atanh(a);%(((1+exp(alphasum))./(exp(alphasum)-1))).*X;
                        %moi(col,rowind) = (((tanh(alphasum)))).*X;
                    else
                       moi(rowind,col)=demodsig(col); 
                    end
                end

                %Row Processing
                for row = 1:k
                    colind = find(G(row,:));
                    B=moi(row,colind);
                    mio(row,colind)=sum(B)-B;%minus B to satisfy condition of the summation
                    source(row)=sum(B);
                end

            end
            %do the hard decision;
            for iii = 1:length(source)
                
              
                if source(iii)>0
                    decmsg(iii)=0;
                else
                    decmsg(iii)=1;
                end
            end
            BER=nnz(decmsg-msg)/length(msg);
            if BER<.01
                halt=1;
            end
            %decode end
            end
        end            
        disp(strcat(['The number of symbols transmitted for successful decoding =' num2str(n)]))
        %Rate(frames,round((snr+5)/2))=k/n;
        Rate(frames,snr+5)=k/n;
    end
        
end        
    
R=mean(Rate,1);
snr=[-4:2:10];
rr=find(R);
%Plot the rsults
figure(1)
plot(snr,1./R(rr))
xlabel('Eb/N0 (dB)')
ylabel('1/Rate')

%title('LT encoded BPSK modulated transmission over Rayleigh channel')
grid minor