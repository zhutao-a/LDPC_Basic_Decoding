clear;
clear all;
R=1-17/128;
N=128;
vn_deg=[3,4];
vn_deg_prop=[0.428571428571429,0.571428571428571];
cn_deg=[26,27];
cn_deg_prop=[0.638392857142857,0.361607142857143];
[H,exactRate,nk,ERROR_FLAG] = hgen(R,N,vn_deg_prop,vn_deg,cn_deg_prop,cn_deg,1,0,[]);




