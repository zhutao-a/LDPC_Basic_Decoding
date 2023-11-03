function snr_out = RCA_threshold(H,snr_dB_start,puncture_idx,R,snr_R,iter)
snr_step_array = [10, 1, 0.1, 0.01];
snr_dB = snr_dB_start;

for istep = 1:length(snr_step_array)
    snr_step = snr_step_array(istep);
    go = 1;
    while(go)
        snr_dB = snr_dB - snr_step;
        [flag] = RCA_apprx(H,snr_dB,puncture_idx,R,snr_R,iter);
        if flag == 0 
            go = 0;
            snr_out = snr_dB + snr_step;
        end
    end
    snr_dB = snr_dB + snr_step;
end
end

