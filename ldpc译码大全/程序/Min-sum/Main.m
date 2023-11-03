clear all %#ok<CLSCR>
clc
%xber=[0.02,0.05,0.1,0.25,0.33,0.5,1,2,3,4,10,20,50];%Ԥ��ֵ��ʵ��ֵƫ��̶�
xber=1;
bers=0.004;
AverageCycle=zeros(1,length(xber));
percent=zeros(1,length(xber));

%load('H440x8632.mat');load('P440x8632(8192).mat');load('rearranged_cols440x8632.mat');     % R=94.9%
%load('H2048x10240.mat');load('P2048x10240(8192).mat');load('rearranged_cols2048x10240.mat');     % R=80%
%load('H341x8533.mat');load('P341x8533(8192).mat');load('rearranged_cols341x8533.mat');     % R=96%
load('H128x1152.mat');load('P128x1152.mat');load('rearranged_cols128x1152.mat');
[m,n]=size(H);
time=100;%ÿ��ber���Դ���
Imax=100;%�涨����������
sheet=1;%���뷽����1�������飻2������LSB��3������MSB
dataname='��20000�β�����ҳ����.xlsx';

for jj = 1:length(bers)
    ber = bers(jj);
    for ii=1:length(xber)
        fprintf('ber=%f\n',ber);
        x=xber(ii);
        fprintf('x=%f\n',x);
        e=ceil(n*ber);%����λ��
        %e=ceil(149/4);
        flag=0;%����ɹ���־��
        flag1=0;
        cycle=zeros(1,time);
        ber=x*ber;

        c=round(rand(1,n-m));%������Ϣ    
        %c=xlsread(dataname,'C24578:C32769');
        %c=c';
        u=ldpc_encode_G(c,P,rearranged_cols);%�����ɺõ�P����
        %ur=reorder_bits_reverse(u,rearranged_cols);
        %u=ldpc_encode(c,H);%����
        
        for pp=1:time
            fprintf('test %d\n',pp);    
            if sheet==1%������
                [y,errorbit,p]=channel(u,e);   
            elseif sheet==2%����LSB
                [y,errorbit,p]=channel_MLC(u,e,H,P,rearranged_cols);
            elseif sheet==3%����MSB
                [y,errorbit,p]=channel_MLC_MSB(u,e,H,P,rearranged_cols);
            elseif sheet==4
                %[y,errorbit,p]=channel_special_LSB(u,e);
                %[y,errorbit,p]=channel_special_MSB(u,e);
                [y,errorbit,p]=channel_special(u,e);%������
            elseif sheet==5%��֤Motivation
                [y,errorbit,p]=channel_part(u,e,H,P,rearranged_cols,accuracy);
            end
                
            %tic
            [M,cycle(pp)]=min_sum_decode_new(H,y,ber,errorbit,p,Imax);%�����������

            %T=toc;
            %fprintf('decode time %f s\n',T);

            if M==u%�����������Ƿ�ͱ���������ͬ
                flag=flag+1;
                disp('success!');
            end
            temp=length(find(mod(M+u,2)));
            flag1=flag1+temp;
        end
        AverageCycle=mean(cycle);
        %��ƽ��ѭ��������ֻ������Ч����
        AverageCycle(ii)=(sum(cycle)-(time-flag)*Imax)/(flag);
        fprintf('ƽ��ѭ������=%f\n',AverageCycle(ii));
        percent(ii)=flag1/(time*n);%����ɹ���
        fprintf('FER=%f\n\n',percent(ii));
           
    end

    filename='minsumdata.xlsx';
    DataWritten=xlsread(filename,sheet);%�ȶ�����д�˶�������
    [row,col]=size(DataWritten);

    position=['A',num2str(row+1)];
    date=datestr(now,31);
    xlswrite(filename,{1,'',date},sheet,position);
    
    row=row+1;
    position=['A',num2str(row+1)];
    charp=num2str(ber);
    sizeH=[num2str(m),'*',num2str(n)];
    char={1,'','ber','=',charp,'size of H',sizeH};
    xlswrite(filename,char,sheet,position);%������ǰ������д��дber
    
    %accu=num2str(accuracy);
    %row=row+1;
    %position=['A',num2str(row+1)];
    %xlswrite(filename,{1,'','accuracy','=',accu},sheet,position);

    %position=['E',num2str(row+1)];
    %xlswrite(filename,xber,sheet,position);%дy

    row=row+1;
    position=['A',num2str(row+1)];
    chardata={1,'','ƽ��ѭ������','='};
    
    xlswrite(filename,chardata,sheet,position);%дѭ������
    
    position=['E',num2str(row+1)];
    xlswrite(filename,AverageCycle,sheet,position);

    row=row+1;
    position=['A',num2str(row+1)];
    chardata={1,'','FER','='};
    xlswrite(filename,chardata,sheet,position);%д�ɹ�������
    
    position=['E',num2str(row+1)];
    xlswrite(filename,percent,sheet,position);
    fprintf('�洢�������\n\n');
    
end

fprintf('����ִ����ϣ�\n');
title('Bit Error Rate');
xlabel('SNR (dB)');
ylabel('BER');
%semilogy(EbN0, ber1, 's-k');
semilogy(EbN0, ber2, 'd--k');
legend('BP����','Log-BP','MS��С������');
grid on;
hold on;
hold off;