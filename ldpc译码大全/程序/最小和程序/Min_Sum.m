%����H����
clc;clear;close all;
t0=cputime;

SNR_min=2;
SNR_max=2;
step=0.2;
err_max=50;

load Matrix(2016,1008)Block56.mat
mat_56_56_1=diag(ones(1,56));%����56*56�ĶԽ���
mat_56_56_0=diag(zeros(1,56));%����56*56��0��
H_mat=[];%��ʼ��H_mat,H_mat���������H����
for ii=1:36
    x=[];%��ʼ��x
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
H_mat(1,1008)=0;%���Hp���Ͻǵ�a
Hp=H_mat(:,1:1008);
Hs=H_mat(:,1009:2016);
%
%
for SNR=SNR_min:step:SNR_max
    times=0;
    err=0;
    err_frame=0;
    while (err_frame<err_max& times<50000)%����<50������ѭ��

        src=randint(1,1008);
        x_temp=src*Hs';
        check_bit=[];%��ʾУ���������
        check_temp=[1];%Ϊ�˰�˳������У����أ�������ʾ�Ѿ�����bit��λ��
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
                    check_temp=check_temp;%����һ��
                end
            end
        end
        src_check=[check_bit,src];%���������У��λ��ǰ����Ϣλ�ں�
        %

        %
        BPSK_src=-(2*src_check-1);%0->1,1->-1
        BPSK_src_t=awgn(BPSK_src,SNR);




        BPSK_src_r=BPSK_src_t;
        %

        u0=4*BPSK_src_r(1:2016).*10^(SNR/10);%����u0
        en=1;mm=0;
        v=zeros(1,2016);

        u_mat=zeros(size(H_mat));%1008*2016
        v_mat=u_mat';%2016*1008
        while (mm<=30 & en)
            %iiΪ2016 jjΪ1008

            for jj=1:1008
                kk_temp=find(H_mat(jj,:)==1);
                kk=length(kk_temp);
                for ii=1:kk
                    u_mat(jj,kk_temp(ii))=prod(sign(v_mat(kk_temp([1:ii-1,ii+1:kk]),jj)))*min(abs(v_mat(kk_temp([1:ii-1,ii+1:kk]),jj)));
                end
            end
            for ii=1:2016
                kk_temp=find(H_mat(:,ii)==1)';
                kk=length(kk_temp);%H_matĳ��Ϊ1�ĸ���
                for jj=1:kk
                    v_mat(ii,kk_temp(jj))=u0(ii)+sum(u_mat(kk_temp([1:jj-1,jj+1:kk]),ii));%��jj��������
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
        times=times+1;%ÿ��һ��1008�� ��+1
    end

    err_rate(int8((SNR-SNR_min)/step+1))=(err)/1008/(times);
    err_frame_rate(int8((SNR-SNR_min)/step+1))=(err_frame)/(times);
    save MS.mat
end
semilogy(SNR_min:step:SNR_max,err_rate);
