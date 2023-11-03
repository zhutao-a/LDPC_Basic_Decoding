clc
clear all
rng(3);

frame_num =50;
Eb_N0 =0:0.2:4;
err_threshold = 50;


%--------------------------------------------------------------------------
% 产生polar编码矩阵
N =256;
F = [1 0; 1 1];
G = F;
for n = 1:log2(N)-1
    G = kron(G,F);
end
[alpha] = bit_re_order( N );

if N == 1024
    load info_bit_flag_1024.mat;
    K = 512;
elseif N == 256
    load info_bit_flag_256.mat;
    K = 128;
end
info_bit_index = find(info_bit_flag==1);

H = G(:,setdiff(1:N, info_bit_index))';
tmp1(info_bit_index) =1;
% 定义CRC编码器;
crc_len = 24;
CRC24A = [ 1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1 ];
CrcCoder24A = crc.generator(...
    'Polynomial',           CRC24A,...
    'InitialConditions',    ones(1,24));     
CrcDeCoder24A = crc.detector(...
    'Polynomial',           CRC24A,...
    'InitialConditions',    ones(1,24));     
%--------------------------------------------------------------------------
count=1;
BLER = zeros(1, numel(Eb_N0));
BLER1 = zeros(1, numel(Eb_N0));
BLER2 = zeros(1, numel(Eb_N0));
BLER3 = zeros(1, numel(Eb_N0));
for snr_idx = 1:numel(Eb_N0)
    err_tb_num = 0;
    err_tb_num1 = 0;
    err_tb_num2 = 0;
    err_tb_num3 = 0;
    for frame_id = 1:frame_num
        % 产生源信息
        tb_data = randi([0,1], 1, K);
        % 将信息比他加载到编码信息位
        tmp = zeros(1,N);
        tmp(info_bit_index) = tb_data;
        % polar编码 
        v=encode(N,G,tmp);
         %v1= mod(tmp*G, 2);
        % 比特反序重排
        x = v(alpha);
        % BPSK调制
        mod_out = 1-2*v;
        mod_out1 = 1-2*x;
        % 过AWGN信道
        Rate=K/N;
        sigma2 =1/(2*Rate*Eb_N0(snr_idx));
        noise = sqrt(sigma2)*randn(1,N);
        y = mod_out+noise;
        y1 = mod_out1+noise;
        % 计算软信息
        z = 2*y/sigma2;
        z1 = 2*y1/sigma2;
        % polar译码
        [ decode_out ] = BP_decoder1( z,tmp1,N );    %原始BP译码
        [ decode_out1 ] = BP_decoder2( z,tmp1,N );    %最小和BP译码
        [ decode_out2 ] = BP_decoder3( z,tmp1,N );    %alfa BP译码
        %[decode_out3] = polar_decoder(z1, N, info_bit_index);%SC译码
       % x = mod(decode_out*G(:,info_bit_index), 2);
        x=decode_out(info_bit_index);
        x1=decode_out1(info_bit_index);
        x2=decode_out2(info_bit_index);
       % x3=decode_out3(info_bit_index);
        % 统计
        err_decode_out=(K-sum(x==tb_data'));
        err_decode_out1=(K-sum(x1==tb_data'));
        err_decode_out2=(K-sum(x2==tb_data'));
       % err_decode_out3=(K-sum(x3==tb_data'));
        err_tb_num = err_tb_num +err_decode_out;
        err_tb_num1 = err_tb_num1 +err_decode_out1;
        err_tb_num2 = err_tb_num2 +err_decode_out2;
       % err_tb_num3 = err_tb_num3 +err_decode_out3;
        %fprintf('Eb/N0 = %.2f, framdId = %d, err = %d,err1 = %d,err2 = %d,err3 = %d, errTBNum = %d\n',  Eb_N0(snr_idx), frame_id, a,a1,a2,a3, err_tb_num);
       fprintf('Eb/N0 = %.2f, framdId = %d, err = %d, err1 = %d,err2 = %d,errTBNum = %d\n,errTBNum1 = %d\n,errTBNum2 = %d\n',... 
            Eb_N0(snr_idx), frame_id,err_decode_out,err_decode_out1,err_decode_out2, err_tb_num,err_tb_num1,err_tb_num2);
    end   
   % count=count*1.9;
    BLER(snr_idx) = err_tb_num/frame_num/N;
    BLER1(snr_idx) = err_tb_num1/frame_num/N;
    BLER2(snr_idx) = err_tb_num2/frame_num/N;
    %BLER3(snr_idx) = err_tb_num3/frame_num/N;
end

semilogy(Eb_N0, BLER,'r');
xlabel('信噪比/dB');
ylabel('误比特率');
hold on
semilogy(Eb_N0, BLER1,'b');
semilogy(Eb_N0, BLER2,'g');
semilogy(Eb_N0, BLER3,'k');
hold off









