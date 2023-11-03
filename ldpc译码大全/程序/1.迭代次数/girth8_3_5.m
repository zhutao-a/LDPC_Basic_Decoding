%%%% girth8-6,8

function [H,p,J,L]=girth8_3_5()

J=3;
L=5;
p=400;
shifter2=[0,1,2,3,4];
shifter3=[0,7,14,21,28];

P=eye(p);
% i=length(shifter);

p21=circshift(P,shifter2(1));
p22=circshift(P,shifter2(2));
p23=circshift(P,shifter2(3));
p24=circshift(P,shifter2(4));
p25=circshift(P,shifter2(5));

p31=circshift(P,shifter3(1));
p32=circshift(P,shifter3(2));
p33=circshift(P,shifter3(3));
p34=circshift(P,shifter3(4));
p35=circshift(P,shifter3(5));

H=[P   P   P   P   P;...
  p21 p22 p23 p24 p25;...
  p31 p32 p33 p34 p35];
