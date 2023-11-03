function [w2_idx,type,weight]=constraint2(group)
%group的大小为(4,368)
weight=zeros(1,368);
for i=1:368
    weight(i)=sum(group(:,i));
end
w2_idx=find(weight==2);
len=length(w2_idx);
type=zeros(1,len);
for i=1:len
    if(group(1,w2_idx(i))==1&&group(2,w2_idx(i))==1)
        type(i)=12;
    end
    if(group(1,w2_idx(i))==1&&group(3,w2_idx(i))==1)
        type(i)=13;
    end
    if(group(1,w2_idx(i))==1&&group(4,w2_idx(i))==1)
        type(i)=14;
    end
    if(group(2,w2_idx(i))==1&&group(3,w2_idx(i))==1)
        type(i)=23;
    end
    if(group(2,w2_idx(i))==1&&group(4,w2_idx(i))==1)
        type(i)=24;
    end
    if(group(3,w2_idx(i))==1&&group(4,w2_idx(i))==1)
        type(i)=34;
    end
end




