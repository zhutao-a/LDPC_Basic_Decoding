function [sigma_out,final_Pe]=GA_th_punc(sigma_min,sigma_max,iter,Pe,deg_per_col,deg_per_row,punc_idx)
%二分法计算迭代阈值
%带有puncture的高斯近似
gap=sigma_max-sigma_min;%求出此时的gap
min_gap=0.00001;%跳出程序的最小gap
%判断最小的噪声是否可译码
[flag,final_Pe]=GA_apprx(sigma_min,iter,Pe,deg_per_col,deg_per_row,punc_idx);
if(flag==0)%最小的噪声也不能译码，则赋值为sigma_min-0.1并退出程序
    sigma_out=sigma_min-0.1;
    return;
end

while(gap>min_gap)
    sigma=(sigma_max+sigma_min)/2;%取均值
    %判断此时的噪声是否可译码
    [flag,final_Pe]=GA_apprx(sigma_min,iter,Pe,deg_per_col,deg_per_row,punc_idx);
    if(flag==1)%可译码
        sigma_min=sigma;
    else%不满足要求
        sigma_max=sigma;
    end
    sigma_out=sigma_min;%取较小的噪声作为输出
    gap=sigma_max-sigma_min;%求出迭代一轮后的gap
end


