%--------------------------------------------------------------------------
% by chen qian
% min_sum algorithm
%--------------------------------------------------------------------------

close all;
clear all;
clc;
%--------------------------------------------------------------------------
%编码参数
load PEGH_3_6_504.mat
Rc         = 1/2;%码率
hP(:,1:252)= H(:,1:252);%取H矩阵的252*252矩阵
% hpp=gf((hP),1);
% hp=inv(hpp);%得到hP矩阵的GF(2)的逆
% for i=1:252
%     for j=1:252
%         if(hp(i,j)==0)
%             c(i,j)=0;
%         end
%         if(hp(i,j)==1)
%             c(i,j)=1; 
%         end
%     end
% end
hp         = inv_GF2_new(hP);%求二进制逆
hs(:,1:252)= H(:,253:504);%取H矩阵的后252*252的矩阵

%V_infor表示变量节点与信息节点的对应关系 (因子图的存入)
[infor_V,row_weight,V_infor,col_weight]=I_V(H);    
%--------------------------------------------------------------------------
% 调制参数
M  = 2;
ML = log2(M);

%--------------------------------------------------------------------------
%码长
numSymbols0 = 252;%未编码的码长
numSymbols1 = 504;%编码后的码长

%--------------------------------------------------------------------------
%信噪比
Eb_dB       = [0,2,4,6,8,10]; %每个比特的信噪比（dB形式）
% NumOfFrame= [10,10,20,30,40].*20;
NumOfFrame  = [1,2,3,4,5,7].*2;


for ii=1:length(Eb_dB)  
    
    Eb_dB(ii);  
    NumOfFrame(ii);
    sum_error_LDPC(ii)=0;
    sum_error_code(ii)=0;
    
    for jj=1:NumOfFrame(ii) 
        
        %------------------------------------------------------------------
        %产生输入比特和编码
        tx_bits0 = round(rand(1,numSymbols0));
        
        tx_bits  = mod(-1*hp*hs*tx_bits0',2)';%编码      
        tx_bits1 = [tx_bits tx_bits0];% 校验位 信息位  
        tttt     = mod(H*tx_bits1',2);%验证对不对
        
        %------------------------------------------------------------------
        %调制
        code_modul0 = (2*tx_bits0-1);%编码前调制符号
        code_modul1 = (2*tx_bits1-1);%编码后调制符号
        
       %-------------------------------------------------------------------
        %计算信噪比
        Es     = 10^((Eb_dB(ii)+10*log10(ML))*0.1);%编码前每个比特的信噪比
        SNR_dB = Eb_dB(ii)+10*log10(Rc)+10*log10(ML);%编码后信噪比（因为进行了编码和调制）
        SNR    = 10^(SNR_dB*0.1);
        
        %-----------------------------------------------------------------
        %未编码 
        spow0     = var(code_modul0);
        npow0     = spow0/Es;
        standard0 = sqrt(npow0);
        variance0 = standard0*standard0;%噪声的方差
         %编码
        spow1     = var(code_modul1); 
        npow1     = spow1/SNR; 
        standard1 = sqrt(npow1); 
        variance1 = standard1*standard1;%噪声的方差, 
        
        %-----------------------------------------------------------------
        %噪声
        AWnoise0 = standard0*randn(length(tx_bits0),1);%未编码加性高斯白噪声
        AWnoise1 = standard1*randn(length(tx_bits1),1);%编码加性高斯白噪声
        
        %------------------------------------------------------------------
        %输出 
        y_output0  = (code_modul0+AWnoise0');%编码前信道输出 
        y_output1  = (code_modul1+AWnoise1');%编码后信道输出   
        
        %-----------------------------------------------------------------
        %编码前  判决即解调
        y_out_just = (1+sign(y_output0))/2;%硬判决
            
       %-------------------------------------------------------------------
       %输入先验信息（启动迭代）
       decode_in_LLR = -2*y_output1/variance1;
      
       %-------------------------------------------------------------------
       %迭代译码计算（用最小和算法）          
       %初始化变量节点向信息节点传递信息（Q）。
       for index=1:size(V_infor,1)%变量节点的下标  V_infor的行数
           for j=1:size(V_infor,2)%信息节点的个数  V_infor的列数
               if V_infor(index,j)==0 %信息节点
                  break; 
               end    
              %信息节点/变量节点          变量
               L_Q(j,index)=decode_in_LLR(index);    
           end 
       end     
          
       %-------------------------------------------------------------------

       %变量节点和信息节点的译码算法（LDPC码）（最小和算法）  
       for inter_decoder=1:5
          [L_R,L_Q]=min_sum_decode(infor_V,V_infor,decode_in_LLR,L_Q);    
       end     
       %-------------------------------------------------------------------

       %变量的边缘密度函数 
       for index_1=1:size(V_infor,1)%表示变量的下标,V_infor的行
           w1=0;
           for index_2=1:size(V_infor,2)%表示信息节点的下标，V_Finfor的列
               if V_infor(index_1,index_2)==0 
                  break;  
               end
               for mid2_var2=1:size(infor_V,2)%变量节点
                   if infor_V(V_infor(index_1,index_2),mid2_var2)==index_1%函数 变量  变量
                       gg5=mid2_var2;
                   end
               end  
              %                 信息节点         变量节点
              w1=w1+L_R(V_infor(index_1,index_2),gg5); 
          end 
          decode_judge_LLR(index_1)=w1+decode_in_LLR(index_1);
       end 
          
       %-------------------------------------------------------------------
        for  index_3=1:length(tx_bits1)  
             if decode_judge_LLR(index_3)>=0
                u_decode(index_3)=0;   
             else     
                u_decode(index_3)=1;       
             end                  
        end 
%       if mod(H*u_decode',2)==zeros(252,1);%验证对不对
%          break;
%       end 

       %%------------------------------------------------------------------
       %统计误码的个数
       k_decode           = u_decode(:,253:504);
%      h1                 = sum(abs(u_decode-(tx_bits1)))
%      h2                 = sum(abs(k_decode-(tx_bits0)))
       sum_error_code(ii) = sum_error_code(ii)+sum(abs(((y_out_just)-(tx_bits0))));%未编码错误比特数
       sum_error_LDPC(ii) = sum_error_LDPC(ii)+sum(abs(k_decode-(tx_bits0)));%编码的错误比特数
       
           
    end %帧数结束
    
    %统计误码率
    PPa(ii)=sum_error_code(ii)/((length(y_output0))*NumOfFrame(ii))  ;%未编码误码率
    Pb(ii)=sum_error_LDPC(ii)/((length(y_output0))*NumOfFrame(ii))  ;%编码后误码率 

end 
%--------------------------------------------------------------------------

%画图 
figure;
Eb_No     = 10.^(Eb_dB(:).*0.1);
Pb_theory = 0.5.*erfc(sqrt(Eb_No/2));
semilogy(Eb_dB,Pb_theory,'k');
hold on;
semilogy(Eb_dB,PPa,'r');
hold on;
grid on;
semilogy(Eb_dB,Pb,'b');
ylim([0 1]);
legend('Theory','Uncode','LDPC');
ylabel('BER');
xlabel('Eb/No（dB）');

