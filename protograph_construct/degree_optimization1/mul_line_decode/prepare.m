function [msg_len,puncture_idx,start_col]=prepare()
%���������а���80������飬�����䳤��Ϊ80����
%msg_lenȡֵ3��4��5,puncture_idxȡֵΪ[0->6](ʵ��ȡ0��2)��0��������Ϣ��msg����puncture�У�����msg��Ӧ�к�puncture��
msg_len=zeros(1,80);
puncture_idx=zeros(1,80);
start_col=zeros(1,80);
start_col(1)=363;
odd_row=1;%�����л���ż����
for row=1:80
    if(odd_row==1)  %������Ϊ4��ż����Ϊ3
        base_len=4;
    else
        base_len=3;  
    end
    msg_len(row)=base_len;
    for i=1:base_len%�жϸ���Ϣ���Ƿ������puncture����
        result=whether_punctured(start_col(row)+i-1);
        if(result==1)%�б�puncture����
            msg_len(row)=msg_len(row)+1;
            puncture_idx(row)=i;
            break;
        end
    end
    if(row==80) 
        break;
    end
    start_col(row+1)=mod(start_col(row)+(msg_len(row)+1)-1,368)+1;%[1->368]֮��
    odd_row=~odd_row;
end


