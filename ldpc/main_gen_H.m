clear;
clear all;

N=256;
M=17;
Dv=3*ones(1,256);
DoYouWantACE=1;

H = ProgressiveEdgeGrowth(N, M, Dv, DoYouWantACE);

dv=sum(H,1);
dc=sum(H,2)';


save H;
