clear all;
 close all;
  clc;
load ga;
load ha;
Hs=full(Ha);
ldpc_dB_test(Ga,Hs,1000,7,0.5);
