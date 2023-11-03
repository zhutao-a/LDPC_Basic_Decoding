clear;
clear all;
tic;
load H;

n_max=6;
sigma_n=linspace(0.3800,0.3000,n_max);
% sigma_n=[];
sigma_n=roundn(sigma_n,-4);
frame=100;
code=zeros(1,256);
for n=1:n_max
    disp(n);
    sigma=sigma_n(n);
    rber_bit=0;
    fer_frame=0;
    ber_bit=0;
    for i=1:frame
        n_code=noise_code(code,sigma,i);
        %º∆À„rber
        rber_bit=rber_bit+error_count(n_code,code);
        [hard_decision,rx_update] = decode_NMS_modified(n_code,n_code,0.8,H,10);
        %º∆À„ber”Îfer
        temp=error_count(rx_update,code);
        if(temp~=0) 
            fer_frame=fer_frame+1;  
        end
        ber_bit=ber_bit+temp;
    end
    save_data('./result/data.txt',sigma,frame,rber_bit/(256*frame),fer_frame/frame,ber_bit/(256*frame));
end
toc;




