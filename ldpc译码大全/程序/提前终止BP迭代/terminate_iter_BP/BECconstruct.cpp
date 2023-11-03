#include "BECconstruct.h"


void bitReversal(unsigned int *ivec,int len,int pow)
{
	int pow2=pow;//log2(len);
	
	int *tmpvec=new int [pow2];
	int tmpint=0;
	unsigned mask=1;
	int i,j;
	
	for (i=0;i<len;i++)
	{
		tmpint=ivec[i];
		mask=1;
		mask<<=pow2;
		for (j=0;j<pow2;j++)
		{
			tmpint<<=1;
			tmpvec[j]=mask&tmpint;
		}
		
		mask=1;
		for (j=0;j<pow2;j++)
		{
			if (tmpvec[j])
			{
				ivec[i] |= mask;
			} 
			else
			{
				ivec[i] &= (~mask);
			}
			mask<<=1;
		}
	}
	delete [] tmpvec;
}

double Calcbhatta(unsigned int N,unsigned int j,double eP)//calc the bhatta for BEC channel 
{
	//cout<<"one"<<endl;
	//cout<<"and"<<endl;
	if(N==1)
		return eP;
	unsigned int temp=j/2;
	if(j%2!=0)
	{
		//cout<<"odd"<<" ";
		double temp1=Calcbhatta(N/2,temp+1,eP);
		return 2*temp1-temp1*temp1;
	}
	else
	{
		//cout<<"even"<<" ";
		double temp2=Calcbhatta(N/2,temp,eP);
		return temp2*temp2;
	}
}
/*
void constructBECpolar(double p,unsigned int iN,unsigned int iK,unsigned int m,unsigned int *frozen)
{
	unsigned int N=iN;
	unsigned int K=iK;
	unsigned int *index=new unsigned int[N];
	double *temp=new double [N];
	for(unsigned int i=0;i<N;++i)
	{
		temp[i]=Calcbhatta(N,i+1,p);
		index[i]=i;
	}
	//VECDUMP(temp,N);
	unsigned int *reversal=new unsigned int [N];
	double *temp1=new double [N];

	for(unsigned int i=0;i<N;++i)
	{
		reversal[i]=i;
	}

	bitReversal(reversal,N,m);
	//VECDUMP(reversal,N);

	for(unsigned int i=0;i<N;++i)
	{
		temp1[reversal[i]]=temp[i];
	}
	//VECDUMP(temp1,N);
	sort(temp1,N,index);
	//VECDUMP(index,N);
	for(unsigned int i=K;i<N;++i)
	{
		frozen[i-K]=index[i];
		//cout<<index[i]<<" ";
	}
	delete [] index;
	delete [] temp;
	delete [] reversal;
	delete [] temp1;
}*/


void constructBECpolar(double p,unsigned int iN,unsigned int iK,unsigned int m,unsigned int *frozen)
{
	unsigned int N=iN;
	unsigned int K=iK;
	unsigned int *index=new unsigned int[N];
	double *temp=new double [N];
	for(unsigned int i=0;i<N;++i)
	{
		temp[i]=Calcbhatta(N,i+1,p);
		index[i]=i;
	}
	//VECDUMP(temp,N);
	/*unsigned int *reversal=new unsigned int [N];
	double *temp1=new double [N];

	for(unsigned int i=0;i<N;++i)
	{
		reversal[i]=i;
	}

	bitReversal(reversal,N,m);
	//VECDUMP(reversal,N);

	for(unsigned int i=0;i<N;++i)
	{
		temp1[reversal[i]]=temp[i];
	}*/
	//VECDUMP(temp1,N);
	sort(temp,N,index);
	//VECDUMP(index,N);
	for(unsigned int i=K;i<N;++i)
	{
		frozen[i-K]=index[i];
		//cout<<index[i]<<" ";
	}
	delete [] index;
	delete [] temp;
	//delete [] reversal;
	//delete [] temp1;
}