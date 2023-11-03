clear all %#ok<CLSCR>
clc
%xber=[0.02,0.05,0.1,0.25,0.33,0.5,1,2,3,4,10,20,50];%预估值与实际值偏离程度
xber=1;
bers=0.004;
AverageCycle=zeros(1,length(xber));
percent=zeros(1,length(xber));

%load('H440x8632.mat');load('P440x8632(8192).mat');load('rearranged_cols440x8632.mat');     % R=94.9%
%load('H2048x10240.mat');load('P2048x10240(8192).mat');load('rearranged_cols2048x10240.mat');     % R=80%
%load('H341x8533.mat');load('P341x8533(8192).mat');load('rearranged_cols341x8533.mat');     % R=96%
load('H128x1152.mat');load('P128x1152.mat');load('rearranged_cols128x1152.mat');
[m,n]=size(H);
time=100;%每个ber测试次数
Imax=100;%规定最大迭代次数
sheet=1;%译码方案：1，不分组；2，分组LSB；3，分组MSB
dataname='第20000次擦除单页数据.xlsx';

for jj = 1:length(bers)
    ber = bers(jj);
    for ii=1:length(xber)
        fprintf('ber=%f\n',ber);
        x=xber(ii);
        fprintf('x=%f\n',x);
        e=ceil(n*ber);%错误位数
        %e=ceil(149/4);
        flag=0;%纠错成功标志量
        flag1=0;
        cycle=zeros(1,time);
        ber=x*ber;

        c=round(rand(1,n-m));%生成信息    
        %c=xlsread(dataname,'C24578:C32769');
        %c=c';
        u=ldpc_encode_G(c,P,rearranged_cols);%用生成好的P编码
        %ur=reorder_bits_reverse(u,rearranged_cols);
        %u=ldpc_encode(c,H);%编码
        
        for pp=1:time
            fprintf('test %d\n',pp);    
            if sheet==1%不分组
                [y,errorbit,p]=channel(u,e);   
            elseif sheet==2%分组LSB
                [y,errorbit,p]=channel_MLC(u,e,H,P,rearranged_cols);
            elseif sheet==3%分组MSB
                [y,errorbit,p]=channel_MLC_MSB(u,e,H,P,rearranged_cols);
            elseif sheet==4
                %[y,errorbit,p]=channel_special_LSB(u,e);
                %[y,errorbit,p]=channel_special_MSB(u,e);
                [y,errorbit,p]=channel_special(u,e);%不分组
            elseif sheet==5%验证Motivation
                [y,errorbit,p]=channel_part(u,e,H,P,rearranged_cols,accuracy);
            end
                
            %tic
            [M,cycle(pp)]=min_sum_decode_new(H,y,ber,errorbit,p,Imax);%引用译码程序

            %T=toc;
            %fprintf('decode time %f s\n',T);

            if M==u%测试译码结果是否和编码码字相同
                flag=flag+1;
                disp('success!');
            end
            temp=length(find(mod(M+u,2)));
            flag1=flag1+temp;
        end
        AverageCycle=mean(cycle);
        %求平均循环次数，只计算有效次数
        AverageCycle(ii)=(sum(cycle)-(time-flag)*Imax)/(flag);
        fprintf('平均循环次数=%f\n',AverageCycle(ii));
        percent(ii)=flag1/(time*n);%纠错成功率
        fprintf('FER=%f\n\n',percent(ii));
           
    end

    filename='minsumdata.xlsx';
    DataWritten=xlsread(filename,sheet);%先读，看写了多少数据
    [row,col]=size(DataWritten);

    position=['A',num2str(row+1)];
    date=datestr(now,31);
    xlswrite(filename,{1,'',date},sheet,position);
    
    row=row+1;
    position=['A',num2str(row+1)];
    charp=num2str(ber);
    sizeH=[num2str(m),'*',num2str(n)];
    char={1,'','ber','=',charp,'size of H',sizeH};
    xlswrite(filename,char,sheet,position);%接着以前的数据写，写ber
    
    %accu=num2str(accuracy);
    %row=row+1;
    %position=['A',num2str(row+1)];
    %xlswrite(filename,{1,'','accuracy','=',accu},sheet,position);

    %position=['E',num2str(row+1)];
    %xlswrite(filename,xber,sheet,position);%写y

    row=row+1;
    position=['A',num2str(row+1)];
    chardata={1,'','平均循环次数','='};
    
    xlswrite(filename,chardata,sheet,position);%写循环次数
    
    position=['E',num2str(row+1)];
    xlswrite(filename,AverageCycle,sheet,position);

    row=row+1;
    position=['A',num2str(row+1)];
    chardata={1,'','FER','='};
    xlswrite(filename,chardata,sheet,position);%写成功率数据
    
    position=['E',num2str(row+1)];
    xlswrite(filename,percent,sheet,position);
    fprintf('存储数据完成\n\n');
    
end

fprintf('程序执行完毕！\n');
title('Bit Error Rate');
xlabel('SNR (dB)');
ylabel('BER');
%semilogy(EbN0, ber1, 's-k');
semilogy(EbN0, ber2, 'd--k');
legend('BP译码','Log-BP','MS最小和译码');
grid on;
hold on;
hold off;