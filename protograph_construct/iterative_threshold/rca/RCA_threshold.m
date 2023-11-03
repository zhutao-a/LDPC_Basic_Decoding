function snr_dB_out = RCA_threshold(H,snr_dB_min,snr_dB_max,puncture_idx,R,snr_R,iter)%二分法计算迭代阈值
gap=snr_dB_max-snr_dB_min;%求出此时的gap
min_gap=0.001;%跳出程序的最小gap
flag= RCA_apprx(H,snr_dB_max,puncture_idx,R,snr_R,iter);%判断最大的信噪比是否可译码
if(flag==0)%最大的信噪比也不能译码，snr_dB_out赋值为100并退出程序
    snr_dB_out=100;
    return;
end
while(gap>min_gap)
    snr_dB=(snr_dB_max+snr_dB_min)/2;%取均值
    flag= RCA_apprx(H,snr_dB,puncture_idx,R,snr_R,iter);%判断此时的snr_dB是否可译码
    if(flag==1)%可译码
        snr_dB_max=snr_dB;
    else%不可译码
        snr_dB_min=snr_dB;
    end
    snr_dB_out=snr_dB_max;%取较大的信噪比作为输出
    gap=snr_dB_max-snr_dB_min;%求出迭代一轮后的gap
end




