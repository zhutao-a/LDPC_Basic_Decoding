function save_data(file_name,sigma,frame,rber,fer,ber)

fid=fopen(file_name,'a');

fprintf(fid,'sigma:%.4f\t',sigma);
fprintf(fid,'frame:%d\t',frame);
fprintf(fid,'rber:%.4e\t',rber);
fprintf(fid,'fer:%.4e\t',fer);
fprintf(fid,'ber:%.4e\r\n',ber);

fclose(fid);

