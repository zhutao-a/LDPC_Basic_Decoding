function data=max_constraint(data,max_value)%���ƾ���ֵ��С
[M,N]=size(data);
for i=1:M
    for j=1:N
        if(data(i,j)>max_value)
            data(i,j)=max_value;
        elseif(data(i,j)<-max_value)
             data(i,j)=-max_value;
        end
    end
end