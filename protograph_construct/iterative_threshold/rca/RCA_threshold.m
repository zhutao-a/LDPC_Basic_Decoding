function snr_dB_out = RCA_threshold(H,snr_dB_min,snr_dB_max,puncture_idx,R,snr_R,iter)%���ַ����������ֵ
gap=snr_dB_max-snr_dB_min;%�����ʱ��gap
min_gap=0.001;%�����������Сgap
flag= RCA_apprx(H,snr_dB_max,puncture_idx,R,snr_R,iter);%�ж�����������Ƿ������
if(flag==0)%���������Ҳ�������룬snr_dB_out��ֵΪ100���˳�����
    snr_dB_out=100;
    return;
end
while(gap>min_gap)
    snr_dB=(snr_dB_max+snr_dB_min)/2;%ȡ��ֵ
    flag= RCA_apprx(H,snr_dB,puncture_idx,R,snr_R,iter);%�жϴ�ʱ��snr_dB�Ƿ������
    if(flag==1)%������
        snr_dB_max=snr_dB;
    else%��������
        snr_dB_min=snr_dB;
    end
    snr_dB_out=snr_dB_max;%ȡ�ϴ���������Ϊ���
    gap=snr_dB_max-snr_dB_min;%�������һ�ֺ��gap
end




