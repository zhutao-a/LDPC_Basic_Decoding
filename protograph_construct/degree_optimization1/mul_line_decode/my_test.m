clear;
clear all;
H=load('H_new.txt');
[msg_len,puncture_idx,start_col]=prepare();
msg_len=circshift(msg_len,-1);
c_w=zeros(1,368);
for i=1:368%列重
    c_w(i)=length(find(H(:,i)~=-1));
end

position=find(c_w~=3);
difference=zeros(1,15);
for i=1:15
    difference(i)=position(i+1)-position(i);
end
puncture_col=[1,11,21,31,42,54,67,77,88,100,113,123,134,146,158,159,169,178,187,196,205,215,226,238,251,261,270,279,288,297,307,318,330,343,353,364];





code_len=msg_len+1;
A=zeros(80,368);
for i=1:80
    for j=1:368
        if(H(i,j)~=-1)
            A(i,j)=1;
        end
    end
end
weight=zeros(20,368);
for i=1:20
    [~,weight(i,:)]=constraint1(A((i-1)*4+1:i*4,:));
end


%列约束1：对于每一列而言，20组中最多有一个2
% for i=1:368
%     c1=length(find(weight(:,i)==2));
%     if(c1>1)
%         disp(i);
%         disp('error');
%     end
% end


% disp(weight);

%行约束：2的列位置在交叠处
% for i=1:20
%     c1=find(weight(i,:)==2);
%     len=length(c1);
%     if(i==1)
%         start_idx=1;
%     else
%         start_idx=sum(code_len(1:4*(i-1)))+1;
%     end
%     end_idx=sum(code_len(1:4*i));
%     for j=1:len
%         if(c1(j)<start_idx||c1(j)>end_idx)
%             disp('error');
%         end
%     end
% end

%列约束2：同一组内交叠区中1必须在码字块的上面(两visio中两虚线框内列重为1)
% for i=1:20
%     if(i==1)
%         start_idx=1;
%     else
%         start_idx=sum(code_len(1:4*(i-1)))+1;
%     end
%     end_idx=sum(code_len(1:4*i));
%     group=A((i-1)*4+1:i*4,start_idx:end_idx);
%     four_col=code_len((i-1)*4+1:i*4);
%     
%     for j=1:four_col(1)
%         weight_col1=group(:,j);
%         if(weight_col1>1)
%             disp('error');
%         end
%     end
%     for j=1:four_col(2)
%         weight_col1=group(2:3,j);
%         if(weight_col1>1)
%             disp('error');
%         end
%     end
%     for j=1:four_col(3)
%         weight_col1=group(1:2,j);
%         if(weight_col1>1)
%             disp('error');
%         end
%     end
%     for j=1:four_col(3)
%         weight_col1=group(3:4,j);
%         if(weight_col1>1)
%             disp('error');
%         end
%     end
%     for j=1:four_col(4)
%         weight_col1=group(1:3,j);
%         if(weight_col1>1)
%             disp('error');
%         end
%     end
% end
new_code_len=code_len;
for i=1:80
    col=sum(code_len(1:i));
    a=A(i,col);
    if(a==0)
        new_code_len(i)=new_code_len(i)-1;
        new_code_len(i+1)=new_code_len(i+1)+1;
    end
end
% 
% for i=1:80
%    col=sum(new_code_len(1:i));
%     a=A(i,col);
%     if(a==0)
%         disp('error');
%     end 
% end
% 
% 
% dlmwrite('code_len.txt',new_code_len,'delimiter','\t');

punctur_idx=zeros(2,80);


increase_len=zeros(1,80);
for i=1:80
    increase_len(i)=sum(new_code_len(1:i));
end

for i=1:80
    if(i==1)
        start_col=1;
    else
        start_col=sum(new_code_len(1:i-1))+1;
    end
    end_col=sum(new_code_len(1:i));
    for j=1:36
        if(puncture_col(j)>=start_col&&puncture_col(j)<=end_col)
            punctur_idx(1,i)=puncture_col(j)-start_col+1;
            if(j<35&&j>3)%有一块要被puncture2列
                if(puncture_col(j+1)>=start_col&&puncture_col(j+1)<=end_col)%给第2列被puncture的赋值
                    punctur_idx(2,i)=puncture_col(j+1)-start_col+1;
                end
                if(puncture_col(j-1)>=start_col&&puncture_col(j-1)<=end_col)%由于第2列会覆盖第一列，因此在这复原
                    punctur_idx(1,i)=puncture_col(j-1)-start_col+1;
                end
            end
        end
    end
end
dlmwrite('punctur_idx.txt',punctur_idx,'delimiter','\t');








