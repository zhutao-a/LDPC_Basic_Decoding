%function[vHat,n2] = LayeredDecoding(rx, H2, iteration)
function [vHat,n2] = LayeredDecoding(rx, H, iteration)

[M N] = size(H);
%[M N] = size(H2);
 
Qv = -rx';
Rcv = zeros(M,N);
tempcv = zeros(1,N);
n2=0;


%H=zeros(128,256);
%H1=zeros(128,256);


%for j=1:16
   % for m=1:16
        %H1(:,j+(m-1)*4)=H2(:,(j-1)*8+m);%由4*8生成的16*32类循环矩阵)
        %H1(:,j+(m-1)*16)=H2(:,(j-1)*8+m);%由4*8生成的64*128类循环矩阵）
        %H1(:,j+(m-1)*16)=H2(:,(j-1)*16+m);   %由8*16生成的128*256类循环矩阵）
         %H1(:,j+(m-1)*16)=H2(:,(j-1)*32+m); %（由16*32生成的256*512类循环矩阵）
   % end 
%end

%for j=1:16
   % for m=1:8
        %H(j+(m-1)*4,:)=H1((j-1)*4+m,:);
        %H(j+(m-1)*16,:)=H1((j-1)*4+m,:);
         %H(j+(m-1)*16,:)=H1((j-1)*8+m,:);
          %H(j+(m-1)*16,:)=H1((j-1)*16+m,:);
    %end
%end


%factor = 0.75;
for n = 1:iteration
   fprintf('Iteration: %d\n',n);
   for i = 1:M
      col = find(H(i,:));
      for k = 1:length(col)
         tempcv(1,col(k)) = Qv(col(k)) - Rcv(i,col(k));
      end
      alpha = sign(tempcv);  
      beta  = abs(tempcv);
      signS = 1;min1 = 100000;min2 = 100000;index = 10000;
      
      for k = 1:length(col)
          signS = alpha(col(k)) * signS;
          if beta(col(k)) < min1
              min2 = min1;
              min1 = beta(col(k));
              index = col(k);end  
          if ((beta(col(k)) > min1) & (beta(col(k)) < min2)) min2 = beta(col(k));end    
      end
      
      
          
      for k = 1:length(col)
         if col(k) == index 
            
             Rcv(i,col(k)) = 0.8*signS*alpha(col(k))*min2;
        else Rcv(i,col(k)) = 0.8*signS*alpha(col(k))*min1;
             
          end    
         Qv(col(k)) = tempcv(1,col(k)) + Rcv(i,col(k));
      end 
 
      for k = 1:N
         if Qv(k) < 0
            vHat(k) = 1;
         else
            vHat(k) = 0;
         end 
     end
      
  end %for i
    
  if rem(H*vHat', 2) == 0
       break ;
    else
        n=n+1 ;
  end 
 
end %for n
n2=n;
%fprintf('LayeredDecoding is done...\n');