function system_H=system_H_gen()
msg_ram=eye(239);
system_G=zeros(239,256);
for i=1:239
    msg=msg_ram(i,:);
    ecode=ebch_encoder(msg);
    system_G(i,:)=ecode;
end

P=system_G(:,240:256);%system_G=[I,P]ʱ,���Եõ�system_H=[P',I]��ע���ʱmsg��λ��ǰ�������codeҲ�ǵ�λ��ǰ
I=eye(17);
system_H=[P',I];
