function [ch_degree,ch_index,dc_av]=rate_redress2(var_map,fixed_Rate,var_index)

vv=var_map./var_index;%求出每个度的变量节点占总变量节点的比例，即0->1积分lambda(d)*X^(d-1)，若乘以总边数E则得到每个不同度的变量节点数
dc_av=1/((1-fixed_Rate)*sum(vv));%根据码率以及求和总变量节点数得到校验节点的平均度值，即总边数E/M
ch_index(1)=floor(dc_av);ch_index(2)=ch_index(1)+1;
ch_degree(ch_index(1))=ch_index(1)*ch_index(2)/dc_av-ch_index(1);
ch_degree(ch_index(2))=1-ch_degree(ch_index(1));
