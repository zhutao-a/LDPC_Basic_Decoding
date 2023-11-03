function v_H=v_H_gen(H)
[~,N]=size(H);

v_H=zeros(3,N);

one_position=find(H(:,1)==1);
zero_position=find(H(:,1)==0);

v_H(1,:)=H(one_position(1),:);
v_H(2,:)=H(one_position(1),:);
v_H(3,:)=H(one_position(1),:);

tmp_num=length(zero_position)+nchoosek(length(one_position),2);
tmp_H=zeros(tmp_num,255);
tmp_H(1:length(zero_position),:)=H(zero_position,2:256);

num=length(zero_position);
for i=1:length(one_position)
    for j=i+1:length(one_position)
        tmp=mod(H(one_position(i),2:256)+H(one_position(j),2:256),2);
        num=num+1;
        tmp_H(num,:)=tmp;
    end
end

init_v_H=v_H(:,2:256);
temp_v_H=init_v_H;
[init_dc,init_dv]=dc_dv_gen(init_v_H);

dc=zeros(1,tmp_num);
dv=zeros(1,tmp_num);

for k=1:1000
    for i=1:3
        for j=1:tmp_num
            temp_v_H(i,:)=mod(init_v_H(i,:)+tmp_H(j,:),2);
            [dc(j),dv(j)]=dc_dv_gen(temp_v_H);
        end
        min_dv=min(dv); 
        min_dv_index=find(dv==min_dv);
        [~,j]=min(dc(min_dv_index));
        index=min_dv_index(j);
        if( (dv(index)<init_dv) || ((dv(index)==init_dv)&&(dc(index)<init_dc)) )
            init_v_H(i,:)=mod(init_v_H(i,:)+tmp_H(index,:),2);
            [init_dc,init_dv]=dc_dv_gen(init_v_H);
        end
    end
    fprintf('dc=%d,dv=%d\n',init_dc,init_dv);
end


