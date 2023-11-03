#include <iostream>
#include "BECconstruct.h"
#include "polar.h"
#include "time.h"
#include <iomanip>
#include <fstream>
using namespace std;
#define R 0.5
int main()
{
	clock_t start,end;
	ofstream write("result.txt");

	//UINT ploy[17]={1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1};

	UINT N,K,M,m;//码长、信息比特长度、冻结比特长度、次幂
	UINT arraylength[]={16,256,512,1024,2048};//length od codewords
	UINT power[]={4,8,9,10,11};//power of 2
	//UINT sizeLength=sizeof(arraylength)/sizeof(UINT);    

	double EbN0dB,EbN0,xx;//SNR,Bhattacharyya parameter of AWGN
	double sigma,sigma2;//noise variance
	double Lc;//channnel reliability
	double EbN0dBlist[]={0.5,1,1.5,2,2.5,3,3.5,4};
	double capacity[]={0.5239,0.5628,0.6023,0.6421,0.6817,0.7207,0.7584,0.7944};
	UINT sizeSNR=sizeof(EbN0dBlist)/sizeof(double);

	UINT arraycount;//the amount of codewords
	//UINT maxcountarray[]={500,1000,5000,10000,50000,100000,600000};//N=256
	//UINT maxcountarray[]={1000,5000,10000,100000,500000,1000000,3000000};//N=512
	//UINT maxcountarray[]={2000,6000,10000,100000,500000,1000000,3000000,10000000};//N=1024
	UINT maxcountarray[]={5000,10000,100000,500000,1000000,1000000,5000000,10000000};//N=1024
	//UINT maxcountarray[]={10000,60000,100000,600000,1000000,3000000,10000000};//N=2048
	//UINT size1=sizeof(UINT);
	//UINT size2=sizeof(double);
	//cout<<"size1="<<size1<<"  "<<"size2="<<size2<<endl;
	UINT sizeArray=sizeof(maxcountarray)/sizeof(UINT);

	UINT final_iter=0;
	UINT maxitercount=60;
	UINT errbit=0,errblock=0,bitcount=0,blockcount=0;
	double BER,FER;
	/*for(UINT i=0;i<sizeLength;++i)//不同码长
	{*/
		N=arraylength[2];
		M=N/2;
		K=N/2;
		m=power[2];
		write<<"N="<<N<<setw(5)<<"K="<<K<<"   "<<"itercount="<<maxitercount<<endl;
		cout<<"N="<<N<<setw(5)<<"K="<<K<<"   "<<"itercount="<<maxitercount<<endl;

		UINT *frozenPos=new UINT [M];
		UINT *frozenValue=new UINT [M];
		for(UINT j=0;j<M;++j)
			frozenValue[j]=0;
		
		for(UINT j=0;j<sizeArray;++j)//码字个数
		{
			arraycount=maxcountarray[j];
			write<<"arraycount="<<arraycount<<endl;
			cout<<"arraycount="<<arraycount<<endl;	

			for(UINT k=0;k<sizeSNR;++k)//不同信噪比
			{
				EbN0dB=EbN0dBlist[0];
				EbN0=pow(10.0,EbN0dB/10.0);
				sigma2=1.0/(2*R*EbN0);
				sigma=sqrt(sigma2);
				Lc=2.0/sigma2;
				write<<"EbN0dB="<<EbN0dB<<endl;
				cout<<"EbN0dB="<<EbN0dB<<endl;

				xx=1-capacity[0];
				constructBECpolar(xx,N,K,m,frozenPos);   //find the forzen bits position
				sort(frozenPos,M);                       //ordering the forzen bits position from low to high

				polar b(N,M,m,frozenPos,frozenValue);   //initialize the object of class polar

				//write<<"final_iter:"<<endl;
				//cout<<"final_iter:"<<endl;
				errbit=0,errblock=0,bitcount=0,blockcount=0;
				start=clock();
				while(blockcount<arraycount)             
				{
					++blockcount;
					bitcount+=K;

					b.randvec();
					b.encode();
					b.channelout(sigma,Lc);
					b.call_SCANdecoding(maxitercount,final_iter);

					errbit+=b.errbitcount();
					if(b.errbitcount()!=0)
						++errblock;
					//write<<final_iter<<setw(2)<<"";
					//cout<<final_iter<<setw(2)<<"";
					
				}
				end=clock();
				BER=double(errbit)/bitcount;   
		        FER=double(errblock)/blockcount;
				write<<endl;cout<<endl;
				write<<"BER="<<BER<<setw(10)<<"FER="<<FER<<endl;
				write<<"Runtime: "<<double(end-start)/CLOCKS_PER_SEC<<endl;
				write<<endl;write<<endl;
				cout<<"BER="<<BER<<setw(10)<<"FER="<<FER<<endl;
				cout<<"Runtime: "<<double(end-start)/CLOCKS_PER_SEC<<endl;
				cout<<endl;cout<<endl;
			}	
			cout<<endl;cout<<endl;write<<endl;write<<endl;write<<endl;
		}
		delete [] frozenPos;frozenPos=NULL;
		delete [] frozenValue;frozenValue=NULL;
		//cout<<endl;cout<<endl;cout<<endl;
	//}
	return 0;
}