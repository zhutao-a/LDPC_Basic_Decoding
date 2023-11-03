function [mat] = util_mask(mat)
[nc,nv]=size(mat);
mat(nc,nv-nc+1:nv)=-1;
mat(:,nv)=-1;
mat(nc,nv)=0;
end

