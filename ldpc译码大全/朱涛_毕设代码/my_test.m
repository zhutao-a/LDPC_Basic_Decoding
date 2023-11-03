                                %��Ҫ�Լ��������EBN0
clc; 
clear all;
M = 256;            %����У�����H��СΪM*N
N = 512;
EbN0 =3.5;         %�����DB
iter = 20;           %��������
frame = 1000;        %֡��
ber=0;              %��ʼ���������
ser=0;              %��ʼ����֡��
averageiter=0;        %��ʼ��ƽ����������
sum=0;
dSource = round(rand(M, frame));                %����5000����Ϣ����m*5000
c=zeros(M,frame);                               %����n-m*1��У������frame��
load L1;                %��ͬһ��У�����
load U1;
load newH;
for j=1:frame
    z = mod(newH(:, (N - M) + 1:end)*dSource(:,j), 2);
    c(:,j) = mod(U1\(L1\z), 2);                   %����У��λn-m*1��frame��
    if mod(j,500)==0
        fprintf('EbN0 : %d\n', EbN0);
    end
end
tic;
for j = 1:frame                                 %��ѡ��5000����Ϣ�����е�һ�н������㣬��m*1
    fprintf('Frame : %d\n', j);
     u = [c(:,j); dSource(:, j)];                                    %�õ�ʵ�ʵķ�������n*1
     bpskMod = 2*u - 1;                                         %bpsk����
     N0 = 2/(exp(EbN0*log(10)/10));                             %��ȡƽ����������
     tx = bpskMod + sqrt(N0/2)*randn(size(bpskMod));            %�õ�ʵ�ʽ��յ�������n*1
     [realiter,vhat]=decodeLogDomain(tx, newH,N0, iter);             %��ù�������1*n
     [num, rat] = biterr(vhat', u);                             %�ȽϷ������ֺ͹������ִ�����
     averageiter=averageiter+realiter;
     ber= (ber + rat);                                          %����������
     if num~=0
         ser=ser+1;
     end
     sum=sum+num;
end 
ber = ber/frame;                                                %��ƽ��ֵ
ser = ser/frame; 
averageiter=averageiter/frame;
fprintf('����ȣ�');
disp(EbN0);
fprintf('������ʣ�');
disp(ber);
fprintf('�����ʣ�');
disp(ser);
fprintf('�ܴ����������');
disp(sum);
fprintf('ƽ������������');
disp(averageiter);
toc;