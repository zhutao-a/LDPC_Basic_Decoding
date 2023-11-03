function Rate=calculate_Rate(vn_degree,vn_edge_portion,cn_degree,cn_edge_portion)
temp1=sum(cn_edge_portion./cn_degree);
temp2=sum(vn_edge_portion./vn_degree);


Rate=1-temp1/temp2;











