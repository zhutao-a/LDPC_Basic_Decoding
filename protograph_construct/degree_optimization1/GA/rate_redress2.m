function [ch_degree,ch_index,dc_av]=rate_redress2(var_map,fixed_Rate,var_index)

vv=var_map./var_index;%���ÿ���ȵı����ڵ�ռ�ܱ����ڵ�ı�������0->1����lambda(d)*X^(d-1)���������ܱ���E��õ�ÿ����ͬ�ȵı����ڵ���
dc_av=1/((1-fixed_Rate)*sum(vv));%���������Լ�����ܱ����ڵ����õ�У��ڵ��ƽ����ֵ�����ܱ���E/M
ch_index(1)=floor(dc_av);ch_index(2)=ch_index(1)+1;
ch_degree(ch_index(1))=ch_index(1)*ch_index(2)/dc_av-ch_index(1);
ch_degree(ch_index(2))=1-ch_degree(ch_index(1));
