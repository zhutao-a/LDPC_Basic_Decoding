function code=encoder(msg)
code=zeros(256,256);
%�б���
for i=1:239
    ecode=lfsr_encoder(msg(i,:));
    code(i,:)=ecode;
end
%�б���
for i=1:256
    temp=code(1:239,i);
    ecode=lfsr_encoder(temp);
    code(:,i)=ecode;
end

