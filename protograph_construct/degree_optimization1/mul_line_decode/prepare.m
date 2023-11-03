function [msg_len,puncture_idx,start_col]=prepare()
%整个码字中包含80个输入块，即记忆长度为80个块
%msg_len取值3、4、5,puncture_idx取值为[0->6](实际取0、2)，0表明该消息块msg不含puncture列，否则msg对应列含puncture列
msg_len=zeros(1,80);
puncture_idx=zeros(1,80);
start_col=zeros(1,80);
start_col(1)=363;
odd_row=1;%奇数行还是偶数行
for row=1:80
    if(odd_row==1)  %奇数行为4，偶数行为3
        base_len=4;
    else
        base_len=3;  
    end
    msg_len(row)=base_len;
    for i=1:base_len%判断该消息块是否包含被puncture的列
        result=whether_punctured(start_col(row)+i-1);
        if(result==1)%有被puncture的列
            msg_len(row)=msg_len(row)+1;
            puncture_idx(row)=i;
            break;
        end
    end
    if(row==80) 
        break;
    end
    start_col(row+1)=mod(start_col(row)+(msg_len(row)+1)-1,368)+1;%[1->368]之间
    odd_row=~odd_row;
end


