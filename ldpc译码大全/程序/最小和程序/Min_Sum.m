%生成H矩阵
clc;clear;close all;
t0=cputime;

SNR_min=2;
SNR_max=2;
step=0.2;
err_max=50;

load Matrix(2016,1008)Block56.mat
mat_56_56_1=diag(ones(1,56));%生成56*56的对角阵
mat_56_56_0=diag(zeros(1,56));%生成56*56的0阵
H_mat=[];%初始化H_mat,H_mat就是所需的H矩阵
for ii=1:36
    x=[];%初始化x
    for jj=1:18
        if (H_block((ii-1)*18+jj)==0)
            a=mat_56_56_0;
        else
            a=[mat_56_56_1(H_block((ii-1)*18+jj):56,:);mat_56_56_1(1:(H_block((ii-1)*18+jj)-1),:)];
        end
        x=[x;a];
    end
    H_mat=[H_mat,x];
end
H_mat(1,1008)=0;%解决Hp右上角的a
Hp=H_mat(:,1:1008);
Hs=H_mat(:,1009:2016);
%
%
for SNR=SNR_min:step:SNR_max
    times=0;
    err=0;
    err_frame=0;
    while (err_frame<err_max& times<50000)%错误<50，不断循环

        src=randint(1,1008);
        x_temp=src*Hs';
        check_bit=[];%表示校验比特序列
        check_temp=[1];%为了按顺序生成校验比特，用来表示已经生成bit的位置
        while(length(check_temp)<1008)
            for ii=1:1008
                if ii==1
                    check_bit(ii)=mod(x_temp(ii),2);
                elseif ii>1 & ii<=56 & length(find(check_temp==(952+ii-1))) & (length(find(check_temp==ii))==0)
                    check_bit(ii)=mod(x_temp(ii)+check_bit(952+ii-1),2);
                    check_temp=[check_temp,ii];
                elseif ii>56 & length(find(check_temp==(ii-56))) &(length(find(check_temp==ii))==0)
                    check_bit(ii)=mod(x_temp(ii)+check_bit(ii-56),2);
                    check_temp=[check_temp,ii];
                else
                    check_temp=check_temp;%缓存一步
                end
            end
        end
        src_check=[check_bit,src];%编码后结果，校验位在前，信息位在后
        %

        %
        BPSK_src=-(2*src_check-1);%0->1,1->-1
        BPSK_src_t=awgn(BPSK_src,SNR);




        BPSK_src_r=BPSK_src_t;
        %

        u0=4*BPSK_src_r(1:2016).*10^(SNR/10);%计算u0
        en=1;mm=0;
        v=zeros(1,2016);

        u_mat=zeros(size(H_mat));%1008*2016
        v_mat=u_mat';%2016*1008
        while (mm<=30 & en)
            %ii为2016 jj为1008

            for jj=1:1008
                kk_temp=find(H_mat(jj,:)==1);
                kk=length(kk_temp);
                for ii=1:kk
                    u_mat(jj,kk_temp(ii))=prod(sign(v_mat(kk_temp([1:ii-1,ii+1:kk]),jj)))*min(abs(v_mat(kk_temp([1:ii-1,ii+1:kk]),jj)));
                end
            end
            for ii=1:2016
                kk_temp=find(H_mat(:,ii)==1)';
                kk=length(kk_temp);%H_mat某列为1的个数
                for jj=1:kk
                    v_mat(ii,kk_temp(jj))=u0(ii)+sum(u_mat(kk_temp([1:jj-1,jj+1:kk]),ii));%除jj以外的相加
                end
            end

            v_sum=sum (u_mat,1)+u0;
            for ii=1:2016
                if v_sum(ii)<0
                    v(1,ii)=1;
                else
                    v(1,ii)=0;
                end
            end
            en=length(find(mod(v*H_mat',2)==1));
            mm=mm+1;
        end
        err_bit=length(find(v(1009:2016)-src)==1);
        err=err_bit+err;
        err_frame=err_frame+sign(err_bit);
        times=times+1;%每编一个1008码 就+1
    end

    err_rate(int8((SNR-SNR_min)/step+1))=(err)/1008/(times);
    err_frame_rate(int8((SNR-SNR_min)/step+1))=(err_frame)/(times);
    save MS.mat
end
semilogy(SNR_min:step:SNR_max,err_rate);
