%%%% girth8-8,8

function [H,p,J,L]=girth8_6_9()

J=6;
L=9;
p=734;
shifter2=[0,2,4,6,8,10,12,14,16];
shifter3=[0,9,18,27,36,45,54,63,72];
shifter4=[0,13,26,39,52,65,78,91,104];
shifter5=[0,20,40,60,80,100,120,140,160];
shifter6=[0,22,44,66,88,110,132,154,176];

P=eye(p);
% i=length(shifter);

p21=circshift(P,shifter2(1));
p22=circshift(P,shifter2(2));
p23=circshift(P,shifter2(3));
p24=circshift(P,shifter2(4));
p25=circshift(P,shifter2(5));
p26=circshift(P,shifter2(6));
p27=circshift(P,shifter2(7));
p28=circshift(P,shifter2(8));
p29=circshift(P,shifter2(9));

p31=circshift(P,shifter3(1));
p32=circshift(P,shifter3(2));
p33=circshift(P,shifter3(3));
p34=circshift(P,shifter3(4));
p35=circshift(P,shifter3(5));
p36=circshift(P,shifter3(6));
p37=circshift(P,shifter3(7));
p38=circshift(P,shifter3(8));
p39=circshift(P,shifter3(9));

p41=circshift(P,shifter4(1));
p42=circshift(P,shifter4(2));
p43=circshift(P,shifter4(3));
p44=circshift(P,shifter4(4));
p45=circshift(P,shifter4(5));
p46=circshift(P,shifter4(6));
p47=circshift(P,shifter4(7));
p48=circshift(P,shifter4(8));
p49=circshift(P,shifter4(9));

p51=circshift(P,shifter5(1));
p52=circshift(P,shifter5(2));
p53=circshift(P,shifter5(3));
p54=circshift(P,shifter5(4));
p55=circshift(P,shifter5(5));
p56=circshift(P,shifter5(6));
p57=circshift(P,shifter5(7));
p58=circshift(P,shifter5(8));
p59=circshift(P,shifter5(9));

p61=circshift(P,shifter6(1));
p62=circshift(P,shifter6(2));
p63=circshift(P,shifter6(3));
p64=circshift(P,shifter6(4));
p65=circshift(P,shifter6(5));
p66=circshift(P,shifter6(6));
p67=circshift(P,shifter6(7));
p68=circshift(P,shifter6(8));
p69=circshift(P,shifter6(9));

H=[P   P   P   P   P   P   P   P   P ;...
  p21 p22 p23 p24 p25 p26 p27 p28 p29;...
  p31 p32 p33 p34 p35 p36 p37 p38 p39;...
  p41 p42 p43 p44 p45 p46 p47 p48 p49;...
  p51 p52 p53 p54 p55 p56 p57 p58 p59;...
  p61 p62 p63 p64 p65 p66 p67 p68 p69];
