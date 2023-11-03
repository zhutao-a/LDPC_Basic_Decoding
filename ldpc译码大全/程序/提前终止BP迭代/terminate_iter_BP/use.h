#ifndef _USE_H_
#define _USE_H_

#include "stdlib.h"
#include "math.h"
#define LRMAX 1e307//30//
typedef unsigned int UINT;
#define PI 3.1415926
void sort(double *data,unsigned int n,int *index);//sort the data,the array "index" 


bool sort(double *data,unsigned int n,unsigned int *index);//sort the data,the array "index" 

void sort(double *data,long long n);//sort the data,the array "index" 

double gran(void);

void randvec(double *y,int N, double sigma);// fill y with mean= -1 and variance sigma^2 Gaussian. This corresponds to the all-zero vector

void sort(unsigned int *data,unsigned int n);

double Cprob0(double y,double sigma);
double Cprob1(double y,double sigma);

#endif