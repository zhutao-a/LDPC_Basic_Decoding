function [H1,P1,rearranged_cols1]=load_mat
load('H440x8632.mat');
load('P440x8632(8192).mat');
load('rearranged_cols440x8632.mat');
H1=H;
P1=P;
rearranged_cols1=rearranged_cols;