function [flag,final_Pe]= GA_apprx(sigma,iter,Pe,vn_deg,vn_edge_prop,cn_deg,cn_edge_prop,punc_deg,punc_prop)%����sigma�ж��Ƿ������
vn_deg_len=length(vn_deg);
cn_deg_len=length(cn_deg);
Ecn= zeros(cn_deg_len, 1);
punc_deg_len=length(punc_deg);

Evn0=2/sigma^2*ones(vn_deg_len, 1);%��ʼ�������ڵ���ŵ���ȡ����ϢEvn0(û��punctureʱ)
for i=1:punc_deg_len%puncture��ı����ڵ���Ϣ
    for j=1:vn_deg_len
        if(punc_deg(i)==vn_deg(j))%vn_deg(j)��һ���ֱ�puncture����
            Evn0(j)=(1-punc_prop(i))*Evn0(j);%�Ա�puncture���Ĳ���ȡƽ��
        end
    end
end

Evn=Evn0;
vn_deg=vn_deg-1;
cn_deg=cn_deg-1;
%flag=1��ʾ�����룬�����ʾ��������
flag=0;
for i=1:iter
    weighted_sum = 0;
    for k = 1 : vn_deg_len%���lambda_d*phi( u_l_d(v) )(�ο��ŵ����뾭�����ִ��еķ��ű�ʾ)
        weighted_sum = weighted_sum + vn_edge_prop(k) * phi(Evn(k));
    end
    tmp = 1 - weighted_sum; 
    for k = 1 : cn_deg_len%�����Ϊcn_degree(k)��У��ڵ������Ϣ�ľ�ֵ
        [Ecn(k), ~] = phi_inverse(1 - tmp^cn_deg(k));
    end
    Ave_CN = cn_edge_prop * Ecn;%�����ж�Ϊcn_degree��У��ڵ���Ϣ��ֵ��ƽ��
    Evn = (Evn0' + vn_deg * Ave_CN)';%������յı����ڵ������Ϣ��ֵ
    final_Pe = vn_edge_prop * (1 - normcdf(sqrt(Evn/2)));%�Բ�ͬ�����ڵ��vn_degree�Ĵ��������ƽ��
    if(final_Pe < Pe)%����ǰ�������С��ָ��������ʣ�flag=1
        flag=1;
        break;
    end
end















