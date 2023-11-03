function [u_deg_per_col,u_deg_per_row]=E_adjust(E0,vn_deg_min,vn_deg_max,cn_deg_min,cn_deg_max,u_deg_per_col,u_deg_per_row)
[NP,N]=size(u_deg_per_col);
[~,M]=size(u_deg_per_row);
%�޶���Ⱥ�е���ֵ��Χ
for i=1:NP
    for j=1:N
        if(u_deg_per_col(i,j)<vn_deg_min)
            u_deg_per_col(i,j)=vn_deg_min;
        elseif(u_deg_per_col(i,j)>vn_deg_max)
            u_deg_per_col(i,j)=vn_deg_max;
        end
    end
end
%��������
for i=1:NP
    E=sum(u_deg_per_col(i,:));%�������ǰ�ı���
    if(E>=E0)%��������ǰ��
        E_delete=0;
        while(E_delete~=(E-E0))
            nomin_index=find(u_deg_per_col(i,:)~=vn_deg_min);
            col=randi(length(nomin_index));%ɾ���ߵ��е�����
            u_deg_per_col(i,nomin_index(col))=u_deg_per_col(i,nomin_index(col))-1;
            E_delete=E_delete+1;
        end
    else%��������ǰ��
        E_add=0;
        while(E_add~=(E0-E))
            nomax_index=find(u_deg_per_col(i,:)~=vn_deg_max);
            col=randi(length(nomax_index));%ɾ���ߵ��е�����
            u_deg_per_col(i,nomax_index(col))=u_deg_per_col(i,nomax_index(col))+1;
            E_add=E_add+1;
        end
    end
end


%�޶���Ⱥ�е���ֵ��Χ
for i=1:NP
    for j=1:M
        if(u_deg_per_row(i,j)<cn_deg_min)
            u_deg_per_row(i,j)=cn_deg_min;
        elseif(u_deg_per_row(i,j)>cn_deg_max)
            u_deg_per_row(i,j)=cn_deg_max;
        end
    end
end
%��������
for i=1:NP
    E=sum(u_deg_per_row(i,:));%�������ǰ�ı���
    if(E>=E0)%��������ǰ��
        E_delete=0;
        while(E_delete~=(E-E0))
            nomin_index=find(u_deg_per_row(i,:)~=cn_deg_min);
            row=randi(length(nomin_index));%ɾ���ߵ��е�����
            u_deg_per_row(i,nomin_index(row))=u_deg_per_row(i,nomin_index(row))-1;
            E_delete=E_delete+1;
        end
    else%��������ǰ��
        E_add=0;
        while(E_add~=(E0-E))
            nomax_index=find(u_deg_per_row(i,:)~=cn_deg_max);
            row=randi(length(nomax_index));%ɾ���ߵ��е�����
            u_deg_per_row(i,nomax_index(row))=u_deg_per_row(i,nomax_index(row))+1;
            E_add=E_add+1;
        end
    end
end



