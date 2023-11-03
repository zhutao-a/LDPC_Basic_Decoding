%--------------------------------------------------------------------------
% by chen qian
% min_sum algorithm
%--------------------------------------------------------------------------

close all;
clear all;
clc;
%--------------------------------------------------------------------------
%�������
load PEGH_3_6_504.mat
Rc         = 1/2;%����
hP(:,1:252)= H(:,1:252);%ȡH�����252*252����
% hpp=gf((hP),1);
% hp=inv(hpp);%�õ�hP�����GF(2)����
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
hp         = inv_GF2_new(hP);%���������
hs(:,1:252)= H(:,253:504);%ȡH����ĺ�252*252�ľ���

%V_infor��ʾ�����ڵ�����Ϣ�ڵ�Ķ�Ӧ��ϵ (����ͼ�Ĵ���)
[infor_V,row_weight,V_infor,col_weight]=I_V(H);    
%--------------------------------------------------------------------------
% ���Ʋ���
M  = 2;
ML = log2(M);

%--------------------------------------------------------------------------
%�볤
numSymbols0 = 252;%δ������볤
numSymbols1 = 504;%�������볤

%--------------------------------------------------------------------------
%�����
Eb_dB       = [0,2,4,6,8,10]; %ÿ�����ص�����ȣ�dB��ʽ��
% NumOfFrame= [10,10,20,30,40].*20;
NumOfFrame  = [1,2,3,4,5,7].*2;


for ii=1:length(Eb_dB)  
    
    Eb_dB(ii);  
    NumOfFrame(ii);
    sum_error_LDPC(ii)=0;
    sum_error_code(ii)=0;
    
    for jj=1:NumOfFrame(ii) 
        
        %------------------------------------------------------------------
        %����������غͱ���
        tx_bits0 = round(rand(1,numSymbols0));
        
        tx_bits  = mod(-1*hp*hs*tx_bits0',2)';%����      
        tx_bits1 = [tx_bits tx_bits0];% У��λ ��Ϣλ  
        tttt     = mod(H*tx_bits1',2);%��֤�Բ���
        
        %------------------------------------------------------------------
        %����
        code_modul0 = (2*tx_bits0-1);%����ǰ���Ʒ���
        code_modul1 = (2*tx_bits1-1);%�������Ʒ���
        
       %-------------------------------------------------------------------
        %���������
        Es     = 10^((Eb_dB(ii)+10*log10(ML))*0.1);%����ǰÿ�����ص������
        SNR_dB = Eb_dB(ii)+10*log10(Rc)+10*log10(ML);%���������ȣ���Ϊ�����˱���͵��ƣ�
        SNR    = 10^(SNR_dB*0.1);
        
        %-----------------------------------------------------------------
        %δ���� 
        spow0     = var(code_modul0);
        npow0     = spow0/Es;
        standard0 = sqrt(npow0);
        variance0 = standard0*standard0;%�����ķ���
         %����
        spow1     = var(code_modul1); 
        npow1     = spow1/SNR; 
        standard1 = sqrt(npow1); 
        variance1 = standard1*standard1;%�����ķ���, 
        
        %-----------------------------------------------------------------
        %����
        AWnoise0 = standard0*randn(length(tx_bits0),1);%δ������Ը�˹������
        AWnoise1 = standard1*randn(length(tx_bits1),1);%������Ը�˹������
        
        %------------------------------------------------------------------
        %��� 
        y_output0  = (code_modul0+AWnoise0');%����ǰ�ŵ���� 
        y_output1  = (code_modul1+AWnoise1');%������ŵ����   
        
        %-----------------------------------------------------------------
        %����ǰ  �о������
        y_out_just = (1+sign(y_output0))/2;%Ӳ�о�
            
       %-------------------------------------------------------------------
       %����������Ϣ������������
       decode_in_LLR = -2*y_output1/variance1;
      
       %-------------------------------------------------------------------
       %����������㣨����С���㷨��          
       %��ʼ�������ڵ�����Ϣ�ڵ㴫����Ϣ��Q����
       for index=1:size(V_infor,1)%�����ڵ���±�  V_infor������
           for j=1:size(V_infor,2)%��Ϣ�ڵ�ĸ���  V_infor������
               if V_infor(index,j)==0 %��Ϣ�ڵ�
                  break; 
               end    
              %��Ϣ�ڵ�/�����ڵ�          ����
               L_Q(j,index)=decode_in_LLR(index);    
           end 
       end     
          
       %-------------------------------------------------------------------

       %�����ڵ����Ϣ�ڵ�������㷨��LDPC�룩����С���㷨��  
       for inter_decoder=1:5
          [L_R,L_Q]=min_sum_decode(infor_V,V_infor,decode_in_LLR,L_Q);    
       end     
       %-------------------------------------------------------------------

       %�����ı�Ե�ܶȺ��� 
       for index_1=1:size(V_infor,1)%��ʾ�������±�,V_infor����
           w1=0;
           for index_2=1:size(V_infor,2)%��ʾ��Ϣ�ڵ���±꣬V_Finfor����
               if V_infor(index_1,index_2)==0 
                  break;  
               end
               for mid2_var2=1:size(infor_V,2)%�����ڵ�
                   if infor_V(V_infor(index_1,index_2),mid2_var2)==index_1%���� ����  ����
                       gg5=mid2_var2;
                   end
               end  
              %                 ��Ϣ�ڵ�         �����ڵ�
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
%       if mod(H*u_decode',2)==zeros(252,1);%��֤�Բ���
%          break;
%       end 

       %%------------------------------------------------------------------
       %ͳ������ĸ���
       k_decode           = u_decode(:,253:504);
%      h1                 = sum(abs(u_decode-(tx_bits1)))
%      h2                 = sum(abs(k_decode-(tx_bits0)))
       sum_error_code(ii) = sum_error_code(ii)+sum(abs(((y_out_just)-(tx_bits0))));%δ������������
       sum_error_LDPC(ii) = sum_error_LDPC(ii)+sum(abs(k_decode-(tx_bits0)));%����Ĵ��������
       
           
    end %֡������
    
    %ͳ��������
    PPa(ii)=sum_error_code(ii)/((length(y_output0))*NumOfFrame(ii))  ;%δ����������
    Pb(ii)=sum_error_LDPC(ii)/((length(y_output0))*NumOfFrame(ii))  ;%����������� 

end 
%--------------------------------------------------------------------------

%��ͼ 
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
xlabel('Eb/No��dB��');

