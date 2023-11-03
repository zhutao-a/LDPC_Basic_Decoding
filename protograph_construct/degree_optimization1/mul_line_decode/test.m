clear;
clear all;
tic;
H=load('base_matrix.txt');
r_w=zeros(1,80);
c_w=zeros(1,368);
for i=1:80%行重
    r_w(i)=length(find(H(i,:)~=-1));
end
for i=1:368%列重
    c_w(i)=length(find(H(:,i)~=-1));
end
disp(find(c_w~=3));
[msg_len,puncture_idx,start_col]=prepare();
H=circshift(H,-1);
msg_len=circshift(msg_len,-1);
code_len=msg_len+1;

A=zeros(80,368);
for i=1:80
    for j=1:368
        if(H(i,j)~=-1)
            A(i,j)=1;
        end
    end
end
new_code_len=zeros(1,20);
for i=1:20
    new_code_len(i)=sum(code_len((i-1)*4+1:i*4));
end
H_new=H;
start_col=1;
for i=1:20
    four_col=code_len((i-1)*4+1:i*4);
    [w2_idx,type,weight]=constraint2(A((i-1)*4+1:i*4,:));
    len=length(w2_idx);
    for j=1:len
        if(type(j)==12)
            if( ( w2_idx(j) < (start_col+four_col(1)) )   ||  ( w2_idx(j)    >=  (start_col+four_col(1)+four_col(2)) )   )
                for k=1:four_col(2)
                    if(weight(start_col+four_col(1)+k-1)~=2)%交换列和列重
                        temp=H_new(:,start_col+four_col(1)+k-1);
                        H_new(:,start_col+four_col(1)+k-1)=H_new(:,w2_idx(j));
                        H_new(:,w2_idx(j))=temp;
                        temp=weight(start_col+four_col(1)+k-1);
                        weight(start_col+four_col(1)+k-1)=weight(w2_idx(j));
                        weight(w2_idx(j))=temp;
                        break;
                    end
                    if(k==four_col(2))
                        disp('error');
                    end
                end
            end
        elseif(type(j)==13||type(j)==23)
            if( ( w2_idx(j) < (start_col+four_col(1)+four_col(2)) )   ||  ( w2_idx(j)    >=  (start_col+four_col(1)+four_col(2)+four_col(3)) )   )
                for k=1:four_col(3)
                    if(weight(start_col+four_col(1)+four_col(2)+k-1)~=2)%交换列和列重
                        temp=H_new(:,start_col+four_col(1)+four_col(2)+k-1);
                        H_new(:,start_col+four_col(1)+four_col(2)+k-1)=H_new(:,w2_idx(j));
                        H_new(:,w2_idx(j))=temp;
                        temp=weight(start_col+four_col(1)+four_col(2)+k-1);
                        weight(start_col+four_col(1)+four_col(2)+k-1)=weight(w2_idx(j));
                        weight(w2_idx(j))=temp;
                        break;
                    end
                    if(k==four_col(3))
                        disp('error');
                    end
                end
            end
        else
            if( ( w2_idx(j) < (start_col+four_col(1)+four_col(2)+four_col(3)) )   ||  ( w2_idx(j)    >=  (start_col+four_col(1)+four_col(2)+four_col(3)+four_col(4)) )   )
                for k=1:four_col(4)
                    if(weight(start_col+four_col(1)+four_col(2)+four_col(3)+k-1)~=2)%交换列和列重
                        temp=H_new(:,start_col+four_col(1)+four_col(2)+four_col(3)+k-1);
                        H_new(:,start_col+four_col(1)+four_col(2)+four_col(3)+k-1)=H_new(:,w2_idx(j));
                        H_new(:,w2_idx(j))=temp;
                        temp=weight(start_col+four_col(1)+four_col(2)+four_col(3)+k-1);
                        weight(start_col+four_col(1)+four_col(2)+four_col(3)+k-1)=weight(w2_idx(j));
                        weight(w2_idx(j))=temp;
                        break;
                    end
                    if(k==four_col(4))
                        disp('error');
                    end
                end
            end
        end
    end
    start_col=start_col+new_code_len(i);
end
% disp(H_new);
% 
% dlmwrite('H_new.txt',H_new,'delimiter','\t');



sigma=0.606;

for i=1:9
    sigma=sigma-(i-1)*0.002;
    rber=normcdf(0,1,sigma);
    disp(rber);
end









toc;









